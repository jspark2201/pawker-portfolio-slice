import 'package:pawker/domain/entities/walk_summary.dart';

abstract class WalkSummaryRepository {
  /// 산책 요약 통계 조회
  Future<WalkSummary> getWalkSummary({
    required String userId,
    required DateTime startDate,
    required DateTime endDate,
  });

  /// 목표 설정 조회
  Future<GoalSettings> getGoalSettings(String userId);

  /// 목표 설정 업데이트
  Future<void> updateGoalSettings(String userId, GoalSettings goalSettings);
}
