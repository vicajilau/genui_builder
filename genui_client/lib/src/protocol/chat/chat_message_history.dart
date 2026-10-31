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
import 'package:genui_client/src/protocol/protocol.dart' as _ivloctia;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import '../chat/chat_message_part.dart' as _io3uhir9;

abstract class ChatMessageHistory
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ChatMessageHistory._({
    required this.role,
    required this.parts,
  });

  factory ChatMessageHistory({
    required String role,
    required List<_io3uhir9.ChatMessagePart> parts,
  }) = _ChatMessageHistoryImpl;

  factory ChatMessageHistory.fromJson(Map<String, dynamic> jsonSerialization) {
    return ChatMessageHistory(
      role: jsonSerialization['role'] as String,
      parts: _ivloctia.Protocol().deserialize<List<_io3uhir9.ChatMessagePart>>(
        jsonSerialization['parts'],
      ),
    );
  }

  String role;

  List<_io3uhir9.ChatMessagePart> parts;

  /// Returns a shallow copy of this [ChatMessageHistory]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ChatMessageHistory copyWith({
    String? role,
    List<_io3uhir9.ChatMessagePart>? parts,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ChatMessageHistory',
      'role': role,
      'parts': parts.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ChatMessageHistory',
      'role': role,
      'parts': parts.toJson(valueToJson: (v) => v.toJsonForProtocol()),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _ChatMessageHistoryImpl extends ChatMessageHistory {
  _ChatMessageHistoryImpl({
    required String role,
    required List<_io3uhir9.ChatMessagePart> parts,
  }) : super._(
         role: role,
         parts: parts,
       );

  /// Returns a shallow copy of this [ChatMessageHistory]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ChatMessageHistory copyWith({
    String? role,
    List<_io3uhir9.ChatMessagePart>? parts,
  }) {
    return ChatMessageHistory(
      role: role ?? this.role,
      parts: parts ?? this.parts.map((e0) => e0.copyWith()).toList(),
    );
  }
}
