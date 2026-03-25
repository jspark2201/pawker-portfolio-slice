import 'package:freezed_annotation/freezed_annotation.dart';
import 'chat_message.dart';

part 'chat_message_list_response.freezed.dart';
part 'chat_message_list_response.g.dart';

@freezed
abstract class ChatMessageListResponse with _$ChatMessageListResponse {
  const factory ChatMessageListResponse({
    required List<ChatMessage> messages,
    required int totalCount,
    required int limit,
    required int offset,
    required bool hasMore,
  }) = _ChatMessageListResponse;

  factory ChatMessageListResponse.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageListResponseFromJson(json);
}
