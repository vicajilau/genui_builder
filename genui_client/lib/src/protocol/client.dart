/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'dart:async' as _i2;
import 'package:genui_client/src/protocol/chat/chat_message_history.dart'
    as _i3;
import 'package:http/http.dart' as _i4;
import 'protocol.dart' as _i5;

/// An endpoint that processes chat prompts and streams the responses using Google Genkit.
/// {@category Endpoint}
class EndpointChat extends _i1.EndpointRef {
  EndpointChat(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'chat';

  /// Streams generative content from the Gemini API using Google Genkit on the backend.
  _i2.Stream<String> chatStream({
    required String prompt,
    required List<_i3.ChatMessageHistory> history,
    required String systemInstruction,
    String? apiKey,
  }) => caller.callStreamingServerEndpoint<_i2.Stream<String>, String>(
    'chat',
    'chatStream',
    {
      'prompt': prompt,
      'history': history,
      'systemInstruction': systemInstruction,
      'apiKey': apiKey,
    },
    {},
  );
}

/// Endpoint providing a simple health check or ping for the Serverpod connection.
/// {@category Endpoint}
class EndpointGreeting extends _i1.EndpointRef {
  EndpointGreeting(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'greeting';

  _i2.Future<bool> ping() => caller.callServerEndpoint<bool>(
    'greeting',
    'ping',
    {},
  );
}

class Client extends _i1.ServerpodClientShared {
  Client(
    String host, {
    dynamic securityContext,
    @Deprecated(
      'Use authKeyProvider instead. This will be removed in future releases.',
    )
    super.authenticationKeyManager,
    Duration? streamingConnectionTimeout,
    Duration? connectionTimeout,
    Function(
      _i1.MethodCallContext,
      Object,
      StackTrace,
    )?
    onFailedCall,
    Function(_i1.MethodCallContext)? onSucceededCall,
    bool? disconnectStreamsOnLostInternetConnection,
    _i4.Client? httpClientOverride,
  }) : super(
         host,
         _i5.Protocol(),
         securityContext: securityContext,
         streamingConnectionTimeout: streamingConnectionTimeout,
         connectionTimeout: connectionTimeout,
         onFailedCall: onFailedCall,
         onSucceededCall: onSucceededCall,
         disconnectStreamsOnLostInternetConnection:
             disconnectStreamsOnLostInternetConnection,
         httpClientOverride: httpClientOverride,
       ) {
    chat = EndpointChat(this);
    greeting = EndpointGreeting(this);
  }

  late final EndpointChat chat;

  late final EndpointGreeting greeting;

  @override
  Map<String, _i1.EndpointRef> get endpointRefLookup => {
    'chat': chat,
    'greeting': greeting,
  };

  @override
  Map<String, _i1.ModuleEndpointCaller> get moduleLookup => {};
}
