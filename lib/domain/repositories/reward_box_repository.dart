import 'package:pawker/domain/entities/reward_box_count.dart';

abstract class RewardBoxRepository {
  Future<RewardBoxCount> getMyRewardBox();
  Future<OpenRewardBoxResponse> openRewardBox();
}
