import 'dart:async';
import 'package:genkit/genkit.dart';
import 'package:genkit_google_genai/genkit_google_genai.dart';

/// A service that handles streaming API calls to the Gemini API using Google Genkit.
class GeminiService {
  GeminiService();

  /// Streams generative content from the Gemini API using Google Genkit.
  Stream<String> streamGenerateContent({
    required String apiKey,
    required String systemInstruction,
    required List<Map<String, dynamic>> history,
  }) async* {
    final ai = Genkit(plugins: [googleAI(apiKey: apiKey)]);

    final messages = [
      Message(
        role: Role.system,
        content: [TextPart(text: systemInstruction)],
      ),
      ...history.map((h) {
        final role = h['role'] == 'user' ? Role.user : Role.model;
        final partsList = h['parts'] as List;
        final parts = partsList.map((p) {
          if (p['text'] != null) {
            return TextPart(text: p['text'] as String);
          }
          return TextPart(text: '');
        }).toList();
        return Message(role: role, content: parts);
      }),
    ];

    try {
      final stream = ai.generateStream(
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

      await for (final chunk in stream) {
        yield chunk.text;
      }
    } catch (e) {
      throw Exception('Genkit error: $e');
    }
  }
}
