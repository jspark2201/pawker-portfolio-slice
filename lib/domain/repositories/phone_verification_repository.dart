/// 전화번호 인증 (발송/확인) 레포지토리.
abstract class PhoneVerificationRepository {
  /// 인증번호 발송. 성공 시 완료, 실패 시 예외.
  Future<void> sendVerificationCode(String phoneNumber);

  /// 인증번호 확인. 성공 시 완료, 실패 시 예외.
  Future<void> verifyCode(String phoneNumber, String code);
}
