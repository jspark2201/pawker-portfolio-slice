import 'package:freezed_annotation/freezed_annotation.dart';

part 'blocked_user.freezed.dart';
part 'blocked_user.g.dart';

@freezed
abstract class BlockedUser with _$BlockedUser {
  const factory BlockedUser({
    required String id,
    required String blockedUserId,
    required String nickname,
    required String? profileImage,
    required DateTime createdAt,
  }) = _BlockedUser;

  factory BlockedUser.fromJson(Map<String, dynamic> json) =>
      _$BlockedUserFromJson(json);
}
