import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pawker/data/models/walk_record_list_api_model.dart';
import 'package:pawker/domain/entities/walk_record.dart';

part 'walk_record_list.freezed.dart';
part 'walk_record_list.g.dart';

@freezed
abstract class WalkRecordList with _$WalkRecordList {
  const factory WalkRecordList({
    required List<WalkRecord> walkRecords,
    required int totalCount,
    required int limit,
    required int offset,
    required bool hasMore,
  }) = _WalkRecordList;

  factory WalkRecordList.fromJson(Map<String, dynamic> json) =>
      _$WalkRecordListFromJson(json);
}

class WalkRecordListMapper {
  static WalkRecordList toDomain(WalkRecordListApiModel apiModel) {
    return WalkRecordList(
      walkRecords:
          apiModel.records.map((e) => WalkRecordMapper.toDomain(e)).toList(),
      totalCount: apiModel.total,
      limit: apiModel.limit,
      offset: apiModel.offset,
      hasMore: apiModel.hasMore,
    );
  }
}
