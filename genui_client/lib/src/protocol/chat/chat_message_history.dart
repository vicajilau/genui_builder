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
import '../chat/chat_message_part.dart' as _i2;
import 'package:genui_client/src/protocol/protocol.dart' as _i3;

abstract class ChatMessageHistory implements _i1.SerializableModel {
  ChatMessageHistory._({
    required this.role,
    required this.parts,
  });

  factory ChatMessageHistory({
    required String role,
    required List<_i2.ChatMessagePart> parts,
  }) = _ChatMessageHistoryImpl;

  factory ChatMessageHistory.fromJson(Map<String, dynamic> jsonSerialization) {
    return ChatMessageHistory(
      role: jsonSerialization['role'] as String,
      parts: _i3.Protocol().deserialize<List<_i2.ChatMessagePart>>(
        jsonSerialization['parts'],
      ),
    );
  }

  String role;

  List<_i2.ChatMessagePart> parts;

  /// Returns a shallow copy of this [ChatMessageHistory]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ChatMessageHistory copyWith({
    String? role,
    List<_i2.ChatMessagePart>? parts,
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
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _ChatMessageHistoryImpl extends ChatMessageHistory {
  _ChatMessageHistoryImpl({
    required String role,
    required List<_i2.ChatMessagePart> parts,
  }) : super._(
         role: role,
         parts: parts,
       );

  /// Returns a shallow copy of this [ChatMessageHistory]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ChatMessageHistory copyWith({
    String? role,
    List<_i2.ChatMessagePart>? parts,
  }) {
    return ChatMessageHistory(
      role: role ?? this.role,
      parts: parts ?? this.parts.map((e0) => e0.copyWith()).toList(),
    );
  }
}
