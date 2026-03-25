import 'package:pawker/di/repository_providers.dart';
import 'package:pawker/di/service_providers.dart';
import 'package:pawker/di/use_case_providers.dart';
import 'package:pawker/domain/entities/oauth_user_info.dart';
import 'package:pawker/domain/entities/subscription.dart';
import 'package:pawker/domain/exceptions/reauthentication_required_exception.dart';
import 'package:pawker/domain/use_cases/auth/auto_login_use_case.dart';
import 'package:pawker/domain/use_cases/auth/login_use_case.dart';
import 'package:pawker/domain/use_cases/auth/logout_use_case.dart';
import 'package:pawker/domain/use_cases/auth/signup_use_case.dart';
import 'package:pawker/domain/use_cases/user/update_profile_use_case.dart';
import 'package:pawker/services/notification/badge_service.dart';
import 'package:pawker/core/utils/app_logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:pawker/domain/entities/user.dart';

part 'auth_view_model.g.dart';

@Riverpod(keepAlive: true)
class AuthViewModel extends _$AuthViewModel {
  @override
  User? build() => null;

  AutoLoginUseCase get _autoLoginUseCase => ref.read(autoLoginUseCaseProvider);
  LoginUseCase get _loginUseCase => ref.read(loginUseCaseProvider);
  LogoutUseCase get _logoutUseCase => ref.read(logoutUseCaseProvider);
  SignupUseCase get _signupUseCase => ref.read(signupUseCaseProvider);
  UpdateProfileUseCase get _updateProfileUseCase =>
      ref.read(updateProfileUseCaseProvider);

  Future<void> tryAutoLogin() async {
    try {
      final user = await _autoLoginUseCase();
      if (user != null) {
        state = user;
        final badgeService = ref.read(badgeServiceProvider.notifier);
        await badgeService.fetchAndUpdateBadge();
      }
    } on ReauthenticationRequiredException catch (e) {
      logger.w('재인증이 필요합니다: ${e.message}');
      final badgeService = ref.read(badgeServiceProvider.notifier);
      await badgeService.clearBadge();
      rethrow;
    } catch (e) {
      logger.e('자동 로그인 실패: $e');
      final badgeService = ref.read(badgeServiceProvider.notifier);
      await badgeService.clearBadge();
    }
  }

  Future<Map<String, dynamic>> login(String provider) async {
    logger.d('🔐 AuthViewModel: 로그인 시작 - $provider');
    final output = await _loginUseCase(provider);
    logger.d('🔐 AuthViewModel: UseCase 결과 - ${output.result}');

    if (output.user != null) {
      state = output.user;
      final badgeService = ref.read(badgeServiceProvider.notifier);
      await badgeService.fetchAndUpdateBadge().catchError((e) {
        logger.e('Badge 업데이트 실패: $e');
      });
    }

    return {
      'result': output.result,
      'oauthUserInfo': output.oauthUserInfo,
      if (output.errorMessage != null) 'error': output.errorMessage,
    };
  }

  Future<void> signup(
    OAuthUserInfo oauthUserInfo,
    String nickname,
    UserRole role, {
    String? phoneNumber,
    bool marketingPushAgreed = false,
    bool marketingEmailAgreed = false,
    bool marketingSmsAgreed = false,
  }) async {
    final user = await _signupUseCase(
      oauthUserInfo: oauthUserInfo,
      nickname: nickname,
      role: role,
      phoneNumber: phoneNumber,
      marketingPushAgreed: marketingPushAgreed,
      marketingEmailAgreed: marketingEmailAgreed,
      marketingSmsAgreed: marketingSmsAgreed,
    );
    state = user;
  }

  Future<void> logout() async {
    try {
      final badgeService = ref.read(badgeServiceProvider.notifier);
      await badgeService.clearBadge();
    } catch (e) {
      logger.e('Badge 초기화 실패: $e');
    }
    await _logoutUseCase();
    state = null;
  }

  Future<bool> deleteAccount() async {
    final authRepository = ref.read(authRepositoryProvider);
    try {
      await authRepository.deleteAccount();
      state = null;
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateProfile({
    String? nickname,
    String? phoneNumber,
    String? profileImage,
    bool? marketingPushAgreed,
    bool? marketingEmailAgreed,
    bool? marketingSmsAgreed,
  }) async {
    try {
      final updatedUser = await _updateProfileUseCase(
        nickname: nickname,
        phoneNumber: phoneNumber,
        profileImage: profileImage,
        marketingPushAgreed: marketingPushAgreed,
        marketingEmailAgreed: marketingEmailAgreed,
        marketingSmsAgreed: marketingSmsAgreed,
      );
      if (updatedUser != null) {
        state = updatedUser;
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<void> refreshCurrentUser() async {
    try {
      final userRepository = ref.read(userRepositoryProvider);
      final user = await userRepository.getMe();
      if (user != null) state = user;
    } catch (e) {
      logger.e('refreshCurrentUser 실패: $e');
    }
  }
}
