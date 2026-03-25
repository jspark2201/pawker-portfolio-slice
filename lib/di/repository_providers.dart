import 'package:pawker/data/repositories/chat_repository_impl.dart';
import 'package:pawker/data/repositories/exchange_repository_impl.dart';
import 'package:pawker/data/repositories/faq_repository_impl.dart';
import 'package:pawker/data/repositories/walk_schedule_repository_impl.dart';
import 'package:pawker/di/service_providers.dart';
import 'package:pawker/data/repositories/dog_repository_impl.dart';
import 'package:pawker/data/repositories/notification_repository_impl.dart';
import 'package:pawker/data/repositories/oauth_repository_impl.dart';
import 'package:pawker/data/repositories/user_repository_impl.dart';
import 'package:pawker/data/repositories/walker_repository_impl.dart';
import 'package:pawker/data/repositories/walker_job_repository_impl.dart';
import 'package:pawker/data/repositories/owner_job_repository_impl.dart';
import 'package:pawker/data/repositories/auth_repository_impl.dart';
import 'package:pawker/data/repositories/point_repository_impl.dart';
import 'package:pawker/domain/repositories/chat_repository.dart';
import 'package:pawker/domain/repositories/exchange_repository.dart';
import 'package:pawker/domain/repositories/faq_repository.dart';
import 'package:pawker/domain/repositories/walk_schedule_repository.dart';
import 'package:pawker/domain/repositories/dog_repository.dart';
import 'package:pawker/domain/repositories/notification_repository.dart';
import 'package:pawker/domain/repositories/oauth_repository.dart';
import 'package:pawker/domain/repositories/walk_request_repository.dart';
import 'package:pawker/domain/repositories/user_repository.dart';
import 'package:pawker/domain/repositories/walker_repository.dart';
import 'package:pawker/domain/repositories/walker_job_repository.dart';
import 'package:pawker/domain/repositories/owner_job_repository.dart';
import 'package:pawker/domain/repositories/auth_repository.dart';
import 'package:pawker/domain/repositories/point_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:pawker/data/repositories/walk_request_repository_impl.dart';
import 'package:pawker/data/repositories/walk_record_repository_impl.dart';
import 'package:pawker/domain/repositories/walk_record_repository.dart';
import 'package:pawker/data/repositories/walk_summary_repository_impl.dart';
import 'package:pawker/domain/repositories/walk_summary_repository.dart';
import 'package:pawker/data/repositories/subscription_repository_impl.dart';
import 'package:pawker/domain/repositories/subscription_repository.dart';
import 'package:pawker/data/repositories/walker_dashboard_repository_impl.dart';
import 'package:pawker/domain/repositories/walker_dashboard_repository.dart';
import 'package:pawker/data/repositories/walk_review_repository_impl.dart';
import 'package:pawker/domain/repositories/walk_review_repository.dart';
import 'package:pawker/data/repositories/block_repository_impl.dart';
import 'package:pawker/domain/repositories/block_repository.dart';
import 'package:pawker/data/repositories/notice_repository_impl.dart';
import 'package:pawker/data/repositories/pet_certification_repository_impl.dart';
import 'package:pawker/domain/repositories/notice_repository.dart';
import 'package:pawker/domain/repositories/pet_certification_repository.dart';
import 'package:pawker/data/repositories/reward_box_repository_impl.dart';
import 'package:pawker/domain/repositories/reward_box_repository.dart';
import 'package:pawker/data/repositories/feed_repository_impl.dart';
import 'package:pawker/data/repositories/attendance_repository_impl.dart';
import 'package:pawker/data/repositories/phone_verification_repository_impl.dart';
import 'package:pawker/domain/repositories/feed_repository.dart';
import 'package:pawker/domain/repositories/attendance_repository.dart';
import 'package:pawker/domain/repositories/phone_verification_repository.dart';

part 'repository_providers.g.dart';

@riverpod
WalkerRepository walkerRepository(ref) {
  final apiService = ref.watch(walkerApiServiceProvider);
  // return WalkerRepositoryImpl(apiService);
  return MockWalkerRepositoryImpl();
}

@riverpod
DogRepository dogRepository(ref) {
  final apiService = ref.watch(dogApiServiceProvider);
  return DogRepositoryImpl(apiService);
}

@riverpod
WalkRequestRepository walkRequestRepository(ref) {
  final apiService = ref.watch(walkRequestApiServiceProvider);
  return WalkRequestRepositoryImpl(apiService);
}

@riverpod
WalkerJobRepository walkerJobRepository(ref) {
  final apiService = ref.watch(walkerJobApiServiceProvider);
  return WalkerJobRepositoryImpl(apiService);
  // return MockWalkerJobRepositoryImpl();
}

@riverpod
OwnerJobRepository ownerJobRepository(ref) {
  final apiService = ref.watch(ownerJobApiServiceProvider);
  return OwnerJobRepositoryImpl(apiService);
}

@riverpod
AuthRepository authRepository(ref) {
  try {
    final authService = ref.watch(authServiceProvider);

    final oauthRepository = ref.watch(oauthRepositoryProvider);

    final userRepository = ref.watch(userRepositoryProvider);

    final authRepository = AuthRepositoryImpl(
      authService,
      oauthRepository,
      userRepository,
    );

    return authRepository;
  } catch (e) {
    rethrow;
  }
}

@riverpod
UserRepository userRepository(UserRepositoryRef ref) {
  final apiService = ref.watch(userApiServiceProvider);
  return UserRepositoryImpl(apiService);
  // return MockUserRepositoryImpl();
}

@riverpod
OAuthRepository oauthRepository(ref) {
  final apiServices = ref.watch(oauthServiceProvider);
  return OAuthRepositoryImpl(apiServices);
  // return MockOAuthRepositoryImpl();
}

final walkRecordRepositoryProvider = Provider<WalkRecordRepository>((ref) {
  final apiService = ref.watch(walkRecordApiServiceProvider);
  return WalkRecordRepositoryImpl(apiService);
});

@riverpod
PointRepository pointRepository(ref) {
  final apiService = ref.watch(pointApiServiceProvider);
  return PointRepositoryImpl(apiService);
}

@riverpod
WalkSummaryRepository walkSummaryRepository(ref) {
  final apiService = ref.watch(walkSummaryApiServiceProvider);
  return WalkSummaryRepositoryImpl(apiService);
}

@riverpod
SubscriptionRepository subscriptionRepository(ref) {
  final apiService = ref.watch(subscriptionApiServiceProvider);
  return SubscriptionRepositoryImpl(apiService);
}

@riverpod
NotificationRepository notificationRepository(ref) {
  final apiService = ref.watch(notificationApiServiceProvider);
  return NotificationRepositoryImpl(apiService);
}

@riverpod
ChatRepository chatRepository(ChatRepositoryRef ref) {
  final apiService = ref.watch(chatApiServiceProvider);
  return ChatRepositoryImpl(apiService);
}

@riverpod
WalkScheduleRepository walkScheduleRepository(ref) {
  final apiService = ref.watch(walkScheduleApiServiceProvider);
  return WalkScheduleRepositoryImpl(apiService);
  // return DummyWalkScheduleRepositoryImpl(apiService);
}

@riverpod
WalkerDashboardRepository walkerDashboardRepository(ref) {
  final apiService = ref.watch(walkerDashboardApiServiceProvider);
  return WalkerDashboardRepositoryImpl(apiService);
}

@riverpod
WalkReviewRepository walkReviewRepository(ref) {
  final apiService = ref.watch(walkReviewApiServiceProvider);
  return WalkReviewRepositoryImpl(apiService);
}

@riverpod
BlockRepository blockRepository(ref) {
  final apiService = ref.watch(blockApiServiceProvider);
  return BlockRepositoryImpl(apiService);
}

@riverpod
FaqRepository faqRepository(ref) {
  final apiService = ref.watch(faqApiServiceProvider);
  return FaqRepositoryImpl(apiService);
}

@riverpod
NoticeRepository noticeRepository(ref) {
  final apiService = ref.watch(noticeApiServiceProvider);
  return NoticeRepositoryImpl(apiService);
}

@riverpod
PetCertificationRepository petCertificationRepository(ref) {
  final apiService = ref.watch(petCertificationApiServiceProvider);
  return PetCertificationRepositoryImpl(apiService);
}

@riverpod
RewardBoxRepository rewardBoxRepository(ref) {
  final apiService = ref.watch(rewardBoxApiServiceProvider);
  return RewardBoxRepositoryImpl(apiService);
}

@riverpod
ExchangeRepository exchangeRepository(ref) {
  final apiService = ref.watch(exchangeApiServiceProvider);
  return ExchangeRepositoryImpl(apiService);
}

@riverpod
FeedRepository feedRepository(ref) {
  final apiService = ref.watch(feedApiServiceProvider);
  return FeedRepositoryImpl(apiService);
}

@riverpod
AttendanceRepository attendanceRepository(ref) {
  final apiService = ref.watch(attendanceApiServiceProvider);
  return AttendanceRepositoryImpl(apiService);
}

@riverpod
PhoneVerificationRepository phoneVerificationRepository(ref) {
  final apiService = ref.watch(phoneVerificationApiServiceProvider);
  return PhoneVerificationRepositoryImpl(apiService);
}
