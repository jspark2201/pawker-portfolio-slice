// lib/ui/auth/login_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pawker/domain/use_cases/auth/login_use_case.dart';
import 'package:pawker/ui/features/auth/view_model/auth_view_model.dart';
import 'package:pawker/ui/features/auth/widgets/signup_screen.dart';
import 'package:pawker/ui/core/themes/theme.dart';
import 'package:pawker/ui/core/components/decorative_background.dart';
import 'package:pawker/ui/features/owner_main_screen/widgets/owner_main_screen.dart';
import 'package:pawker/ui/features/walker_main_screen/walker_main_screen.dart';
import 'package:pawker/domain/entities/user.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:pawker/core/utils/app_logger.dart';
import 'package:pawker/domain/exceptions/account_banned_exception.dart';
import 'package:pawker/ui/features/ban/widgets/ban_screen.dart';
import 'package:rive/rive.dart';

class LoginScreen extends ConsumerStatefulWidget {
  static const path = '/login';
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  bool _isLoading = false;

  Future<void> handleOAuthLogin(BuildContext context, String provider) async {
    if (_isLoading) return; // 이미 로딩 중이면 중복 요청 방지

    setState(() {
      _isLoading = true;
    });

    try {
      logger.d('🔐 로그인 시작: $provider');
      final authViewModel = ref.read(authViewModelProvider.notifier);
      final result = await authViewModel.login(provider);
      logger.d('🔐 로그인 결과: $result');

      if (!context.mounted) return;

      switch (result['result']) {
        case LoginResult.success:
          final user = ref.read(authViewModelProvider);
          if (user != null && user.roles.isNotEmpty) {
            final path =
                user.roles.contains(UserRole.owner)
                    ? OwnerMainScreen.path
                    : WalkerMainScreen.path;
            context.go(path);
          } else {
            // context.go(OwnerMainScreen.path); // fallback
          }
          break;
        case LoginResult.newUser:
          context.go(SignupScreen.path, extra: result['oauthUserInfo']);
          break;
        case LoginResult.error:
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('로그인에 실패했습니다: ${result['error'] ?? '알 수 없는 오류'}'),
              duration: const Duration(seconds: 5),
              backgroundColor: Colors.red,
            ),
          );
          break;
      }
    } on AccountBannedException catch (e) {
      logger.w('🔐 LoginScreen: 계정 차단 감지 - ${e.message}');
      if (context.mounted) {
        context.go(BanScreen.path, extra: e);
      }
    } catch (e, stackTrace) {
      logger.d('🔐 LoginScreen: 예외 발생 - $e');
      logger.d('🔐 LoginScreen: 스택 트레이스 - $stackTrace');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('로그인 중 오류가 발생했습니다: $e'),
            duration: const Duration(seconds: 5),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> handleDummyWalkerLogin(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final authViewModel = ref.read(authViewModelProvider.notifier);
    await authViewModel.loginDummyWalker();
    if (!context.mounted) return;
    context.go('/walker/main');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 곡선 형태의 장식 배경
          const DecorativeBackground(),
          Center(
            child: Column(
              children: [
                // 상단 여백
                // 하단 여백
                Flexible(flex: 3, child: Container()),

                // 로고를 화면 가운데에 배치
                Image.asset(
                  'assets/icon/icon-removebg.png',
                  width: 128,
                  height: 128,
                ),
                Image.asset('assets/icon/logo.png', width: 96),
                // Text('PAWKER', style: AppTextStyles.heading1),
                Flexible(flex: 1, child: Container()),
                Text(
                  '우리동네 반려동물 산책 매칭 서비스',
                  style: AppTextStyles.body1.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                // 하단 여백
                Flexible(flex: 3, child: Container()),
                // 버튼들을 화면 아래쪽에 배치
                Column(
                  children: [
                    // 네이버: 커스텀 버튼으로 폰트/스타일을 애플 버튼과 동일하게 맞춤
                    SizedBox(
                      width: 166,
                      height: 44,
                      child: ElevatedButton(
                        onPressed:
                            _isLoading
                                ? null
                                : () async {
                                  await handleOAuthLogin(context, 'naver');
                                },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF03A94D),
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: const Color(0xFF03A94D),
                          disabledForegroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                        ),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _NaverLogoMark(size: 36),
                              // const SizedBox(width: 6),
                              Text(
                                '네이버 로그인',
                                style: AppTextStyles.button.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: 6),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: 166,
                      height: 44,
                      child: ElevatedButton(
                        onPressed:
                            _isLoading
                                ? null
                                : () async {
                                  // iOS 실제 기기에서만 Apple Sign-In 지원
                                  if (!Platform.isIOS) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Apple 로그인은 iOS 기기에서만 지원됩니다.',
                                        ),
                                      ),
                                    );
                                    return;
                                  }

                                  try {
                                    // Apple Sign-In 성공 시 처리
                                    await handleOAuthLogin(context, 'apple');
                                  } on SignInWithAppleAuthorizationException catch (
                                    e
                                  ) {
                                    logger.e('Apple Sign-In 에러: $e');

                                    String errorMessage = 'Apple 로그인에 실패했습니다.';

                                    switch (e.code) {
                                      case AuthorizationErrorCode.canceled:
                                        errorMessage = '로그인이 취소되었습니다.';
                                        break;
                                      case AuthorizationErrorCode.failed:
                                        errorMessage = '로그인에 실패했습니다.';
                                        break;
                                      case AuthorizationErrorCode
                                          .invalidResponse:
                                        errorMessage = '잘못된 응답입니다.';
                                        break;
                                      case AuthorizationErrorCode.notHandled:
                                        errorMessage = '처리되지 않은 요청입니다.';
                                        break;
                                      case AuthorizationErrorCode.unknown:
                                        errorMessage =
                                            '알 수 없는 오류가 발생했습니다.\n실제 기기에서 테스트해주세요.';
                                        break;
                                      case AuthorizationErrorCode
                                          .notInteractive:
                                        errorMessage = '인터랙티브하지 않은 요청입니다.';
                                        break;
                                      default:
                                        errorMessage = '알 수 없는 오류가 발생했습니다.';
                                        break;
                                    }

                                    if (context.mounted) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            '$errorMessage\n에러 코드: ${e.code}',
                                          ),
                                          duration: const Duration(seconds: 5),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
                                  } catch (e) {
                                    logger.e('기타 에러: $e');
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text('로그인 중 오류가 발생했습니다: $e'),
                                          duration: const Duration(seconds: 5),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
                                  }
                                },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: Colors.black,
                          disabledForegroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                        ),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  // color: Colors.green,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(Icons.apple, size: 24),
                              ),
                              Text(
                                '애플로 로그인',
                                style: AppTextStyles.button.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: 6),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Flexible(flex: 1, child: Container()),
              ],
            ),
          ),
          // 로딩 오버레이
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: Container(
                  padding: AppSpacing.paddingXXXL,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: AppRadius.radiusXL,
                    boxShadow: AppShadows.elevation4,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.primary,
                        ),
                      ),
                      AppSpacing.verticalLG,
                      Text(
                        '로그인 중...',
                        style: AppTextStyles.body1.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// 네이버 그린 버튼용 공식 로고 (LIGHT = 밝은 아이콘, H56 = 56px 높이, 44pt 버튼에 맞음).
class _NaverLogoMark extends StatelessWidget {
  const _NaverLogoMark({required this.size});
  final double size;

  static const String _assetPath =
      'assets/icon/NAVER_login_Light_KR_green_icon_H48.png';

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Image.asset(_assetPath, fit: BoxFit.contain),
    );
  }
}
