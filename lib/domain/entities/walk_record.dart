import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pawker/data/models/create_walk_record_api_model.dart';
import 'package:pawker/data/models/walk_record_api_model.dart';
import 'package:pawker/domain/entities/dog.dart';
import 'package:pawker/domain/entities/user.dart';

part 'walk_record.freezed.dart';
part 'walk_record.g.dart';

@freezed
abstract class WalkRecord with _$WalkRecord {
  const factory WalkRecord({
    required String id,
    required DateTime date,
    required Dog dog,
    required Duration duration,
    required double distance,
    required int rating,
    required String location,
    required String? notes,
    required List<GpsCoordinate> path,
    required User? walker,
    required User owner,
    required bool isSelfWalk,
  }) = _WalkRecord;

  factory WalkRecord.fromJson(Map<String, dynamic> json) =>
      _$WalkRecordFromJson(json);
}

class WalkRecordMapper {
  static WalkRecord toDomain(WalkRecordApiModel apiModel) {
    final owner = UserMapper.toDomain(apiModel.owner);
    final walker =
        apiModel.walker != null ? UserMapper.toDomain(apiModel.walker!) : null;

    return WalkRecord(
      id: apiModel.id,
      date: apiModel.date,
      dog: DogMapper.toDomain(apiModel.dog),
      duration: Duration(seconds: apiModel.durationSeconds),
      distance: apiModel.distance,
      rating: apiModel.rating ?? 0,
      location: apiModel.location,
      notes: apiModel.notes,
      path: apiModel.path,
      walker: walker,
      owner: owner,
      isSelfWalk: walker != null && walker.id == owner.id,
    );
  }
}
