import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pawker/data/models/walk_schedule/walk_schedule_api_model.dart';
import 'package:pawker/domain/entities/dog.dart';
import 'package:pawker/domain/entities/user.dart';

part 'walk_schedule.freezed.dart';
part 'walk_schedule.g.dart';

/// 스케줄 상태
enum WalkScheduleStatus {
  scheduled, // 예약됨
  inProgress, // 진행중
  completed, // 완료
  cancelled, // 취소됨
}

/// 실제 스케줄 인스턴스 (구체적인 날짜의 스케줄)
@freezed
abstract class WalkSchedule with _$WalkSchedule {
  const factory WalkSchedule({
    required String id,
    String? templateId, // NULL이면 단일 스케줄
    required String walkRequestId, // FK → walk_requests
    required DateTime scheduledDate,
    required String scheduledTime, // "09:00:00"
    required int durationMinutes,
    String? notes,

    // 성능 최적화를 위한 중복 저장 (조인 없이 조회 가능)
    required String walkerId,
    required String dogId,
    required String ownerId,

    // 조회 시 포함되는 관계 데이터
    Dog? dog,
    User? owner,

    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _WalkSchedule;

  factory WalkSchedule.fromJson(Map<String, dynamic> json) =>
      _$WalkScheduleFromJson(json);
}

class WalkScheduleMapper {
  static WalkSchedule toDomain(WalkScheduleApiModel apiModel) {
    return WalkSchedule(
      id: apiModel.id,
      walkRequestId: apiModel.walkRequestId,
      scheduledDate: DateTime.parse(apiModel.scheduledDate),
      scheduledTime: apiModel.scheduledTime,
      durationMinutes: apiModel.durationMinutes,
      walkerId: apiModel.owner.id,
      dogId: apiModel.dog.id,
      ownerId: apiModel.owner.id,
      dog: DogMapper.toDomain(apiModel.dog),
      owner: UserMapper.toDomain(apiModel.owner),
      createdAt: DateTime.parse(apiModel.createdAt ?? ''),
      updatedAt: DateTime.parse(apiModel.updatedAt ?? ''),
      notes: apiModel.notes,
    );
  }
}
