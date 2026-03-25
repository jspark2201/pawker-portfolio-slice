import 'dart:async';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pawker/ui/core/themes/app_colors.dart';
import 'package:riverpod/riverpod.dart' as riverpod;
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:naver_login_sdk/naver_login_sdk.dart';
import 'package:pawker/config/ad_config.dart';
import 'package:pawker/config/environment.dart';
import 'package:pawker/domain/entities/user.dart';
import 'package:pawker/config/firebase_options_prod.dart' as prod;
import 'package:pawker/flavors.dart';
import 'package:pawker/routing/app_router.dart';
import 'package:pawker/di/service_providers.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pawker/services/debug/firebase_test_service.dart';
import 'package:pawker/core/deep_link.dart';
import 'package:pawker/services/notification/deep_link_service.dart';
import 'package:pawker/services/notification/notification_handler.dart';
import 'package:pawker/services/notification/notification_service.dart';
import 'package:pawker/services/notification/badge_service.dart';
import 'package:pawker/services/region_service.dart';
import 'package:pawker/services/update_service.dart';
import 'package:pawker/services/realtime_service_manager.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:pawker/services/app_lifecycle_service.dart';
import 'package:pawker/core/utils/app_logger.dart';
import 'package:pawker/services/unity_ads_initializer.dart';
import 'package:pawker/ui/features/auth/view_model/auth_view_model.dart';
import 'package:pawker/ui/core/tutorial/tutorial_notifier.dart';
import 'package:pawker/ui/core/tutorial/tutorial_overlay.dart';
import 'package:pawker/ui/features/chat/view_model/chat_list_provider.dart';
import 'package:pawker/ui/core/themes/app_theme.dart';
import 'package:rive/rive.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

void main() async {
  // 환경 설정
  const environment = String.fromEnvironment(
    'ENVIRONMENT',
    defaultValue: 'production',
  );

  // 환경 설정 적용
  AppConfig.setEnvironment(
    environment == 'production'
        ? Environment.production
        : Environment.development,
  );

  await SentryFlutter.init(
    (options) {
      options.dsn = AppConfig.sentryDsn;
      options.sendDefaultPii = true;
      options.enableLogs = true;
      options.environment = 'production';
      options.tracesSampleRate = 1.0;
      options.profilesSampleRate = 1.0;
    },
    appRunner: () async {
      WidgetsFlutterBinding.ensureInitialized();
      MobileAds.instance.initialize();
      // Logger 초기화
      logger.init();

      F.appFlavor = Flavor.values.firstWhere(
        (element) => element.name == appFlavor,
      );

      await Firebase.initializeApp(
        name: 'pawker-prod',
        options: prod.DefaultFirebaseOptions.currentPlatform,
      );

      // 네이버 SDK 초기화
      NaverLoginSDK.initialize(
        urlScheme: AppConfig.naverUrlScheme,
        clientId: AppConfig.naverClientId,
        clientSecret: AppConfig.naverClientSecret,
        clientName: AppConfig.naverClientName,
      );

      await FlutterNaverMap().init(
        clientId: AppConfig.naverMapClientId,
        onAuthFailed:
            (ex) => switch (ex) {
              NQuotaExceededException(:final message) => logger.d(
                "사용량 초과 (message: $message)",
              ),
              NUnauthorizedClientException() ||
              NClientUnspecifiedException() ||
              NAnotherAuthFailedException() => logger.d("인증 실패: $ex"),
            },
      );

      // 앱 시작 시 또는 설정 화면에서
      final results = await FirebaseTestService.testFirebaseSDKs();
      FirebaseTestService.printTestResults(results);

      // 업데이트 서비스 초기화 (스플래시에서 실제 확인 및 다이얼로그 표시)
      await UpdateService.initialize();

      // 지역 데이터 백그라운드 업데이트 (앱 시작 시간에 영향 없도록 비동기 실행)
      unawaited(_initializeRegionData());

      // 알림 서비스 초기화
      await NotificationService.initializeLocalNotifications();
      await NotificationService.requestNotificationPermission();

      // ProviderContainer를 생성하여 NotificationHandler에 전달
      final container = riverpod.ProviderContainer();

      // 알림 핸들러 초기화
      await NotificationHandler.initialize(container: container);

      // 시뮬레이터/에뮬레이터에서는 광고·환경을 테스트 모드로 (실기기에서만 production)
      final isSimulatorOrEmulator = await _isSimulatorOrEmulator();
      // prod entrypoint로 실행되더라도, 디버그 빌드라면 테스트 모드로 처리한다.
      // (실배포(release)에서만 production으로 동작)
      AdConfig.initialize(isProduction: !isSimulatorOrEmulator && kReleaseMode);

      await initializeUnityAds();

      await RiveNative.init();

      // 카카오 SDK 초기화
      // KakaoSdk.init(nativeAppKey: AppConfig.kakaoNativeAppKey);

      runApp(
        UncontrolledProviderScope(container: container, child: const MyApp()),
      );

      const sentrySmokeTest = bool.fromEnvironment(
        'SENTRY_SMOKE_TEST',
        defaultValue: false,
      );
      if (sentrySmokeTest) {
        await Sentry.captureException(
          StateError('Sentry smoke test (production)'),
        );
      }
    },
  );
}

/// 시뮬레이터(iOS) 또는 에뮬레이터(Android) 여부. 실기기가 아니면 true.
Future<bool> _isSimulatorOrEmulator() async {
  try {
    if (Platform.isIOS) {
      final info = await DeviceInfoPlugin().iosInfo;
      return info.isPhysicalDevice != true;
    }
    if (Platform.isAndroid) {
      final info = await DeviceInfoPlugin().androidInfo;
      return info.isPhysicalDevice != true;
    }
  } catch (_) {}
  return true;
}

/// 지역 데이터를 백그라운드에서 초기화합니다.
Future<void> _initializeRegionData() async {
  try {
    logger.d('🌍 지역 데이터 백그라운드 업데이트 시작...');
    await RegionService.updateRegionsFromAPI();
    logger.d('지역 데이터 백그라운드 업데이트 완료');
  } catch (e) {
    logger.e('지역 데이터 백그라운드 업데이트 실패: $e');
    // 실패해도 앱 실행에는 영향 없음 (fallback 데이터 사용)
  }
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> with WidgetsBindingObserver {
  StreamSubscription<Uri>? _uriLinkSubscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // 앱 상태 초기화
    AppLifecycleService().updateState(AppLifecycleState.resumed);

    // 딥링크: uriLinkStream으로 들어온 URL은 항상 setPending으로 저장하고
    // addPostFrameCallback에서 처리합니다. router.push()를 직접 호출하지 않는 이유:
    // go_router가 플랫폼 URL을 동시에 go()로 처리하면 push보다 늦게 스택이 교체되어
    // canPop()=false(홈 아이콘)가 됩니다. redirect에서 모든 job detail을 가로채
    // handlePending() → _pushTo() → router.push() 경로로만 push되도록 통합합니다.
    _uriLinkSubscription = DeepLink.uriLinkStream.listen((uri) {
      final path = DeepLink.pathForJobDetail(uri);
      if (path != null && mounted) {
        DeepLinkService.instance.setPending({
          'type': 'job_detail',
          'path': path,
        });
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (DeepLinkService.instance.hasSplashCompleted) {
            DeepLinkService.instance.handlePending();
          }
        });
      }
    });

    // ProviderScope의 container를 NotificationHandler에 전달
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        final container = ProviderScope.containerOf(context);
        NotificationHandler.updateContext(context, ref);
        logger.d('✅ NotificationHandler에 context와 ref 업데이트 완료');
        logger.d('   - container: ${container.hashCode}');
        // 이미 로그인된 상태로 앱 실행 시(예: 앱 재실행) WebSocket 한 번 연결
        final user = ref.read(authViewModelProvider);
        if (user != null && !RealtimeServiceManager.instance.isConnected) {
          logger.d('🔌 앱 실행 시 로그인 유지됨 - WebSocket 연결');
          _setRealtimeRefreshChatListCallback(ref);
          RealtimeServiceManager.instance.initialize(ref);
        }
      } catch (e) {
        logger.w('⚠️ ProviderScope container 가져오기 실패: $e');
      }

      // handlePending()은 메인 화면(OwnerMainScreen / WalkerMainScreen)의
      // addPostFrameCallback에서 호출됩니다. 여기서 중복 호출하면 redirect가
      // 아직 실행 중일 때 push가 발생해 double-splash를 유발하므로 제거합니다.
    });
  }

  @override
  void dispose() {
    _uriLinkSubscription?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final tokenRefreshService = ref.read(tokenRefreshServiceProvider);

    // 앱 상태 추적 서비스에 상태 업데이트
    AppLifecycleService().updateState(state);

    switch (state) {
      case AppLifecycleState.resumed:
        tokenRefreshService.onAppResumed();
        _updateBadgeCount();
        // WebSocket이 끊겨 있으면 한 번 재연결 시도
        RealtimeServiceManager.instance.tryReconnectOnForeground(ref);
        break;
      case AppLifecycleState.paused:
        tokenRefreshService.onAppPaused();
        break;
      default:
        break;
    }
  }

  /// Realtime 서비스에서 authenticated/refresh_chat_list 수신 시 GET /chat/rooms 호출하도록 콜백 등록
  void _setRealtimeRefreshChatListCallback(WidgetRef ref) {
    RealtimeServiceManager.instance.setOnRefreshChatListRequested(() {
      ref.read(chatListNotifierProvider.notifier).loadChatRooms(refresh: true);
    });
  }

  /// Badge Count 업데이트
  Future<void> _updateBadgeCount() async {
    try {
      // 로그인 상태 확인
      final user = ref.read(authViewModelProvider);
      final badgeService = ref.read(badgeServiceProvider.notifier);

      if (user == null) {
        logger.d('로그인되지 않아 Badge 업데이트 0');
        await badgeService.clearBadge();
        return;
      }

      final count = await badgeService.fetchAndUpdateBadge();
      logger.d('Badge 업데이트 완료: $count');
    } catch (e) {
      logger.e('Badge 업데이트 실패: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.read(routerProvider);

    // 로그인 상태 변화 감지하여 WebSocket 연결/해제
    ref.listen<User?>(authViewModelProvider, (previous, next) {
      if (next != null && previous == null) {
        // 로그인 시 WebSocket 서비스 초기화
        logger.d('🔑 사용자 로그인 감지: ${next.id}');
        _setRealtimeRefreshChatListCallback(ref);
        RealtimeServiceManager.instance.initialize(ref);
      } else if (next == null && previous != null) {
        // 로그아웃 시 WebSocket 서비스 정리
        logger.d('🚪 사용자 로그아웃 감지');
        RealtimeServiceManager.instance.disconnect();
      }
    });

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: '강아지 산책 알바 앱',
      theme: ThemeData(
        useMaterial3: true,
        appBarTheme: AppTheme.lightTheme.appBarTheme,
        scaffoldBackgroundColor: AppColors.background,
        fontFamily: 'Pretendard',
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('ko', 'KR'), Locale('en', 'US')],
      locale: const Locale('ko', 'KR'),
      routerConfig: router,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: TextScaler.noScaling),
          child: BotToastInit()(
            context,
            Consumer(
              builder: (ctx, ref, _) {
                final tutorialState = ref.watch(tutorialNotifierProvider);
                return Stack(
                  children: [
                    child!,
                    if (tutorialState.isVisible)
                      TutorialOverlay(state: tutorialState),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}
