import 'package:pawker/domain/entities/user.dart';

/// 워커(도그워커) 관련 저장소 인터페이스
///
/// 이 인터페이스는 워커와 관련된 모든 데이터 작업을 정의합니다.
/// 실제 구현은 데이터 계층에서 이루어집니다.
abstract class WalkerRepository {
  /// 현재 로그인한 워커의 정보를 가져옵니다.
  Future<User?> getCurrentWalker();

  /// 워커 프로필을 업데이트합니다.
  Future<void> updateProfile(User user);

  /// 워커 프로필을 생성합니다.
  Future<void> createProfile(User user);

  Future<List<User>> getRecommendedWalkers();
  Future<List<User>> getWalkerList();
  Future<User> getWalkerById(String id);
}
