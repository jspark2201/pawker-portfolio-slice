import 'package:pawker/domain/entities/attendance_status.dart';

abstract class AttendanceRepository {
  /// 오늘 출석/보너스 수령 여부 조회
  Future<AttendanceStatus> getStatus();

  /// 출석 체크 (지급). 성공 시 지급된 포인트 반환.
  Future<int> claim();

  /// 출석 광고 보너스 (랜덤 추가 지급). 광고 시청 완료 후 호출.
  Future<int> claimBonus();
}
