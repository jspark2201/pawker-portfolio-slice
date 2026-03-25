/// 신고 사유
enum ReportReason {
  inappropriateLanguage, // 부적절한 언어 사용
  spamAdvertisement, // 스팸/광고
  sexualHarassment, // 성희롱
  other, // 기타
}

extension ReportReasonExtension on ReportReason {
  /// API에서 사용하는 문자열 값
  String get value {
    switch (this) {
      case ReportReason.inappropriateLanguage:
        return 'inappropriate_language';
      case ReportReason.spamAdvertisement:
        return 'spam_advertisement';
      case ReportReason.sexualHarassment:
        return 'sexual_harassment';
      case ReportReason.other:
        return 'other';
    }
  }

  /// 사용자에게 보여줄 한국어 텍스트
  String get displayText {
    switch (this) {
      case ReportReason.inappropriateLanguage:
        return '부적절한 언어 사용';
      case ReportReason.spamAdvertisement:
        return '스팸/광고';
      case ReportReason.sexualHarassment:
        return '성희롱';
      case ReportReason.other:
        return '기타';
    }
  }

  /// 문자열에서 ReportReason로 변환
  static ReportReason fromString(String value) {
    switch (value) {
      case 'inappropriate_language':
        return ReportReason.inappropriateLanguage;
      case 'spam_advertisement':
        return ReportReason.spamAdvertisement;
      case 'sexual_harassment':
        return ReportReason.sexualHarassment;
      case 'other':
        return ReportReason.other;
      default:
        return ReportReason.other;
    }
  }
}

