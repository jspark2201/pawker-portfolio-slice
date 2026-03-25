import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:go_router/go_router.dart';
import 'package:pawker/domain/entities/dog.dart';
import 'package:pawker/domain/entities/notice/notice.dart';
import 'package:pawker/domain/entities/feed/feed.dart';
import 'package:pawker/ui/features/feed/widgets/feed_screen.dart';
import 'package:pawker/ui/features/feed/widgets/my_feed_screen.dart';
import 'package:pawker/ui/features/feed/widgets/feed_detail_screen.dart';
import 'package:pawker/ui/features/feed/widgets/feed_create_screen.dart';
import 'package:pawker/ui/features/feed/widgets/feed_edit_screen.dart';
import 'package:pawker/domain/entities/oauth_user_info.dart';
import 'package:pawker/domain/entities/walk_request.dart';
import 'package:pawker/domain/entities/user.dart';
import 'package:pawker/domain/entities/owner_job.dart';
import 'package:pawker/domain/entities/walk_record.dart';
import 'package:pawker/domain/entities/walk_schedule.dart';
import 'package:pawker/ui/features/app_info/widgets/app_info_screen.dart';
import 'package:pawker/ui/features/ask/widgets/ask_screen.dart';
import 'package:pawker/ui/features/auth/view_model/auth_view_model.dart';
import 'package:pawker/ui/features/auth/widgets/auth_user_info_screen.dart';
import 'package:pawker/ui/features/auth/widgets/login_screen.dart';
import 'package:pawker/ui/features/auth/widgets/signup_screen.dart';
import 'package:pawker/ui/features/block/widgets/block_user_list_screen.dart';
import 'package:pawker/ui/features/chat/widgets/chat_image_detail_screen.dart';
import 'package:pawker/ui/features/chat/widgets/chat_list_screen.dart';
import 'package:pawker/ui/features/chat/widgets/chat_room_screen.dart';
import 'package:pawker/ui/core/ui/setting/profile_edit_screen.dart';
import 'package:pawker/ui/core/ui/setting/phone_verification_screen.dart';
import 'package:pawker/ui/core/ui/setting/marketing_consent_screen.dart';
import 'package:pawker/ui/features/exchange/widgets/exchange_request_list_sreen.dart';
import 'package:pawker/ui/features/faq/widgets/faq_screen.dart';
import 'package:pawker/ui/features/ban/widgets/ban_screen.dart';
import 'package:pawker/domain/exceptions/account_banned_exception.dart';
import 'package:pawker/ui/features/goal_settings/widgets/goal_settings_edit_screen.dart';
import 'package:pawker/ui/features/notice/widgets/notice_detail_screen.dart';
import 'package:pawker/ui/features/notice/widgets/notice_screen.dart';
import 'package:pawker/ui/features/notification/widgets/notification_screen.dart';
import 'package:pawker/ui/features/owner_dog/widgets/owner_dog_edit_screen.dart';
import 'package:pawker/ui/features/owner_dog/widgets/owner_dog_register_screen.dart';
import 'package:pawker/ui/features/owner_dog/widgets/owner_dog_screen.dart';
import 'package:pawker/ui/features/owner_main_screen/widgets/owner_main_screen.dart';
import 'package:pawker/ui/features/owner_walk/widgets/owner_walk_screen.dart';
import 'package:pawker/ui/features/owner_walk_records/widgets/owner_walk_record_detail_screen.dart';
import 'package:pawker/ui/features/owner_walk_records/widgets/owner_walk_records_screen.dart';
import 'package:pawker/ui/features/owner_walk_tracking/widgets/owner_tracking_screen.dart';
import 'package:pawker/ui/features/point/widgets/walking_point_screen.dart';
import 'package:pawker/ui/features/reward_box/widgets/reward_box_screen.dart';
import 'package:pawker/ui/features/splash/widgets/splash_screen.dart';
import 'package:pawker/ui/features/debug/sgis_test_screen.dart';
import 'package:pawker/ui/features/jobs/widgets/jobs_screen.dart';
import 'package:pawker/ui/features/jobs/widgets/owner/owner_jobs_search_screen.dart';
import 'package:pawker/ui/features/jobs/widgets/walker/walker_jobs_search_screen.dart';
import 'package:pawker/ui/features/jobs/widgets/owner/owner_job_detail_screen.dart';
import 'package:pawker/ui/features/jobs/widgets/owner/owner_job_register_screen.dart';
import 'package:pawker/ui/features/jobs/widgets/owner/my_owner_job_management_screen.dart';
import 'package:pawker/ui/features/walker_jobs/widgets/walker_job_detail_screen.dart';
import 'package:pawker/ui/features/walker_jobs/widgets/walker_review_detail_screen.dart';
import 'package:pawker/ui/features/walker_main_screen/walker_main_screen.dart';
import 'package:pawker/ui/features/walker_profile/widgets/walker_job_list_screen.dart';
import 'package:pawker/ui/features/walker_profile/widgets/walker_review_list_screen.dart';
import 'package:pawker/ui/features/walker_records/widgets/walker_record_detail_screen.dart';
import 'package:pawker/ui/features/walker_records/widgets/walker_records_screen.dart';
import 'package:pawker/ui/features/walker_register/widgets/walker_job_register_screen.dart';
import 'package:pawker/ui/features/walker_schedule/widgets/add_schedule_screen.dart';
import 'package:pawker/ui/features/walker_schedule/widgets/edit_schedule_screen.dart';
import 'package:pawker/ui/features/walker_schedule/widgets/walk_schedule_screen.dart';
import 'package:pawker/ui/features/walker_walk/widgets/walker_walk_screen.dart';
import 'package:pawker/ui/features/onboarding/widgets/onboarding_screen.dart';
import 'package:pawker/ui/features/pet_certification/widgets/pet_certification_screen.dart';
import 'package:pawker/ui/features/walk_map/walk_map_screen.dart';
import 'package:pawker/core/deep_link.dart';
import 'package:pawker/services/notification/deep_link_service.dart';

// GoRouter의 상태 변경을 감지하기 위한 Notifier입니다.
class GoRouterNotifier extends ChangeNotifier {
  final Ref _ref;
  GoRouterNotifier(this._ref) {
    // authViewModelProvider의 상태가 변경될 때마다(로그인/로그아웃)
    // GoRouter에게 알려 화면 전환 로직을 다시 실행하도록 합니다.
    _ref.listen<User?>(authViewModelProvider, (_, __) => notifyListeners());
  }
}

final goRouterNotifierProvider = Provider((ref) => GoRouterNotifier(ref));

/// NavigatorKey Provider - NotificationHandler에서 사용
final navigatorKeyProvider = Provider<GlobalKey<NavigatorState>>((ref) {
  return GlobalKey<NavigatorState>();
});

final routerProvider = Provider<GoRouter>((ref) {
  final notifier = ref.watch(goRouterNotifierProvider);
  final navigatorKey = ref.watch(navigatorKeyProvider);

  return GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: SplashScreen.path,
    refreshListenable: notifier,
    observers: [BotToastNavigatorObserver()],
    redirect: (context, state) {
      // 이제 watch 대신 read를 사용하여, 라우터 객체가 재성성되는 것을 방지합니다.
      final authState = ref.read(authViewModelProvider);
      final isLoggedIn = authState != null;

      final isLoggingIn =
          state.matchedLocation == LoginScreen.path ||
          state.matchedLocation == SignupScreen.path;

      final isSplash = state.matchedLocation == SplashScreen.path;
      final isOnboarding = state.matchedLocation == OnboardingScreen.path;

      // 스플래시 화면에서는 리다이렉션을 하지 않습니다.
      // SplashScreen에서 자체적으로 적절한 화면으로 이동합니다.
      if (isSplash) {
        return null;
      }

      // 온보딩 화면은 리다이렉션하지 않습니다.
      if (isOnboarding) {
        return null;
      }

      // Job detail 딥링크 처리:
      // go_router는 플랫폼 URL(Universal Link, App Link, custom scheme 등)을 받으면
      // router.go()로 처리해 스택을 교체합니다 → canPop()=false → 홈 아이콘 표시됨.
      // 이를 방지하기 위해 redirect에서 항상 job detail 경로를 가로채 pending에 저장하고,
      // 올바른 화면(splash or main)으로 이동 후 handlePending() → push 순으로 처리합니다.
      //
      // 단, handlePending() → _pushTo()가 router.push()를 호출할 때도 redirect가 실행되므로
      // isPushingPendingFor(loc)=true 이면 가로채지 않고 그대로 push를 허용합니다.
      final loc = state.matchedLocation;
      final isOwnerJobDetail =
          loc.startsWith(DeepLink.ownerJobDetailPath) &&
          loc.length > DeepLink.ownerJobDetailPath.length;
      final isWalkerJobDetail =
          loc.startsWith(DeepLink.walkerJobDetailPath) &&
          loc.length > DeepLink.walkerJobDetailPath.length;

      if (isOwnerJobDetail || isWalkerJobDetail) {
        // handlePending()에서 온 정상 push → 통과
        if (DeepLinkService.instance.isPushingPendingFor(loc)) {
          DeepLinkService.instance.clearPushingPending();
          return null;
        }

        // 플랫폼 URL에 의한 go → 가로채기
        DeepLinkService.instance.setPending({'type': 'job_detail', 'path': loc});

        // 다음 프레임에 handlePending 실행 (메인 화면이 완전히 렌더된 후에만)
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (DeepLinkService.instance.hasSplashCompleted) {
            DeepLinkService.instance.handlePending();
          }
        });

        if (!DeepLinkService.instance.hasSplashCompleted) {
          // Cold start: splash → main → handlePending()
          return SplashScreen.path;
        }

        // Warm start: 메인 화면으로 이동 후 handlePending()이 push
        if (authState == null) return LoginScreen.path;
        return authState.roles.contains(UserRole.owner)
            ? OwnerMainScreen.path
            : WalkerMainScreen.path;
      }

      // 로그인하지 않은 사용자가 보호된 페이지에 접근하려고 할 때
      if (!isLoggedIn && !isLoggingIn) {
        return LoginScreen.path;
      }

      // 로그인한 사용자가 로그인/회원가입 페이지에 접근하려고 할 때
      if (isLoggedIn && isLoggingIn) {
        if (authState.isRegistrationComplete) {
          return authState.roles.contains(UserRole.owner)
              ? OwnerMainScreen.path
              : WalkerMainScreen.path;
        } else {
          // login screen 로직에 따름
          return null;
        }
      }

      // 그 외의 경우는 그대로 진행
      return null;
    },
    routes: [
      GoRoute(
        path: SplashScreen.path,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: OnboardingScreen.path,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(path: LoginScreen.path, builder: (_, __) => const LoginScreen()),
      GoRoute(
        path: OwnerMainScreen.path,
        builder: (context, state) {
          return OwnerMainScreen();
        },
      ),
      GoRoute(
        path: '/dog-register',
        builder: (_, __) => const OwnerDogRegisterScreen(),
      ),
      GoRoute(
        path: OwnerDogScreen.path,
        builder: (_, __) => const OwnerDogScreen(),
      ),
      GoRoute(
        path: '/owner/dog/edit',
        name: 'owner_dog_edit',
        builder: (context, state) {
          final dog = state.extra as Dog;
          return OwnerDogEditScreen(dog: dog);
        },
      ),
      // 딥링크: /walker/job/detail/:walkerId
      GoRoute(
        path: '${WalkerJobDetailScreen.path}/:walkerId',
        name: 'walker_job_detail_deeplink',
        builder: (context, state) {
          final walkerId = state.pathParameters['walkerId']!;
          return WalkerJobDetailScreen(walkerId: walkerId);
        },
      ),
      GoRoute(
        path: WalkerJobDetailScreen.path,
        name: 'walker_job_detail',
        builder: (context, state) {
          final walkerId = state.extra as String;
          return WalkerJobDetailScreen(walkerId: walkerId);
        },
      ),
      GoRoute(
        path: WalkerJobsSearchScreen.path,
        name: 'walker_jobs_search',
        builder: (context, state) => const WalkerJobsSearchScreen(),
      ),
      GoRoute(
        path: OwnerJobsSearchScreen.path,
        name: 'owner_jobs_search',
        builder: (context, state) => const OwnerJobsSearchScreen(),
      ),
      GoRoute(
        path: JobsScreen.path,
        name: 'jobs',
        builder: (context, state) => const JobsScreen(),
      ),
      GoRoute(
        path: MyOwnerJobManagementScreen.path,
        name: 'my_owner_job_management',
        builder: (context, state) => const MyOwnerJobManagementScreen(),
      ),
      GoRoute(
        path: OwnerJobRegisterScreen.path,
        name: 'owner_job_register',
        builder: (context, state) {
          final extra = state.extra;
          if (extra is Map<String, dynamic>) {
            return OwnerJobRegisterScreen(
              isEdit: extra['isEdit'] ?? false,
              existingJob: extra['existingJob'] as OwnerJob?,
            );
          }
          return const OwnerJobRegisterScreen();
        },
      ),
      // 딥링크: /owner/job/detail/:jobId (공유 링크로 진입 시)
      GoRoute(
        path: '${OwnerJobDetailScreen.path}/:jobId',
        name: 'owner_job_detail_deeplink',
        builder: (context, state) {
          final jobId = state.pathParameters['jobId']!;
          return OwnerJobDetailByIdScreen(jobId: jobId);
        },
      ),
      GoRoute(
        path: OwnerJobDetailScreen.path,
        name: 'owner_job_detail',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final job = extra?['job'] as OwnerJob?;
          final isMine = extra?['isMine'] as bool? ?? false;
          if (job == null) {
            return const SizedBox.shrink(); // fallback; should not happen
          }
          return OwnerJobDetailScreen(job: job, isMine: isMine);
        },
      ),
      GoRoute(
        path: WalkerReviewDetailScreen.path,
        name: 'walker_review_detail',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return WalkerReviewDetailScreen(
            walkerId: extra['walkerId'] as String,
            walkerNickname: extra['walkerNickname'] as String? ?? '워커',
          );
        },
      ),

      GoRoute(
        path: NotificationScreen.path,
        name: 'notification',
        builder: (context, state) {
          return const NotificationScreen();
        },
      ),
      GoRoute(
        path: SignupScreen.path,
        name: 'signup',
        builder: (context, state) {
          final oauthUserInfo = state.extra as OAuthUserInfo;
          return SignupScreen(oauthUserInfo: oauthUserInfo);
        },
      ),
      GoRoute(
        path: WalkerMainScreen.path,
        builder: (_, __) => const WalkerMainScreen(),
      ),
      GoRoute(
        path: WalkerJobRegisterScreen.path,
        name: 'walker_job_register',
        builder: (context, state) {
          final extra = state.extra;
          if (extra is Map<String, dynamic>) {
            return WalkerJobRegisterScreen(
              isEdit: extra['isEdit'] ?? false,
              existingJob: extra['existingJob'],
            );
          } else if (extra is bool) {
            // 기존 호환성을 위해 bool 타입도 지원
            return WalkerJobRegisterScreen(isEdit: extra);
          } else {
            return const WalkerJobRegisterScreen();
          }
        },
      ),
      GoRoute(
        path: WalkerJobListScreen.path,
        name: 'walker_job_list',
        builder: (context, state) {
          return const WalkerJobListScreen();
        },
      ),
      GoRoute(
        path: WalkerReviewListScreen.path,
        name: 'walker_review_list',
        builder: (context, state) {
          return const WalkerReviewListScreen();
        },
      ),
      GoRoute(
        path: WalkerRecordsScreen.path,
        name: 'walker_records',
        builder: (_, __) => const WalkerRecordsScreen(),
      ),
      GoRoute(
        path: WalkerRecordDetailScreen.path,
        name: 'walker_record_detail',
        builder: (context, state) {
          final record = state.extra as WalkRecord;
          return WalkerRecordDetailScreen(record: record);
        },
      ),
      GoRoute(
        path: WalkScheduleScreen.path,
        name: 'walk_schedule',
        builder: (context, state) => const WalkScheduleScreen(),
      ),
      GoRoute(
        path: AddScheduleScreen.path,
        name: 'add_schedule',
        builder: (context, state) => const AddScheduleScreen(),
      ),
      GoRoute(
        path: EditScheduleScreen.path,
        name: 'edit_schedule',
        builder: (context, state) {
          final walkSchedule = state.extra as WalkSchedule;
          return EditScheduleScreen(walkSchedule: walkSchedule);
        },
      ),
      GoRoute(
        path: WalkerWalkScreen.path,
        name: 'walker_walk',
        builder: (context, state) {
          final walkRequest = state.extra as WalkRequest;
          return WalkerWalkScreen(walkRequest: walkRequest);
        },
      ),
      GoRoute(
        path: OwnerWalkRecordsScreen.path,
        name: 'owner_walk_records',
        builder: (context, state) {
          return const OwnerWalkRecordsScreen();
        },
      ),
      GoRoute(
        path: OwnerWalkRecordDetailScreen.path,
        name: 'owner_walk_record_detail',
        builder: (context, state) {
          final record = state.extra as WalkRecord;
          return OwnerWalkRecordDetailScreen(record: record);
        },
      ),
      GoRoute(
        path: OwnerWalkScreen.path,
        name: 'owner_walk',
        builder: (context, state) {
          final dog = state.extra as Dog;
          return OwnerWalkScreen(dog: dog);
        },
      ),
      GoRoute(
        path: '/owner-tracking/:walkRequestId',
        name: 'owner_tracking',
        builder: (context, state) {
          final walkRequestId = state.pathParameters['walkRequestId']!;
          final extra = state.extra as Map<String, dynamic>?;
          final walkerName = extra?['walkerName'] as String? ?? '워커';

          return OwnerTrackingScreen(
            walkRequestId: walkRequestId,
            walkerName: walkerName,
          );
        },
      ),
      GoRoute(
        path: ProfileEditScreen.path,
        name: 'profile_edit',
        builder: (context, state) {
          return const ProfileEditScreen();
        },
      ),
      GoRoute(
        path: PhoneVerificationScreen.path,
        name: 'phone_verification',
        builder: (context, state) {
          final initialPhone = state.extra as String?;
          return PhoneVerificationScreen(initialPhone: initialPhone);
        },
      ),
      GoRoute(
        path: MarketingConsentScreen.path,
        name: 'marketing_consent',
        builder: (context, state) {
          return const MarketingConsentScreen();
        },
      ),
      GoRoute(
        path: AuthUserInfoScreen.path,
        name: 'auth_user_info',
        builder: (context, state) {
          return const AuthUserInfoScreen();
        },
      ),
      GoRoute(
        path: WalkingPointScreen.path,
        name: 'walking_point',
        builder: (context, state) {
          return const WalkingPointScreen();
        },
      ),
      GoRoute(
        path: GoalSettingsEditScreen.path,
        name: 'goal_settings_edit',
        builder: (context, state) {
          return const GoalSettingsEditScreen();
        },
      ),
      /*
      GoRoute(
        path: SubscriptionScreen.path,
        name: 'subscription',
        builder: (context, state) {
          return const SubscriptionScreen();
        },
      ),
      GoRoute(
        path: SubscriptionTestScreen.path,
        name: 'subscription_test',
        builder: (context, state) {
          return const SubscriptionTestScreen();
        },
      ),
      GoRoute(
        path: SubscriptionManageScreen.path,
        name: 'subscription_manage',
        builder: (context, state) {
          return const SubscriptionManageScreen();
        },
      ),
      GoRoute(
        path: SubscriptionManageScreen.path,
        builder: (context, state) {
          return const SubscriptionManageScreen();
        },
      ),
      */
      GoRoute(
        path: SGISTestScreen.path,
        builder: (context, state) {
          return const SGISTestScreen();
        },
      ),
      GoRoute(
        path: ChatListScreen.path,
        builder: (context, state) {
          return const ChatListScreen();
        },
      ),
      GoRoute(
        path: ChatRoomScreen.path,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return ChatRoomScreen(
            roomId: extra['roomId'] as String,
            chatPartnerName: extra['chatPartnerName'] as String,
            chatPartnerId: extra['chatPartnerId'] as String,
            isOwner: extra['isOwner'] as bool,
            dogId: extra['dogId'] as String?,
            dogName: extra['dogName'] as String?,
          );
        },
      ),
      GoRoute(
        path: ChatImageDetailScreen.path,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return ChatImageDetailScreen(
            imageUrls: List<String>.from(extra['imageUrls'] as List),
            initialIndex: extra['initialIndex'] as int? ?? 0,
          );
        },
      ),
      GoRoute(
        path: AppInfoScreen.path,
        builder: (context, state) {
          return const AppInfoScreen();
        },
      ),
      GoRoute(
        path: BlockUserListScreen.path,
        builder: (context, state) {
          return const BlockUserListScreen();
        },
      ),
      GoRoute(
        path: FaqScreen.path,
        builder: (context, state) {
          return const FaqScreen();
        },
      ),
      GoRoute(
        path: AskScreen.path,
        builder: (context, state) {
          return const AskScreen();
        },
      ),
      GoRoute(
        path: RewardBoxScreen.path,
        builder: (context, state) {
          return const RewardBoxScreen();
        },
      ),
      GoRoute(
        path: NoticeScreen.path,
        builder: (context, state) {
          return const NoticeScreen();
        },
      ),
      GoRoute(
        path: NoticeDetailScreen.path,
        builder: (context, state) {
          final notice = state.extra as Notice;
          return NoticeDetailScreen(notice: notice);
        },
      ),
      GoRoute(
        path: PetCertificationScreen.path,
        builder: (context, state) => const PetCertificationScreen(),
      ),
      GoRoute(
        path: FeedScreen.path,
        builder: (context, state) => const FeedScreen(),
      ),
      GoRoute(
        path: MyFeedScreen.path,
        builder: (context, state) => const MyFeedScreen(),
      ),
      GoRoute(
        path: FeedDetailScreen.path,
        pageBuilder: (context, state) {
          final post = state.extra as FeedPost;
          return MaterialPage(
            key: ValueKey('feed-detail-${post.id}'),
            child: FeedDetailScreen(post: post),
          );
        },
      ),
      GoRoute(
        path: FeedCreateScreen.path,
        builder: (context, state) => const FeedCreateScreen(),
      ),
      GoRoute(
        path: FeedEditScreen.path,
        builder: (context, state) {
          final post = state.extra as FeedPost;
          return FeedEditScreen(post: post);
        },
      ),
      GoRoute(
        path: ExchangeRequestListScreen.path,
        builder: (context, state) {
          return const ExchangeRequestListScreen();
        },
      ),
      GoRoute(
        path: BanScreen.path,
        builder: (context, state) {
          final banException = state.extra as AccountBannedException?;
          return BanScreen(banException: banException);
        },
      ),
      GoRoute(
        path: WalkMapScreen.path,
        builder: (context, state) => const WalkMapScreen(),
      ),
    ],
  );
});
