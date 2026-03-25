import 'package:pawker/domain/entities/walk_request.dart';

/// 산책 요청 관련 저장소 인터페이스
///
/// 이 인터페이스는 산책 요청과 관련된 모든 데이터 작업을 정의합니다.
/// 실제 구현은 데이터 계층에서 이루어집니다.
abstract class WalkRequestRepository {
  /// 새로운 산책 요청을 생성합니다.
  Future<WalkRequest> createRequest(CreateWalkRequest request);

  /// 산책 요청을 삭제합니다.
  Future<void> cancelRequest(String requestId);

  /// 워커가 받은 산책 요청 목록 조회
  Future<List<WalkRequest>> getWalkRequests();

  /// ID로 산책 요청 조회
  Future<WalkRequest> getWalkRequestById(String requestId);
}
