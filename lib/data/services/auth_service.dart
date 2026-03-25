import 'package:pawker/data/api/api_client.dart';
import 'package:pawker/data/models/apple_user_data_model.dart';
import 'package:pawker/data/models/jwt_token_response.dart';
import 'package:pawker/data/services/storage_service.dart';
import 'package:pawker/domain/exceptions/account_banned_exception.dart';
import 'package:dio/dio.dart';

class AuthService {
  final ApiClient _apiClient;
  final StorageService _storageService;
  AuthService(this._apiClient, this._storageService);

  Future<void> loginAndStoreToken(
    String accessToken,
    String provider,
    AppleUserDataModel? appleUserData,
  ) async {
    try {
      final jwtTokenResponse = await _apiClient.getJWTToken({
        'accessToken': accessToken,
        'provider': provider,
        'appleUserData': appleUserData,
      });

      if (jwtTokenResponse.accessToken.isEmpty) {
        throw Exception('JWT 토큰이 비어있습니다');
      }

      await _storeTokens(jwtTokenResponse);

      // 로그인 시 사용한 provider 저장
      await _storageService.write('oauth_provider', provider);

      // 저장된 토큰 확인
      // final savedToken = await getAccessToken();
    } on DioException catch (e) {
      // 403 에러 처리 (계정 차단)
      if (e.response?.statusCode == 403) {
        final responseData = e.response?.data;
        if (responseData is Map<String, dynamic>) {
          final error = responseData['error'] as String?;
          if (error == 'Account banned' || error == 'account_banned') {
            final banInfo = responseData['banInfo'] as Map<String, dynamic>?;
            final bannedAtStr = banInfo?['bannedAt'] as String?;
            final expiresAtStr = banInfo?['expiresAt'] as String?;
            
            throw AccountBannedException(
              message: responseData['message'] as String? ??
                  '계정이 차단되었습니다.',
              reason: banInfo?['reason'] as String?,
              bannedAt: bannedAtStr != null ? DateTime.parse(bannedAtStr) : null,
              expiresAt: expiresAtStr != null ? DateTime.parse(expiresAtStr) : null,
              isPermanent: banInfo?['isPermanent'] as bool? ?? false,
            );
          }
        }
        throw AccountBannedException(
          message: '계정이 차단되었습니다.',
        );
      }
      if (e.response?.statusCode == 401) {
        throw Exception('OAuth 토큰이 유효하지 않습니다. OAuth 로그인을 다시 시도해주세요.');
      }
      throw Exception('JWT 토큰 발급 실패: ${e.message}');
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _storeTokens(JwtTokenResponse tokenResponse) async {
    await _storageService.write('access_token', tokenResponse.accessToken);
    if (tokenResponse.refreshToken != null) {
      await _storageService.write('refresh_token', tokenResponse.refreshToken!);
    }
    await _storageService.write(
      'token_expires_at',
      (DateTime.now().millisecondsSinceEpoch + (tokenResponse.expiresIn * 1000))
          .toString(),
    );
  }

  Future<String?> getAccessToken() async {
    return await _storageService.read('access_token');
  }

  Future<String?> getRefreshToken() async {
    return await _storageService.read('refresh_token');
  }

  Future<DateTime?> getTokenExpiresAt() async {
    final expiresAtString = await _storageService.read('token_expires_at');
    if (expiresAtString != null) {
      final expiresAt = DateTime.fromMillisecondsSinceEpoch(
        int.parse(expiresAtString),
      );
      return expiresAt;
    }
    return null;
  }

  Future<bool> isTokenExpired() async {
    final expiresAt = await getTokenExpiresAt();
    if (expiresAt == null) {
      return true;
    }

    final now = DateTime.now();
    final shouldRefresh = now.isAfter(
      expiresAt.subtract(const Duration(minutes: 5)),
    );

    // 토큰 만료 5분 전에 갱신
    return shouldRefresh;
  }

  Future<bool> refreshTokenIfNeeded() async {
    if (!await isTokenExpired()) {
      return true; // 토큰이 유효함
    }

    final refreshToken = await getRefreshToken();
    if (refreshToken == null) {
      return false; // refresh token이 없음
    }

    try {
      final newTokenResponse = await _apiClient.refreshToken({
        'refresh_token': refreshToken,
      });

      // 새 토큰들 저장 (access token과 refresh token 모두)
      await _storeTokens(newTokenResponse);
      return true;
    } catch (e) {
      // refresh token도 만료된 경우
      await logout();
      return false;
    }
  }

  Future<void> logout() async {
    await _storageService.delete('access_token');
    await _storageService.delete('refresh_token');
    await _storageService.delete('token_expires_at');
    await _storageService.delete('oauth_provider');
  }

  Future<String?> getOAuthProvider() async {
    return await _storageService.read('oauth_provider');
  }

  Future<String?> getToken() async {
    // 토큰 갱신 시도
    final isTokenValid = await refreshTokenIfNeeded();
    if (!isTokenValid) {
      return null;
    }
    final accessToken = await getAccessToken();
    return accessToken;
  }

  Future<bool> isLoggedIn() async {
    final token = await getToken();
    final result = token != null;
    return result;
  }
}
