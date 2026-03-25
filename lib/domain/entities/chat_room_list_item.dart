import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_room_list_item.freezed.dart';
part 'chat_room_list_item.g.dart';

@freezed
abstract class ChatRoomOtherUser with _$ChatRoomOtherUser {
  const factory ChatRoomOtherUser({
    required String id,
    required String nickname,
    String? profileImage,
  }) = _ChatRoomOtherUser;

  factory ChatRoomOtherUser.fromJson(Map<String, dynamic> json) =>
      _$ChatRoomOtherUserFromJson(json);
}

@freezed
abstract class ChatRoomListItem with _$ChatRoomListItem {
  const factory ChatRoomListItem({
    required String id,
    required String? walkRequestId,
    required String ownerId,
    required String walkerId,
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? lastMessageAt,
    String? lastMessage,
    required int unreadCount,
    required ChatRoomOtherUser otherUser,
  }) = _ChatRoomListItem;

  factory ChatRoomListItem.fromJson(Map<String, dynamic> json) =>
      _$ChatRoomListItemFromJson(json);
}
