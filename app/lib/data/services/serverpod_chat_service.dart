import 'dart:async';
import 'package:genui_client/genui_client.dart';
import 'chat_service.dart';

/// A [ChatService] implementation that connects to a real Dart Serverpod backend endpoint
/// and streams LLM and A2UI responses over WebSockets.
class ServerpodChatService implements ChatService {
  final String _serverUrl;
  final String Function() _systemInstruction;
  final String Function() _getApiKey;
  late final Client _client;

  ServerpodChatService({
    required this._serverUrl,
    required this._systemInstruction,
    required this._getApiKey,
  });

  @override
  Future<void> initialize() async {
    // Initialize Serverpod Client (connection is established automatically on stream usage)
    _client = Client(_serverUrl);
  }

  @override
  Stream<String> sendMessage({
    required String prompt,
    required List<Map<String, dynamic>> history,
  }) {
    // Map the local Map history to the generated Serverpod ChatMessageHistory objects
    final formattedHistory = history.map((item) {
      final role = item['role'] as String? ?? 'user';
      final partsList = item['parts'] as List? ?? [];
      final parts = partsList.map((p) {
        final text = p['text'] as String? ?? '';
        return ChatMessagePart(text: text);
      }).toList();
      return ChatMessageHistory(role: role, parts: parts);
    }).toList();

    // Call the streaming endpoint
    return _client.chat.chatStream(
      prompt: prompt,
      history: formattedHistory,
      systemInstruction: _systemInstruction(),
      apiKey: _getApiKey(),
    );
  }

  @override
  void dispose() {
    _client.close();
  }
}
