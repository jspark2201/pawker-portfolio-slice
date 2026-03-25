import 'dart:io';

import 'package:pawker/domain/entities/chat_room.dart';
import 'package:pawker/domain/entities/chat_message.dart';
import 'package:pawker/domain/entities/chat_room_list_response.dart';
import 'package:pawker/domain/entities/chat_message_list_response.dart';
import 'package:pawker/domain/entities/create_chat_room_request.dart';
import 'package:pawker/domain/entities/send_message_request.dart';

/// 채팅 관련 저장소 인터페이스
///
/// 이 인터페이스는 채팅과 관련된 모든 데이터 작업을 정의합니다.
/// 실제 구현은 데이터 계층에서 이루어집니다.
abstract class ChatRepository {
  /// 사용자의 채팅방 목록을 가져옵니다.
  Future<ChatRoomListResponse> getChatRooms({int? limit, int? offset});

  /// 특정 채팅방 정보를 가져옵니다.
  Future<ChatRoom> getChatRoomById(String roomId);

  /// 특정 채팅방의 메시지 목록을 가져옵니다.
  Future<ChatMessageListResponse> getChatMessages(
    String roomId, {
    int? limit,
    int? offset,
  });

  /// 메시지를 전송합니다.
  Future<ChatMessage> sendMessage(SendMessageRequest request);

  /// 메시지를 읽음 처리합니다.
  Future<void> markChatAsRead(String roomId);

  /// 채팅방을 생성합니다.
  Future<ChatRoom> createChatRoom(CreateChatRoomRequest request);

  /// 채팅방을 완전 종료
  Future<void> leaveChatRoom(String roomId);

  /// 채팅방을 뒤로 가기 종료
  Future<void> exitChatRoom(String roomId);

  /// 채팅 이미지 업로드 (1~10장). 업로드된 이미지 URL 목록 반환.
  Future<List<String>> uploadChatImages(String roomId, List<File> imageFiles);

  /// 이미지 메시지 전송 (1장 또는 여러 장 URL)
  Future<ChatMessage> sendImageMessage(String roomId, List<String> imageUrls);
}
