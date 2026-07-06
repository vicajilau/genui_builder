import 'dart:async';
import 'dart:io';
import 'package:genkit/genkit.dart' as gk;
import 'package:genkit_google_genai/genkit_google_genai.dart';
import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

/// An endpoint that processes chat prompts and streams the responses using Google Genkit.
class ChatEndpoint extends Endpoint {
  /// Streams generative content from the Gemini API using Google Genkit on the backend.
  Stream<String> chatStream(
    Session session, {
    required String prompt,
    required List<ChatMessageHistory> history,
    required String systemInstruction,
    String? apiKey,
  }) async* {
    // Resolve the API key from the parameter, or fallback to the server environment
    final resolvedApiKey = (apiKey != null && apiKey.isNotEmpty)
        ? apiKey
        : Platform.environment['GEMINI_API_KEY'] ?? '';

    if (resolvedApiKey.isEmpty) {
      yield 'Error: Gemini API Key is not configured. Please configure it in your environment variables or in the client settings.\n';
      return;
    }

    final ai = gk.Genkit(plugins: [googleAI(apiKey: resolvedApiKey)]);

    // Map history to Genkit Message format
    final messages = [
      gk.Message(
        role: gk.Role.system,
        content: [gk.TextPart(text: systemInstruction)],
      ),
      ...history.map((h) {
        final role = h.role == 'user' ? gk.Role.user : gk.Role.model;
        final parts = h.parts.map((p) => gk.TextPart(text: p.text)).toList();
        return gk.Message(role: role, content: parts);
      }),
      gk.Message(
        role: gk.Role.user,
        content: [gk.TextPart(text: prompt)],
      ),
    ];

    try {
      final responseStream = ai.generateStream(
        model: googleAI.gemini('gemini-2.5-flash'),
        messages: messages,
        config: GeminiOptions(
          temperature: 0.7,
          safetySettings: [
            SafetySettings(
              category: 'HARM_CATEGORY_HARASSMENT',
              threshold: 'BLOCK_NONE',
            ),
            SafetySettings(
              category: 'HARM_CATEGORY_HATE_SPEECH',
              threshold: 'BLOCK_NONE',
            ),
            SafetySettings(
              category: 'HARM_CATEGORY_SEXUALLY_EXPLICIT',
              threshold: 'BLOCK_NONE',
            ),
            SafetySettings(
              category: 'HARM_CATEGORY_DANGEROUS_CONTENT',
              threshold: 'BLOCK_NONE',
            ),
          ],
        ),
      );

      await for (final chunk in responseStream) {
        yield chunk.text;
      }
    } catch (e) {
      yield 'Error processing request on Serverpod backend: $e';
    }
  }
}
