import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_message.freezed.dart';
part 'chat_message.g.dart';

@freezed
abstract class ChatMessageSender with _$ChatMessageSender {
  const factory ChatMessageSender({
    required String id,
    required String nickname,
    String? profileImage,
  }) = _ChatMessageSender;

  factory ChatMessageSender.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageSenderFromJson(json);
}

@freezed
abstract class ChatMessage with _$ChatMessage {
  const factory ChatMessage({
    required String id,
    required String roomId,
    required String senderId,
    required String message,
    required String messageType, // 'text' | 'image' | 'system'
    required DateTime createdAt,
    ChatMessageSender? sender,
  }) = _ChatMessage;

  factory ChatMessage.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageFromJson(json);
}
