import 'package:pawker/domain/entities/user.dart';
import 'package:pawker/domain/exceptions/reauthentication_required_exception.dart';
import 'package:pawker/domain/repositories/auth_repository.dart';
import 'package:pawker/domain/repositories/user_repository.dart';
import 'package:pawker/domain/services/push_notification_service.dart';

/// 자동 로그인 Use Case
///
/// 1. 저장된 토큰으로 로그인 상태 확인
/// 2. 유저 정보 조회
/// 3. FCM 토큰 등록
///
/// 재인증이 필요한 경우 [ReauthenticationRequiredException] 을 rethrow 한다.
class AutoLoginUseCase {
  const AutoLoginUseCase({
    required this.authRepository,
    required this.userRepository,
    required this.pushNotificationService,
  });

  final AuthRepository authRepository;
  final UserRepository userRepository;
  final PushNotificationService pushNotificationService;

  /// 반환값: 로그인된 유저, 없으면 null
  Future<User?> call() async {
    final isLoggedIn = await authRepository.isLoggedIn();
    if (!isLoggedIn) return null;

    try {
      final user = await userRepository.getMe();
      if (user != null) {
        await pushNotificationService.registerFCMToken();
      }
      return user;
    } on ReauthenticationRequiredException {
      await authRepository.logout();
      rethrow;
    }
  }
}
