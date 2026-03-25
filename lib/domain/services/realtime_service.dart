/// 실시간 WebSocket 연결 도메인 서비스 인터페이스
///
/// 서버와의 실시간 양방향 통신 계약을 정의한다.
/// 구현체: [RealtimeServiceManager] (services/realtime_service_manager.dart)
abstract interface class RealtimeService {
  /// WebSocket이 현재 연결된 상태인지 여부
  bool get isConnected;

  /// 서버에서 수신되는 메시지 스트림
  Stream<Map<String, dynamic>> get messageStream;

  /// WebSocket 메시지 전송
  void sendMessage(Map<String, dynamic> message);

  /// 연결 해제 (로그아웃 등 의도적 해제 시 호출)
  void disconnect();

  /// 리소스 정리
  void dispose();
}
