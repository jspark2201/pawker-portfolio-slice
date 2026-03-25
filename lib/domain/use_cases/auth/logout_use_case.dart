import 'package:pawker/domain/repositories/auth_repository.dart';
import 'package:pawker/domain/services/push_notification_service.dart';

/// 로그아웃 Use Case
///
/// 1. FCM 토큰 서버 해제
/// 2. 인증 토큰/세션 삭제
class LogoutUseCase {
  const LogoutUseCase({
    required this.authRepository,
    required this.pushNotificationService,
  });

  final AuthRepository authRepository;
  final PushNotificationService pushNotificationService;

  Future<void> call() async {
    await pushNotificationService.unregisterFCMToken();
    await authRepository.logout();
  }
}
