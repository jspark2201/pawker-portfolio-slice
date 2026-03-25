import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_chat_room_request.freezed.dart';
part 'create_chat_room_request.g.dart';

@freezed
abstract class CreateChatRoomRequest with _$CreateChatRoomRequest {
  const factory CreateChatRoomRequest({
    required String ownerId,
    required String walkerId,
  }) = _CreateChatRoomRequest;

  factory CreateChatRoomRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateChatRoomRequestFromJson(json);
}
