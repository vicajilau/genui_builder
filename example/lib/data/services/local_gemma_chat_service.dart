import 'dart:async';

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

  /// The context window. The system instruction carries every component
  /// schema, so it needs more room than flutter_gemma's 1024 default.
  static const int _maxTokens = 8192;

  /// flutter_gemma keeps one engine and one active model per process, so the
  /// engine is registered once and shared by every service instance.
  static Future<void>? _engineReady;

  /// The source of the model currently installed and loaded, if any.
  static String? _loadedSource;

  InferenceChat? _chat;

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
    await _engineReady;

    if (_loadedSource != modelSource) {
      yield* _installModel();
      _loadedSource = modelSource;
    }

    final model = await FlutterGemma.getActiveModel(maxTokens: _maxTokens);

    // The controller owns the history, so each message starts a fresh chat and
    // replays it. Creating a chat closes the previous one on the same model.
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
          yield token;
        case ThinkingResponse() ||
            FunctionCallResponse() ||
            ParallelFunctionCallResponse():
          break;
      }
    }
  }

  /// Installs [modelSource], reporting download progress as chat text.
  Stream<String> _installModel() {
    final progress = StreamController<String>();
    final builder = FlutterGemma.installModel(
      modelType: ModelType.gemma4,
      fileType: ModelFileType.litertlm,
    );
    final isUrl =
        modelSource.startsWith('http://') || modelSource.startsWith('https://');
    var lastReported = -10;

    (isUrl ? builder.fromNetwork(modelSource) : builder.fromFile(modelSource))
        .withProgress((percent) {
          // `install()` skips the download when the file is already on disk,
          // in which case no progress is reported.
          if (percent >= lastReported + 10) {
            lastReported = percent;
            progress.add('Downloading model: $percent%\n');
          }
        })
        .install()
        .then(
          (_) {
            if (lastReported >= 0) progress.add('\n');
            progress.close();
          },
          onError: (Object error, StackTrace stackTrace) {
            progress.addError(error, stackTrace);
            progress.close();
          },
        );

    return progress.stream;
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
  }
}
