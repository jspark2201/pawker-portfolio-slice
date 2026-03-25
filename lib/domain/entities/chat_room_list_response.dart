import 'package:freezed_annotation/freezed_annotation.dart';
import 'chat_room_list_item.dart';

part 'chat_room_list_response.freezed.dart';
part 'chat_room_list_response.g.dart';

@freezed
abstract class ChatRoomListResponse with _$ChatRoomListResponse {
  const factory ChatRoomListResponse({
    required List<ChatRoomListItem> rooms,
    required int totalCount,
    required int limit,
    required int offset,
    required bool hasMore,
  }) = _ChatRoomListResponse;

  factory ChatRoomListResponse.fromJson(Map<String, dynamic> json) =>
      _$ChatRoomListResponseFromJson(json);
}
