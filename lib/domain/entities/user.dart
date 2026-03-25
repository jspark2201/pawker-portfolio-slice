import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pawker/data/models/user_api_model.dart';
import 'package:pawker/domain/entities/subscription.dart';

part 'user.freezed.dart';
part 'user.g.dart';

enum UserRole { owner, walker }

@freezed
abstract class User with _$User {
  const factory User({
    required String id,
    String? email,
    String? name,
    String? nickname,
    String? phoneNumber,
    @Default(false) bool phoneVerified,
    DateTime? phoneVerifiedAt,
    String? profileImage,
    required List<UserRole> roles,
    required DateTime createdAt,
    String? naverId,
    String? kakaoId,
    String? googleId,
    String? appleId,
    double? avgRating,
    int? totalWalks,
    int? walkCount,
    String? gender,
    int? age,
    required int pointsBalance,
    Subscription? currentSubscription,
    @Default(SubscriptionStatus.none) SubscriptionStatus subscriptionStatus,
    @Default([]) List<String> availableFeatures,
    @Default(false) bool marketingPushAgreed,
    @Default(false) bool marketingEmailAgreed,
    @Default(false) bool marketingSmsAgreed,
    String? marketingPushAgreedAt,
    String? marketingEmailAgreedAt,
    String? marketingSmsAgreedAt,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}

extension UserExtension on User {
  bool get isRegistrationComplete {
    return nickname != null && nickname!.isNotEmpty && roles.isNotEmpty;
  }

  // 구독 관련 편의 메서드들
  bool get hasActiveSubscription =>
      subscriptionStatus == SubscriptionStatus.active;

  // bool get hasPremiumSubscription =>
  //     hasActiveSubscription &&
  //     currentSubscription?.plan == SubscriptionPlan.premium;

  // bool get hasEnterpriseSubscription =>
  //     hasActiveSubscription &&
  //     currentSubscription?.plan == SubscriptionPlan.enterprise;

  bool canUseFeature(String featureId) {
    return availableFeatures.contains(featureId);
  }

  bool get canUseUnlimitedWalks => canUseFeature('unlimited_walks');
  bool get canUseAdvancedAnalytics => canUseFeature('advanced_analytics');
  bool get canUseHealthTracking => canUseFeature('health_tracking');
  bool get canUseMultipleDogs => canUseFeature('multiple_dogs');
  bool get canUsePremiumWalkers => canUseFeature('premium_walkers');
  bool get canUsePrioritySupport => canUseFeature('priority_support');
}

class UserMapper {
  static User toDomain(UserApiModel apiModel) {
    return User(
      id: apiModel.id,
      email: apiModel.email,
      name: apiModel.name,
      phoneNumber: apiModel.phoneNumber,
      phoneVerified: apiModel.phoneVerified,
      phoneVerifiedAt: apiModel.phoneVerifiedAt != null
          ? DateTime.tryParse(apiModel.phoneVerifiedAt!)
          : null,
      profileImage: apiModel.profileImage,
      nickname: apiModel.nickname,
      roles:
          apiModel.roles.map((role) => UserRole.values.byName(role)).toList(),
      createdAt: DateTime.parse(apiModel.createdAt),
      naverId: apiModel.naverId,
      kakaoId: apiModel.kakaoId,
      googleId: apiModel.googleId,
      appleId: apiModel.appleId,
      pointsBalance: apiModel.pointsBalance,
      currentSubscription: apiModel.currentSubscription,
      subscriptionStatus: apiModel.subscriptionStatus,
      availableFeatures: apiModel.availableFeatures,
      marketingPushAgreed: apiModel.marketingPushAgreed,
      marketingEmailAgreed: apiModel.marketingEmailAgreed,
      marketingSmsAgreed: apiModel.marketingSmsAgreed,
      marketingPushAgreedAt: apiModel.marketingPushAgreedAt,
      marketingEmailAgreedAt: apiModel.marketingEmailAgreedAt,
      marketingSmsAgreedAt: apiModel.marketingSmsAgreedAt,
    );
  }

  static List<User> toDomainList(List<UserApiModel> apiModels) {
    return apiModels.map((apiModel) => toDomain(apiModel)).toList();
  }

  static UserApiModel toApiModel(User user) {
    return UserApiModel(
      id: user.id,
      email: user.email,
      name: user.name,
      nickname: user.nickname,
      phoneNumber: user.phoneNumber,
      phoneVerified: user.phoneVerified,
      phoneVerifiedAt: user.phoneVerifiedAt?.toIso8601String(),
      profileImage: user.profileImage,
      roles: user.roles.map((role) => role.name).toList(),
      createdAt: user.createdAt.toIso8601String(),
      naverId: user.naverId,
      kakaoId: user.kakaoId,
      googleId: user.googleId,
      appleId: user.appleId,
      pointsBalance: user.pointsBalance,
      currentSubscription: user.currentSubscription,
      subscriptionStatus: user.subscriptionStatus,
      availableFeatures: user.availableFeatures,
      marketingPushAgreed: user.marketingPushAgreed,
      marketingEmailAgreed: user.marketingEmailAgreed,
      marketingSmsAgreed: user.marketingSmsAgreed,
      marketingPushAgreedAt: user.marketingPushAgreedAt,
      marketingEmailAgreedAt: user.marketingEmailAgreedAt,
      marketingSmsAgreedAt: user.marketingSmsAgreedAt,
    );
  }
}
