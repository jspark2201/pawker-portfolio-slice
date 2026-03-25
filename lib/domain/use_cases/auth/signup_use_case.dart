import 'package:pawker/domain/entities/oauth_user_info.dart';
import 'package:pawker/domain/entities/user.dart';
import 'package:pawker/domain/repositories/user_repository.dart';

/// 회원가입 Use Case
///
/// 1. 유저 생성
/// 2. 생성 직후 유저 정보 조회하여 반환
class SignupUseCase {
  const SignupUseCase({required this.userRepository});

  final UserRepository userRepository;

  Future<User?> call({
    required OAuthUserInfo oauthUserInfo,
    required String nickname,
    required UserRole role,
    String? phoneNumber,
    bool marketingPushAgreed = false,
    bool marketingEmailAgreed = false,
    bool marketingSmsAgreed = false,
  }) async {
    await userRepository.createUser(
      oauthUserInfo,
      nickname,
      role,
      phoneNumber: phoneNumber,
      marketingPushAgreed: marketingPushAgreed,
      marketingEmailAgreed: marketingEmailAgreed,
      marketingSmsAgreed: marketingSmsAgreed,
    );
    return userRepository.getMe();
  }
}
