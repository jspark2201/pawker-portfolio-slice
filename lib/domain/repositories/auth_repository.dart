abstract class AuthRepository {
  Future<Map<String, dynamic>> login(String provider);
  Future<void> logout();
  Future<bool> isLoggedIn();
  Future<void> deleteAccount();
}
