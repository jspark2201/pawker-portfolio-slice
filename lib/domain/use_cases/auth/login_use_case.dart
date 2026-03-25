import 'package:pawker/domain/entities/oauth_user_info.dart';
import 'package:pawker/domain/entities/user.dart';
import 'package:pawker/domain/repositories/auth_repository.dart';
import 'package:pawker/domain/repositories/user_repository.dart';
import 'package:pawker/domain/services/push_notification_service.dart';

/// 소셜 로그인 결과 타입
enum LoginResult { success, newUser, error }

class LoginOutput {
  const LoginOutput({
    required this.result,
    this.user,
    this.oauthUserInfo,
    this.errorMessage,
  });

  final LoginResult result;
  final User? user;
  final OAuthUserInfo? oauthUserInfo;
  final String? errorMessage;
}

/// 소셜 로그인 Use Case
///
/// 1. 소셜 OAuth 로그인 실행
/// 2. 신규 유저 여부 판단
/// 3. 기존 유저면 FCM 토큰 등록 및 배지 업데이트
class LoginUseCase {
  const LoginUseCase({
    required this.authRepository,
    required this.userRepository,
    required this.pushNotificationService,
  });

  final AuthRepository authRepository;
  final UserRepository userRepository;
  final PushNotificationService pushNotificationService;

  Future<LoginOutput> call(String provider) async {
    try {
      final response = await authRepository.login(provider);
      final user = response['user'] as User?;
      final oauthUserInfo = response['oauthUserInfo'] as OAuthUserInfo?;

      if (user != null) {
        await pushNotificationService.registerFCMToken();

        final result =
            user.isRegistrationComplete
                ? LoginResult.success
                : LoginResult.newUser;

        return LoginOutput(
          result: result,
          user: user,
          oauthUserInfo: oauthUserInfo,
        );
      }

      return LoginOutput(
        result: LoginResult.newUser,
        oauthUserInfo: oauthUserInfo,
      );
    } catch (e) {
      return LoginOutput(
        result: LoginResult.error,
        errorMessage: e.toString(),
      );
    }
  }
}
