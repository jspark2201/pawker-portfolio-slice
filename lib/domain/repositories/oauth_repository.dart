import 'package:pawker/domain/entities/oauth_user_info.dart';

abstract class OAuthRepository {
  Future<OAuthUserInfo> login(String provider);
  Future<void> logout(String provider);
  Future<void> revoke(String provider); // OAuth 연결 해제 (회원탈퇴)
}
