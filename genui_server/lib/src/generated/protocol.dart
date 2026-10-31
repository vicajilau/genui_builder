/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member
// ignore_for_file: dead_code, unnecessary_type_check

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:genui_server/src/generated/chat/chat_message_history.dart'
    as _i5wxyimw;
import 'package:serverpod/protocol.dart' as _isp;
import 'package:serverpod/serverpod.dart' as _is;
import 'chat/chat_message_history.dart' as _ide8bzxf;
import 'chat/chat_message_part.dart' as _ihyde1km;
export 'chat/chat_message_history.dart';
export 'chat/chat_message_part.dart';

class Protocol extends _is.DatabaseSerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

  static List<_isp.TableDefinition> get targetTableDefinitions => [
    ..._isp.Protocol.targetTableDefinitions,
  ];

  static String? getClassNameFromObjectJson(dynamic data) {
    if (data is! Map) return null;
    final className = data['__className__'] as String?;
    return className;
  }

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;

    final dataClassName = getClassNameFromObjectJson(data);
    if (dataClassName != null && dataClassName != getClassNameForType(t)) {
      try {
        return deserializeByClassName({
          'className': dataClassName,
          'data': data,
        });
      } on _is.DeserializationClassNameNotFoundException catch (_) {
        // If the className is not recognized (e.g., older client receiving
        // data with a new subtype), fall back to deserializing without the
        // className, using the expected type T.
      }
    }

    if (t == _ide8bzxf.ChatMessageHistory) {
      return _ide8bzxf.ChatMessageHistory.fromJson(data) as T;
    }
    if (t == _ihyde1km.ChatMessagePart) {
      return _ihyde1km.ChatMessagePart.fromJson(data) as T;
    }
    if (t == _is.getType<_ide8bzxf.ChatMessageHistory?>()) {
      return (data != null ? _ide8bzxf.ChatMessageHistory.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ihyde1km.ChatMessagePart?>()) {
      return (data != null ? _ihyde1km.ChatMessagePart.fromJson(data) : null)
          as T;
    }
    if (t == List<_ihyde1km.ChatMessagePart>) {
      return (data as List)
              .map((e) => deserialize<_ihyde1km.ChatMessagePart>(e))
              .toList()
          as T;
    }
    if (t == List<_i5wxyimw.ChatMessageHistory>) {
      return (data as List)
              .map((e) => deserialize<_i5wxyimw.ChatMessageHistory>(e))
              .toList()
          as T;
    }
    try {
      return _isp.Protocol().deserialize<T>(data, t);
    } on _is.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _ide8bzxf.ChatMessageHistory => 'ChatMessageHistory',
      _ihyde1km.ChatMessagePart => 'ChatMessagePart',
      _ => null,
    };
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;

    if (data is Map<String, dynamic> && data['__className__'] is String) {
      return (data['__className__'] as String).replaceFirst('genui.', '');
    }

    switch (data) {
      case _ide8bzxf.ChatMessageHistory():
        return 'ChatMessageHistory';
      case _ihyde1km.ChatMessagePart():
        return 'ChatMessagePart';
    }
    className = _isp.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.') ? className : 'serverpod.$className';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'ChatMessageHistory') {
      return deserialize<_ide8bzxf.ChatMessageHistory>(data['data']);
    }
    if (dataClassName == 'ChatMessagePart') {
      return deserialize<_ihyde1km.ChatMessagePart>(data['data']);
    }
    if (dataClassName.startsWith('serverpod.')) {
      data['className'] = dataClassName.substring(10);
      return _isp.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }

  @override
  _is.Table? getTableForType(Type t) {
    {
      var table = _isp.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    return null;
  }

  @override
  List<_isp.TableDefinition> getTargetTableDefinitions() =>
      targetTableDefinitions;

  @override
  String getModuleName() => 'genui';

  /// Maps any `Record`s known to this [Protocol] to their JSON representation
  ///
  /// Throws in case the record type is not known.
  ///
  /// This method will return `null` (only) for `null` inputs.
  Map<String, dynamic>? mapRecordToJson(Record? record) {
    if (record == null) {
      return null;
    }
    try {
      return _isp.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
