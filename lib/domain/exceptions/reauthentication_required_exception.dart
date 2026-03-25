/// 재인증이 필요한 경우 발생하는 예외
/// 
/// 서버에서 401 에러와 함께 code: 'ACCOUNT_REAUTHENTICATION_REQUIRED'를 반환할 때
/// 이 예외가 발생합니다. 클라이언트는 이를 감지하여 로그아웃 처리 후
/// 재인증 플로우를 시작해야 합니다.
class ReauthenticationRequiredException implements Exception {
  final String message;
  final String? code;

  ReauthenticationRequiredException({
    this.message = '재인증이 필요합니다. 다시 로그인해주세요.',
    this.code,
  });

  @override
  String toString() => message;
}

