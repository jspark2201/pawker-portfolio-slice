import 'package:freezed_annotation/freezed_annotation.dart';

part 'subscription.freezed.dart';
part 'subscription.g.dart';

@freezed
abstract class Subscription with _$Subscription {
  const factory Subscription({
    required String id,
    required String userId,
    required SubscriptionPlan plan,
    required DateTime startDate,
    required DateTime endDate,
    required SubscriptionStatus status,
    required String? receiptData,
    required String? transactionId,
    required String? originalTransactionId,
    required String? productId,
    required String? subscriptionGroupId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Subscription;

  factory Subscription.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionFromJson(json);
}

enum SubscriptionPlan {
  basic;
  // premium,
  // enterprise;

  String get displayName {
    switch (this) {
      case SubscriptionPlan.basic:
        return '기본';
      // case SubscriptionPlan.premium:
      //   return '프리미엄';
      // case SubscriptionPlan.enterprise:
      //   return '엔터프라이즈';
    }
  }

  String get productId {
    switch (this) {
      case SubscriptionPlan.basic:
        return 'pawker_basic_monthly';
      // case SubscriptionPlan.premium:
      //   return 'pawker_premium_monthly';
      // case SubscriptionPlan.enterprise:
      //   return 'pawker_enterprise_monthly';
    }
  }

  double get price {
    switch (this) {
      case SubscriptionPlan.basic:
        return 5000.0;
      // case SubscriptionPlan.premium:
      //   return 19900.0;
      // case SubscriptionPlan.enterprise:
      //   return 29900.0;
    }
  }

  String get subscriptionGroupId => 'group.pawker.premium';

  List<String> get features {
    switch (this) {
      case SubscriptionPlan.basic:
        return ['기본 산책 매칭', '기본 알림', '월 10회 산책 기록', '기본 고객 지원'];
      // case SubscriptionPlan.premium:
      //   return [
      //     '무제한 산책 매칭',
      //     '우선 매칭',
      //     '무제한 산책 기록',
      //     '고급 분석',
      //     '우선 고객 지원',
      //     '맞춤형 알림',
      //   ];
      // case SubscriptionPlan.enterprise:
      //   return [
      //     '모든 프리미엄 기능',
      //     '전담 고객 지원',
      //     '맞춤형 기능',
      //     'API 접근',
      //     '화이트 라벨 옵션',
      //     '전용 서버',
      //     '24/7 지원',
      //   ];
    }
  }

  String get description {
    switch (this) {
      case SubscriptionPlan.basic:
        return '기본적인 산책 서비스를 제공합니다.';
      // case SubscriptionPlan.premium:
      //   return '고급 기능과 우선 지원을 제공합니다.';
      // case SubscriptionPlan.enterprise:
      //   return '기업을 위한 맞춤형 서비스를 제공합니다.';
    }
  }
}

enum SubscriptionStatus {
  active,
  expired,
  canceled,
  pending,
  failed,
  none;

  String get displayName {
    switch (this) {
      case SubscriptionStatus.active:
        return '활성';
      case SubscriptionStatus.expired:
        return '만료';
      case SubscriptionStatus.canceled:
        return '취소됨';
      case SubscriptionStatus.pending:
        return '대기 중';
      case SubscriptionStatus.failed:
        return '실패';
      case SubscriptionStatus.none:
        return '미구독';
    }
  }

  bool get isActive => this == SubscriptionStatus.active;
  bool get isExpired => this == SubscriptionStatus.expired;
  bool get isCanceled => this == SubscriptionStatus.canceled;
  bool get isPending => this == SubscriptionStatus.pending;
  bool get isFailed => this == SubscriptionStatus.failed;
  bool get isNone => this == SubscriptionStatus.none;
}

class SubscriptionFeature {
  final String id;
  final String name;
  final String description;
  final SubscriptionPlan requiredPlan;
  final bool isPremium;

  const SubscriptionFeature({
    required this.id,
    required this.name,
    required this.description,
    required this.requiredPlan,
    required this.isPremium,
  });
}
