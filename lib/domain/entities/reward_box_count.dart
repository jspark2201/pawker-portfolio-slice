import 'package:freezed_annotation/freezed_annotation.dart';

part 'reward_box_count.freezed.dart';
part 'reward_box_count.g.dart';

/// 리워드 박스 도메인 모델
@freezed
abstract class RewardBoxCount with _$RewardBoxCount {
  const factory RewardBoxCount({
    required int count, // 보유 개수
  }) = _RewardBoxCount;

  factory RewardBoxCount.fromJson(Map<String, dynamic> json) =>
      _$RewardBoxCountFromJson(json);
}

/// 리워드 박스 열기 응답
@freezed
abstract class OpenRewardBoxResponse with _$OpenRewardBoxResponse {
  const factory OpenRewardBoxResponse({
    required int pointsAwarded, // 지급된 포인트
    required int remainingCount, // 남은 박스 개수
  }) = _OpenRewardBoxResponse;

  factory OpenRewardBoxResponse.fromJson(Map<String, dynamic> json) =>
      _$OpenRewardBoxResponseFromJson(json);
}
