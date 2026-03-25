/// 인프라 / 데이터 레이어에서 던지는 예외
///
/// 상위 레이어(Repository, Use Case)에서 [AppFailure] 로 변환하여
/// 도메인 / UI 레이어로 전달한다.

/// 네트워크 연결 오류 (타임아웃, DNS, 소켓 오류 등)
class NetworkException implements Exception {
  const NetworkException([this.message = '네트워크 연결을 확인해주세요.']);

  final String message;

  @override
  String toString() => 'NetworkException: $message';
}

/// 서버가 오류 응답(4xx / 5xx)을 반환한 경우
class ServerException implements Exception {
  const ServerException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() => 'ServerException($statusCode): $message';
}

/// 로컬 저장소(SharedPreferences, SecureStorage 등) 오류
class CacheException implements Exception {
  const CacheException([this.message = '로컬 데이터 처리 중 오류가 발생했습니다.']);

  final String message;

  @override
  String toString() => 'CacheException: $message';
}
