import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pawker/domain/entities/walk_summary.dart';

part 'walker_dashboard.freezed.dart';

@freezed
abstract class WalkerDashboard with _$WalkerDashboard {
  const factory WalkerDashboard({
    required DailyStats todayStats,
    required PeriodStats weekStats,
    required PeriodStats monthStats,
    required GoalProgress goalProgress,
  }) = _WalkerDashboard;
}

@freezed
abstract class DailyStats with _$DailyStats {
  const factory DailyStats({
    required int completedWalks,
    required int scheduledWalks,
    required double totalDistance,
    required int totalHours,
  }) = _DailyStats;
}

@freezed
abstract class PeriodStats with _$PeriodStats {
  const factory PeriodStats({
    required int totalWalks,
    required double cumulativeDistance,
    required int totalHours,
    required double averageRating,
  }) = _PeriodStats;
}
