import 'package:pawker/domain/entities/blocked_user.dart';

/// 차단 관련 저장소 인터페이스
abstract class BlockRepository {
  /// 차단한 유저 목록 조회
  Future<List<BlockedUser>> getBlockedUsers();

  /// 유저 차단
  Future<void> blockUser(String userId);

  /// 유저 차단 해제
  Future<void> unblockUser(String userId);
}

