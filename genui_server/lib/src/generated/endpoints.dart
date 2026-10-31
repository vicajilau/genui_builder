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
import 'package:genui_server/src/generated/chat/chat_message_history.dart'
    as _i5wxyimw;
import 'package:serverpod/serverpod.dart' as _is;
import '../chat/chat_endpoint.dart' as _i3w57des;
import '../greetings/greeting_endpoint.dart' as _il624ik7;

class Endpoints extends _is.EndpointDispatch {
  @override
  void initializeEndpoints(_is.Server server) {
    var endpoints = <String, _is.Endpoint>{
      'chat': _i3w57des.ChatEndpoint()
        ..initialize(
          server,
          'chat',
          null,
        ),
      'greeting': _il624ik7.GreetingEndpoint()
        ..initialize(
          server,
          'greeting',
          null,
        ),
    };
    connectors['chat'] = _is.EndpointConnector(
      name: 'chat',
      endpoint: endpoints['chat']!,
      methodConnectors: {
        'chatStream': _is.MethodStreamConnector(
          name: 'chatStream',
          params: {
            'prompt': _is.ParameterDescription(
              name: 'prompt',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'history': _is.ParameterDescription(
              name: 'history',
              type: _is.getType<List<_i5wxyimw.ChatMessageHistory>>(),
              nullable: false,
            ),
            'systemInstruction': _is.ParameterDescription(
              name: 'systemInstruction',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'apiKey': _is.ParameterDescription(
              name: 'apiKey',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          streamParams: {},
          returnType: _is.MethodStreamReturnType.streamType,
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) => (endpoints['chat'] as _i3w57des.ChatEndpoint).chatStream(
                session,
                prompt: params['prompt'],
                history: params['history'],
                systemInstruction: params['systemInstruction'],
                apiKey: params['apiKey'],
              ),
        ),
      },
    );
    connectors['greeting'] = _is.EndpointConnector(
      name: 'greeting',
      endpoint: endpoints['greeting']!,
      methodConnectors: {
        'ping': _is.MethodConnector(
          name: 'ping',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['greeting'] as _il624ik7.GreetingEndpoint)
                  .ping(session),
        ),
      },
    );
  }
}
