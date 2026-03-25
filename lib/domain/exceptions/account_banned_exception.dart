class AccountBannedException implements Exception {
  final String message;
  final String? reason;
  final DateTime? bannedAt;
  final DateTime? expiresAt;
  final bool isPermanent;

  AccountBannedException({
    required this.message,
    this.reason,
    this.bannedAt,
    this.expiresAt,
    this.isPermanent = false,
  });

  @override
  String toString() => message;
}
