import 'package:pawker/domain/entities/walk_schedule.dart';

abstract class WalkScheduleRepository {
  // ==================== 스케줄 인스턴스 (Schedule Instances) ====================

  /// 워커의 스케줄 인스턴스 목록 조회
  Future<List<WalkSchedule>> getSchedules({
    int? limit,
    int? offset,
    DateTime? date,
    String? status,
  });

  /// 특정 스케줄 인스턴스 조회
  Future<WalkSchedule> getSchedule(String id);

  /// 스케줄 인스턴스 생성 (단일 스케줄)
  Future<WalkSchedule> createSchedule({
    required String walkRequestId,
    required DateTime scheduledDate,
    required String scheduledTime,
    required int durationMinutes,
    String? notes,
  });

  /// 스케줄 인스턴스 업데이트
  Future<WalkSchedule> updateSchedule({
    required String id,
    DateTime? scheduledDate,
    String? scheduledTime,
    int? durationMinutes,
    String? status,
    String? notes,
  });

  /// 스케줄 인스턴스 삭제
  Future<void> deleteSchedule(String id);

  /// 스케줄 인스턴스 상태 업데이트
  Future<WalkSchedule> updateScheduleStatus({
    required String id,
    required String status,
  });
}
