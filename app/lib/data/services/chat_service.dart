import 'dart:async';

import 'package:flutter/foundation.dart';

/// An abstract service class representing a Generative UI chat provider.
abstract class ChatService {
  /// Initializes connection configs or loads local model parameters.
  Future<void> initialize();

  /// Sends a user prompt to the provider alongside context history,
  /// yielding a real-time stream of streamed string responses (text & A2UI JSON).
  Stream<String> sendMessage({
    required String prompt,
    required List<Map<String, dynamic>> history,
  });

  /// What the service is doing before it can answer, such as downloading or
  /// loading a local model, or `null` when it is not preparing anything.
  ValueListenable<ChatServiceStatus?> get status;

  /// Releases resources or closes active socket streams.
  void dispose();
}

/// The status of a [ChatService] that never prepares anything.
final ValueListenable<ChatServiceStatus?> idleChatServiceStatus =
    ValueNotifier<ChatServiceStatus?>(null);

/// A preparation step a [ChatService] reports through [ChatService.status].
sealed class ChatServiceStatus {
  const ChatServiceStatus();
}

/// The model is being downloaded.
final class DownloadingModel extends ChatServiceStatus {
  const DownloadingModel(this.percent);

  /// Download progress, from 0 to 100.
  final int percent;
}

/// The model is being loaded and is reading the prompt.
final class LoadingModel extends ChatServiceStatus {
  const LoadingModel();
}
