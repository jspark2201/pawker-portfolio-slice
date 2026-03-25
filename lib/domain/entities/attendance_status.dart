/// 이번 주 하루 (요일·날짜 표시용)
class AttendanceWeekDay {
  const AttendanceWeekDay({
    required this.dayOfWeek,
    required this.date,
    required this.monthDay,
  });

  final String dayOfWeek;
  final String date;
  final String monthDay;
}

/// 오늘 출석/보너스 수령 상태 + 이번 주 출석 현황
class AttendanceStatus {
  const AttendanceStatus({
    required this.hasClaimed,
    required this.hasClaimedBonus,
    required this.canClaimBonus,
    required this.thisWeekCheckedDates,
    required this.thisWeekDays,
  });

  final bool hasClaimed;
  final bool hasClaimedBonus;
  final bool canClaimBonus;
  /// 이번 주(KST) 출석한 날짜 YYYY-MM-DD 목록
  final List<String> thisWeekCheckedDates;
  /// 이번 주 7일 (월~일). 요일·날짜 표시용
  final List<AttendanceWeekDay> thisWeekDays;
}
