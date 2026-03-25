/// 푸시 알림 도메인 서비스 인터페이스
///
/// FCM 토큰 관리 및 알림 권한 요청 동작을 추상화한다.
/// 구현체: [FCMService] (services/notification/fcm_service.dart)
abstract interface class PushNotificationService {
  /// 서버에 FCM 토큰 등록 (로그인 / 자동 로그인 성공 시 호출)
  Future<bool> registerFCMToken();

  /// 서버에서 FCM 토큰 비활성화 (로그아웃 시 호출)
  Future<bool> unregisterFCMToken();

  /// 알림 권한 요청
  Future<bool> requestNotificationPermission();
}
