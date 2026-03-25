/// 도메인 레이어에서 발생하는 실패 타입
///
/// Repository / Use Case 가 Exception 대신 반환하거나, UI 에서 에러 상태를
/// 패턴 매칭으로 처리할 때 사용한다.
sealed class AppFailure {
  const AppFailure(this.message);

  final String message;
}

/// 네트워크 연결 실패 (타임아웃, 오프라인 등)
final class NetworkFailure extends AppFailure {
  const NetworkFailure([super.message = '네트워크 연결을 확인해주세요.']);
}

/// 서버 응답 오류 (4xx / 5xx)
final class ServerFailure extends AppFailure {
  const ServerFailure(super.message, {this.statusCode});

  final int? statusCode;
}

/// 인증 / 인가 오류
final class AuthFailure extends AppFailure {
  const AuthFailure([super.message = '인증이 필요합니다.']);
}

/// 리소스를 찾을 수 없음 (404)
final class NotFoundFailure extends AppFailure {
  const NotFoundFailure([super.message = '요청한 데이터를 찾을 수 없습니다.']);
}

/// 로컬 저장소 읽기 / 쓰기 오류
final class CacheFailure extends AppFailure {
  const CacheFailure([super.message = '데이터를 저장하거나 불러오는 데 실패했습니다.']);
}

/// 알 수 없는 오류 (예외 처리 누락 등)
final class UnknownFailure extends AppFailure {
  const UnknownFailure([super.message = '알 수 없는 오류가 발생했습니다.']);
}
