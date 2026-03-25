class SgisAuthResponse {
  final String accessToken;
  final int? errCd;
  final String? errMsg;

  const SgisAuthResponse({required this.accessToken, this.errCd, this.errMsg});

  factory SgisAuthResponse.fromJson(Map<String, dynamic> json) {
    return SgisAuthResponse(
      accessToken: json['result']?['accessToken'] ?? '',
      errCd: json['errCd'] as int?,
      errMsg: json['errMsg'] as String?,
    );
  }

  bool get isSuccess => errCd == 0;
  bool get isTokenExpired => errCd == -401;
}
