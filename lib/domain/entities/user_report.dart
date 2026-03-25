import 'package:pawker/domain/entities/report_reason.dart';

/// 사용자 신고 정보
class UserReport {
  final String id;
  final String reporterId;
  final String reportedId;
  final ReportReason reason;
  final String? description;
  final DateTime createdAt;
  final bool isDuplicate;
  final String message;

  UserReport({
    required this.id,
    required this.reporterId,
    required this.reportedId,
    required this.reason,
    this.description,
    required this.createdAt,
    required this.isDuplicate,
    required this.message,
  });
}

/// 사용자 신고 요청
class CreateUserReportRequest {
  final ReportReason reason;
  final String? description; // 기타 사유일 경우 필수

  CreateUserReportRequest({
    required this.reason,
    this.description,
  });

  /// 유효성 검사
  bool get isValid {
    if (reason == ReportReason.other) {
      return description != null && description!.trim().isNotEmpty;
    }
    return true;
  }
}

