import 'package:pawker/domain/entities/walk_location.dart';
import 'package:pawker/domain/entities/walk_tracking_session.dart';

/// 워커의 실시간 위치 추적 도메인 서비스 인터페이스
///
/// GPS 위치를 수집하고 서버로 전송하는 동작을 추상화한다.
/// 구현체: [WalkTrackingServiceImpl] (services/walk_tracking_service.dart)
abstract interface class WalkTrackingService {
  /// 산책 추적 시작
  Future<void> startTracking(String walkRequestId);

  /// 산책 추적 종료
  Future<void> stopTracking();

  /// 현재 위치 이력을 기반으로 통계 계산
  WalkStatistics? calculateStatistics();

  /// 현재 추적 중인지 여부
  bool get isTracking;

  /// 현재까지 수집된 위치 이력 (불변 리스트)
  List<WalkLocation> get locationHistory;

  /// 리소스 정리
  void dispose();
}
