import 'package:pawker/data/models/apple_user_data_model.dart';
import 'package:pawker/data/services/auth_service.dart';
import 'package:pawker/domain/entities/user.dart';
import 'package:pawker/domain/repositories/auth_repository.dart';
import 'package:pawker/domain/repositories/oauth_repository.dart';
import 'package:pawker/domain/repositories/user_repository.dart';
import 'package:pawker/core/utils/app_logger.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthService _authService;
  final OAuthRepository _oauthRepository;
  final UserRepository _userRepository;

  AuthRepositoryImpl(
    this._authService,
    this._oauthRepository,
    this._userRepository,
  );

  @override
  Future<Map<String, dynamic>> login(String provider) async {
    try {
      final oauthUserInfo = await _oauthRepository.login(provider);
      logger.d("oauthUserInfo: ${oauthUserInfo.email}");
      if (oauthUserInfo.accessToken == null ||
          oauthUserInfo.accessToken!.isEmpty) {
        throw Exception('OAuth access token이 비어있습니다');
      }

      await _authService.loginAndStoreToken(
        oauthUserInfo.accessToken!,
        provider,
        provider == 'apple'
            ? AppleUserDataModel(
              appleId: oauthUserInfo.providerId,
              email: oauthUserInfo.email ?? '',
              name: oauthUserInfo.name ?? '',
            )
            : null,
      );

      // // 저장된 토큰 확인
      // final savedToken = await _authService.getAccessToken();

      // 토큰 저장 후 잠시 대기하여 AuthInterceptor가 새 토큰을 인식할 수 있도록 함
      await Future.delayed(const Duration(milliseconds: 100));

      User? user;
      try {
        user = await _userRepository.getMe();
      } catch (e) {
        // 401 에러는 토큰 문제이므로 토큰 재발급 시도
        if (e.toString().contains('401')) {
          // AuthInterceptor에서 자동으로 토큰 갱신을 처리하므로 여기서는 로그만 남김
          throw Exception('토큰 인증 실패: $e');
        } else {
          // 다른 에러는 사용자 정보 조회 실패로 처리하되 로그인은 성공
          user = null;
        }
      }

      return {'user': user, 'oauthUserInfo': oauthUserInfo};
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    // 1. OAuth 세션 삭제 (저장된 provider로 로그아웃)
    try {
      final provider = await _authService.getOAuthProvider();
      logger.d('로그아웃 시도 - provider: $provider');

      if (provider != null) {
        try {
          await _oauthRepository.logout(provider);
          logger.d('$provider OAuth 로그아웃 성공');
        } catch (e) {
          logger.e('$provider OAuth 로그아웃 실패 (무시): $e');
        }
      }
    } catch (e) {
      logger.e('OAuth 로그아웃 실패: $e');
    }

    // 2. 로컬 JWT 토큰 삭제
    await _authService.logout();
  }

  @override
  Future<bool> isLoggedIn() async {
    try {
      final result = await _authService.isLoggedIn();
      return result;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteAccount() async {
    try {
      // 1. 서버에서 계정 삭제
      await _userRepository.deleteMe();

      // 2. 로컬 토큰 삭제
      await _authService.logout();
    } catch (e) {
      rethrow;
    }
  }
}
