import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_gemma/flutter_gemma.dart';
import 'package:flutter_gemma_litertlm/flutter_gemma_litertlm.dart';

import 'chat_service.dart';

/// A [ChatService] implementation that runs a `.litertlm` model on the device
/// with flutter_gemma.
///
/// [modelSource] is either an `http(s)` URL, which is downloaded on the first
/// message and cached, or the path of a model file already on disk.
class LocalGemmaChatService implements ChatService {
  LocalGemmaChatService({
    required this.modelSource,
    required this.temperature,
    required this.systemInstruction,
  });

  final String modelSource;
  final double temperature;
  final String systemInstruction;

  /// The context window. The system instruction alone takes about 6k tokens,
  /// since it carries every component schema and example, and the history is
  /// replayed on every message.
  static const int _maxTokens = 16384;

  /// flutter_gemma keeps one engine and one active model per process, so the
  /// engine is registered once and shared by every service instance.
  static Future<void>? _engineReady;

  /// The source of the model currently installed and loaded, if any.
  static String? _loadedSource;

  InferenceChat? _chat;

  final _status = ValueNotifier<ChatServiceStatus?>(null);
  bool _disposed = false;

  @override
  ValueListenable<ChatServiceStatus?> get status => _status;

  @override
  Future<void> initialize() async {
    // The model is installed lazily on the first message, so that switching
    // to local mode in settings does not start a multi-gigabyte download.
  }

  @override
  Stream<String> sendMessage({
    required String prompt,
    required List<Map<String, dynamic>> history,
  }) async* {
    _engineReady ??= FlutterGemma.initialize(
      inferenceEngines: [LiteRtLmEngine()],
      // Models above ~2 GB do not fit the Cache API on web.
      webStorageMode: WebStorageMode.streaming,
    );

    try {
      await _engineReady;

      if (_loadedSource != modelSource) {
        await _installModel();
        _loadedSource = modelSource;
      }

      // Loading the model and reading the long system prompt are the slow
      // part, so the status stays up until the first token arrives.
      _status.value = const LoadingModel();
      final model = await FlutterGemma.getActiveModel(maxTokens: _maxTokens);

      // The controller owns the history, so each message starts a fresh chat
      // and replays it. Creating a chat closes the previous one on the model.
      await _chat?.close();
      final chat = await model.createChat(
        systemInstruction: systemInstruction,
        temperature: temperature,
        topK: 40,
      );
      _chat = chat;

      for (final message in history) {
        final text = _textOf(message);
        if (text.isEmpty) continue;
        await chat.addQueryChunk(
          Message(text: text, isUser: message['role'] == 'user'),
        );
      }
      await chat.addQueryChunk(Message(text: prompt, isUser: true));

      await for (final response in chat.generateChatResponseAsync()) {
        switch (response) {
          case TextResponse(:final token):
            _status.value = null;
            yield token;
          case ThinkingResponse() ||
              FunctionCallResponse() ||
              ParallelFunctionCallResponse():
            break;
        }
      }
    } finally {
      // The service may be disposed mid-reply, e.g. when settings change.
      if (!_disposed) _status.value = null;
    }
  }

  /// Installs [modelSource], reporting download progress through [status].
  Future<void> _installModel() {
    final builder = FlutterGemma.installModel(
      modelType: ModelType.gemma4,
      fileType: ModelFileType.litertlm,
    );
    final isUrl =
        modelSource.startsWith('http://') || modelSource.startsWith('https://');

    return (isUrl
            ? builder.fromNetwork(modelSource)
            : builder.fromFile(modelSource))
        .withProgress((percent) {
          // `install()` skips the download when the file is already on disk,
          // in which case no progress is reported.
          final current = _status.value;
          if (current is! DownloadingModel || current.percent != percent) {
            _status.value = DownloadingModel(percent);
          }
        })
        .install();
  }

  /// Joins the text parts of a message in the Gemini history format.
  static String _textOf(Map<String, dynamic> message) {
    final parts = message['parts'] as List? ?? const [];
    return parts
        .whereType<Map>()
        .map((part) => part['text'])
        .whereType<String>()
        .join();
  }

  @override
  void dispose() {
    _chat?.close();
    _chat = null;
    _disposed = true;
    _status.dispose();
  }
}
