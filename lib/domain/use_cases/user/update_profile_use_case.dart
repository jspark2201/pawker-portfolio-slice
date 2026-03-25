import 'package:pawker/domain/entities/user.dart';
import 'package:pawker/domain/repositories/user_repository.dart';

/// 프로필 업데이트 Use Case
class UpdateProfileUseCase {
  const UpdateProfileUseCase({required this.userRepository});

  final UserRepository userRepository;

  Future<User?> call({
    String? nickname,
    String? phoneNumber,
    String? profileImage,
    bool? marketingPushAgreed,
    bool? marketingEmailAgreed,
    bool? marketingSmsAgreed,
  }) {
    return userRepository.updateMe(
      nickname: nickname,
      phoneNumber: phoneNumber,
      profileImage: profileImage,
      marketingPushAgreed: marketingPushAgreed,
      marketingEmailAgreed: marketingEmailAgreed,
      marketingSmsAgreed: marketingSmsAgreed,
    );
  }
}
