import 'package:pawker/domain/entities/oauth_user_info.dart';
import 'package:pawker/domain/entities/user.dart';
import 'package:pawker/domain/entities/walk_review.dart';
import 'package:pawker/domain/entities/user_report.dart';
import 'package:pawker/data/models/user/ban_status_response_api_model.dart';

abstract class UserRepository {
  Future<void> createUser(
    OAuthUserInfo oauthUserInfo,
    String nickname,
    UserRole role, {
    String? phoneNumber,
    bool marketingPushAgreed = false,
    bool marketingEmailAgreed = false,
    bool marketingSmsAgreed = false,
  });
  Future<User?> findUserById(String id);
  Future<User?> getMe();
  Future<void> deleteMe();
  Future<User?> updateMe({
    String? nickname,
    String? phoneNumber,
    String? profileImage,
    bool? marketingPushAgreed,
    bool? marketingEmailAgreed,
    bool? marketingSmsAgreed,
  });
  Future<UserReviews> getUserReviews(String userId, {int? limit, int? offset});
  Future<ReviewStats> getUserReviewStats(String userId);
  Future<int> getUserTotalWalkCount(String userId);
  Future<UserReport> reportUser(String userId, CreateUserReportRequest request);
  Future<BanStatusResponseApiModel> getBanStatus();
}
