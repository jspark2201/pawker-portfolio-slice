import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pawker/domain/entities/walk_location.dart';

part 'walk_tracking_session.freezed.dart';
part 'walk_tracking_session.g.dart';

/// 산책 추적 세션
@freezed
abstract class WalkTrackingSession with _$WalkTrackingSession {
  const factory WalkTrackingSession({
    required String walkRequestId,
    required String walkerId,
    required String ownerId,
    required WalkTrackingStatus status,
    required DateTime startedAt,
    DateTime? endedAt,
    @Default([]) List<WalkLocation> locations,
    WalkStatistics? statistics,
  }) = _WalkTrackingSession;

  factory WalkTrackingSession.fromJson(Map<String, dynamic> json) =>
      _$WalkTrackingSessionFromJson(json);
}

/// 산책 추적 상태
enum WalkTrackingStatus {
  @JsonValue('preparing')
  preparing, // 준비 중
  @JsonValue('started')
  started, // 시작됨
  @JsonValue('in_progress')
  inProgress, // 진행 중
  @JsonValue('paused')
  paused, // 일시 정지
  @JsonValue('completed')
  completed, // 완료
  @JsonValue('cancelled')
  cancelled, // 취소
}

/// 산책 통계
@freezed
abstract class WalkStatistics with _$WalkStatistics {
  const factory WalkStatistics({
    required double totalDistance, // meters
    required int totalDuration, // seconds
    required double averageSpeed, // m/s
    double? maxSpeed,
  }) = _WalkStatistics;

  factory WalkStatistics.fromJson(Map<String, dynamic> json) =>
      _$WalkStatisticsFromJson(json);
}
