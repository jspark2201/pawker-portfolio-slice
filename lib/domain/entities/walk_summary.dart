import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pawker/data/models/walk_summary_api_model.dart';

part 'walk_summary.freezed.dart';

@freezed
abstract class WalkSummary with _$WalkSummary {
  const factory WalkSummary({
    required WeeklyStats weeklyStats,
    required DogStats dogStats,
    required GoalProgress goalProgress,
    required List<RecentWalk> recentWalks,
    required HealthIndicators healthIndicators,
  }) = _WalkSummary;
}

@freezed
abstract class WeeklyStats with _$WeeklyStats {
  const factory WeeklyStats({
    required int walkCount,
    required int totalMinutes,
    required double totalDistance,
    required int earnedPoints,
  }) = _WeeklyStats;
}

@freezed
abstract class DogStats with _$DogStats {
  const factory DogStats({
    required String mostActiveDog,
    required int mostActiveDogCount,
    required String longestWalkDog,
    required int longestWalkMinutes,
    required Map<String, int> walkCounts,
  }) = _DogStats;
}

@freezed
abstract class GoalProgress with _$GoalProgress {
  const factory GoalProgress({
    required int weeklyGoal,
    required int weeklyProgress,
    required int monthlyGoal,
    required int monthlyProgress,
  }) = _GoalProgress;
}

@freezed
abstract class GoalSettings with _$GoalSettings {
  const factory GoalSettings({
    required int weeklyGoal,
    required int monthlyGoal,
  }) = _GoalSettings;
}

@freezed
abstract class RecentWalk with _$RecentWalk {
  const factory RecentWalk({
    required String dogName,
    required String date,
    required int duration,
    required double distance,
  }) = _RecentWalk;
}

@freezed
abstract class HealthIndicators with _$HealthIndicators {
  const factory HealthIndicators({
    required double averageWalkTime,
    required double averageDistance,
    required String activityLevel,
  }) = _HealthIndicators;
}

class WalkSummaryMapper {
  // API 모델 → Domain 모델
  static WalkSummary fromApiModel(WalkSummaryApiModel apiModel) {
    return WalkSummary(
      weeklyStats: WeeklyStats(
        walkCount: apiModel.weeklyStats.walkCount,
        totalMinutes: apiModel.weeklyStats.totalMinutes,
        totalDistance: double.parse(
          apiModel.weeklyStats.totalDistance.toStringAsFixed(2),
        ),
        earnedPoints: apiModel.weeklyStats.earnedPoints,
      ),
      dogStats: DogStats(
        mostActiveDog: apiModel.dogStats.mostActiveDog,
        mostActiveDogCount: apiModel.dogStats.mostActiveDogCount,
        longestWalkDog: apiModel.dogStats.longestWalkDog,
        longestWalkMinutes: apiModel.dogStats.longestWalkMinutes,
        walkCounts: apiModel.dogStats.walkCounts,
      ),
      goalProgress: GoalProgress(
        weeklyGoal: apiModel.goalProgress.weeklyGoal,
        weeklyProgress: apiModel.goalProgress.weeklyProgress,
        monthlyGoal: apiModel.goalProgress.monthlyGoal,
        monthlyProgress: apiModel.goalProgress.monthlyProgress,
      ),
      recentWalks:
          apiModel.recentWalks
              .map(
                (apiWalk) => RecentWalk(
                  dogName: apiWalk.dogName,
                  date: apiWalk.date,
                  duration: apiWalk.duration,
                  distance: double.parse(apiWalk.distance.toStringAsFixed(2)),
                ),
              )
              .toList(),
      healthIndicators: HealthIndicators(
        averageWalkTime: apiModel.healthIndicators.averageWalkTime,
        averageDistance: apiModel.healthIndicators.averageDistance,
        activityLevel: apiModel.healthIndicators.activityLevel,
      ),
    );
  }

  // Domain 모델 → API 모델
  static WalkSummaryApiModel toApiModel(WalkSummary domainModel) {
    return WalkSummaryApiModel(
      weeklyStats: WeeklyStatsApiModel(
        walkCount: domainModel.weeklyStats.walkCount,
        totalMinutes: domainModel.weeklyStats.totalMinutes,
        totalDistance: domainModel.weeklyStats.totalDistance,
        earnedPoints: domainModel.weeklyStats.earnedPoints,
      ),
      dogStats: DogStatsApiModel(
        mostActiveDog: domainModel.dogStats.mostActiveDog,
        mostActiveDogCount: domainModel.dogStats.mostActiveDogCount,
        longestWalkDog: domainModel.dogStats.longestWalkDog,
        longestWalkMinutes: domainModel.dogStats.longestWalkMinutes,
        walkCounts: domainModel.dogStats.walkCounts,
      ),
      goalProgress: GoalProgressApiModel(
        weeklyGoal: domainModel.goalProgress.weeklyGoal,
        weeklyProgress: domainModel.goalProgress.weeklyProgress,
        monthlyGoal: domainModel.goalProgress.monthlyGoal,
        monthlyProgress: domainModel.goalProgress.monthlyProgress,
      ),
      recentWalks:
          domainModel.recentWalks
              .map(
                (domainWalk) => RecentWalkApiModel(
                  dogName: domainWalk.dogName,
                  date: domainWalk.date,
                  duration: domainWalk.duration,
                  distance: domainWalk.distance,
                ),
              )
              .toList(),
      healthIndicators: HealthIndicatorsApiModel(
        averageWalkTime: domainModel.healthIndicators.averageWalkTime,
        averageDistance: domainModel.healthIndicators.averageDistance,
        activityLevel: domainModel.healthIndicators.activityLevel,
      ),
    );
  }

  // GoalProgress Domain → API
  static GoalProgressApiModel goalProgressToApiModel(GoalProgress domainModel) {
    return GoalProgressApiModel(
      weeklyGoal: domainModel.weeklyGoal,
      weeklyProgress: domainModel.weeklyProgress,
      monthlyGoal: domainModel.monthlyGoal,
      monthlyProgress: domainModel.monthlyProgress,
    );
  }

  // GoalProgress API → Domain
  static GoalProgress goalProgressFromApiModel(GoalProgressApiModel apiModel) {
    return GoalProgress(
      weeklyGoal: apiModel.weeklyGoal,
      weeklyProgress: apiModel.weeklyProgress,
      monthlyGoal: apiModel.monthlyGoal,
      monthlyProgress: apiModel.monthlyProgress,
    );
  }

  // GoalSettings Domain → API
  static GoalSettingsApiModel goalSettingsToApiModel(GoalSettings domainModel) {
    return GoalSettingsApiModel(
      weeklyGoal: domainModel.weeklyGoal,
      monthlyGoal: domainModel.monthlyGoal,
    );
  }

  // GoalSettings API → Domain
  static GoalSettings goalSettingsFromApiModel(GoalSettingsApiModel apiModel) {
    return GoalSettings(
      weeklyGoal: apiModel.weeklyGoal,
      monthlyGoal: apiModel.monthlyGoal,
    );
  }
}
