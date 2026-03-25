import 'package:pawker/domain/entities/subscription.dart';

abstract class SubscriptionRepository {
  /// 현재 구독 정보 조회
  Future<Subscription?> getCurrentSubscription();

  /// 구독 상태 조회
  Future<SubscriptionStatus> getSubscriptionStatus();

  /// 구독 생성
  Future<Subscription> createSubscription(SubscriptionPlan plan);

  /// 구독 취소
  Future<void> cancelSubscription();

  /// 구독 갱신
  Future<Subscription> renewSubscription();

  /// 특정 기능 사용 가능 여부 확인
  Future<bool> canUseFeature(String featureId);

  /// 플랜별 기능 목록 조회
  Future<List<SubscriptionFeature>> getFeaturesByPlan(SubscriptionPlan plan);
}
