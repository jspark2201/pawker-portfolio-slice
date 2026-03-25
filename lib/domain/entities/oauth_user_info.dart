class OAuthUserInfo {
  final String provider;
  final String providerId;
  final String? email;
  final String? name;
  final String? phoneNumber;
  final String? accessToken;

  OAuthUserInfo({
    required this.provider,
    required this.providerId,
    this.email,
    this.name,
    this.phoneNumber,
    this.accessToken,
  });
}
