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
import 'package:serverpod/serverpod.dart' as _i1;
import '../chat/chat_endpoint.dart' as _i2;
import '../greetings/greeting_endpoint.dart' as _i3;
import 'package:genui_server/src/generated/chat/chat_message_history.dart'
    as _i4;

class Endpoints extends _i1.EndpointDispatch {
  @override
  void initializeEndpoints(_i1.Server server) {
    var endpoints = <String, _i1.Endpoint>{
      'chat': _i2.ChatEndpoint()
        ..initialize(
          server,
          'chat',
          null,
        ),
      'greeting': _i3.GreetingEndpoint()
        ..initialize(
          server,
          'greeting',
          null,
        ),
    };
    connectors['chat'] = _i1.EndpointConnector(
      name: 'chat',
      endpoint: endpoints['chat']!,
      methodConnectors: {
        'chatStream': _i1.MethodStreamConnector(
          name: 'chatStream',
          params: {
            'prompt': _i1.ParameterDescription(
              name: 'prompt',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'history': _i1.ParameterDescription(
              name: 'history',
              type: _i1.getType<List<_i4.ChatMessageHistory>>(),
              nullable: false,
            ),
            'systemInstruction': _i1.ParameterDescription(
              name: 'systemInstruction',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'apiKey': _i1.ParameterDescription(
              name: 'apiKey',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          streamParams: {},
          returnType: _i1.MethodStreamReturnType.streamType,
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) => (endpoints['chat'] as _i2.ChatEndpoint).chatStream(
                session,
                prompt: params['prompt'],
                history: params['history'],
                systemInstruction: params['systemInstruction'],
                apiKey: params['apiKey'],
              ),
        ),
      },
    );
    connectors['greeting'] = _i1.EndpointConnector(
      name: 'greeting',
      endpoint: endpoints['greeting']!,
      methodConnectors: {
        'ping': _i1.MethodConnector(
          name: 'ping',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['greeting'] as _i3.GreetingEndpoint).ping(session),
        ),
      },
    );
  }
}
