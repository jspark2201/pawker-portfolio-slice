import 'package:pawker/domain/entities/dog.dart';
import 'package:pawker/data/models/walk_request_api_model.dart';
import 'package:pawker/data/models/create_walk_request_api_model.dart';

/// 산책 요청 생성용 도메인 모델
class CreateWalkRequest {
  final String ownerId; // 오너 ID
  final String dogId; // 강아지 ID
  final String chatRoomId; // 채팅방 ID

  CreateWalkRequest({
    required this.ownerId,
    required this.dogId,
    required this.chatRoomId,
  });
}

/// 산책 요청 응답용 도메인 모델 (서버로부터 받은 완전한 정보)
class WalkRequest {
  final String id;
  final String walkerId; // 요청받을 워커의 ID
  final Dog dog; // 완전한 강아지 정보
  final DateTime createdAt;

  WalkRequest({
    required this.id,
    required this.walkerId,
    required this.dog,
    required this.createdAt,
  });
}

class WalkRequestMapper {
  /// API 응답 모델을 Domain 응답 모델로 변환
  static WalkRequest toDomain(WalkRequestApiModel apiModel) {
    return WalkRequest(
      id: apiModel.requestId,
      walkerId: apiModel.walkerId,
      dog: DogMapper.toDomain(apiModel.dog),
      createdAt: DateTime.parse(apiModel.createdAt),
    );
  }

  static List<WalkRequest> toDomainList(List<WalkRequestApiModel> apiModels) {
    return apiModels.map((model) => toDomain(model)).toList();
  }

  /// CreateWalkRequest Domain 모델을 API 요청 모델로 변환
  static CreateWalkRequestApiModel toCreateApiModel(CreateWalkRequest request) {
    return CreateWalkRequestApiModel(
      ownerId: request.ownerId,
      dogId: request.dogId,
      chatRoomId: request.chatRoomId,
    );
  }

  /// WalkRequest Domain 모델을 API 응답 모델로 변환 (Legacy - 필요시에만 사용)
  static WalkRequestApiModel toApiModel(WalkRequest request) {
    return WalkRequestApiModel(
      requestId: request.id,
      walkerId: request.walkerId,
      dog: DogMapper.toApiModel(request.dog),
      createdAt: request.createdAt.toIso8601String(),
    );
  }
}
