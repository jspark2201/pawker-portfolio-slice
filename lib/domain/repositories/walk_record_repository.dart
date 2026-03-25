import 'package:pawker/domain/entities/walk_record.dart';
import 'package:pawker/domain/entities/create_walk_record.dart';
import 'package:pawker/domain/entities/walk_record_list.dart';

abstract class WalkRecordRepository {
  /// 산책 기록 생성
  Future<WalkRecord> createWalkRecord(CreateWalkRecord walkRecord);

  /// 산책 기록 목록 조회 (페이지네이션)
  /// [limit] 한 번에 가져올 항목 수
  /// [offset] 건너뛸 항목 수
  /// [ownerWalk] true: 본인이 산책한 것만, false: 워커가 산책한 것만, null: 전체
  Future<WalkRecordList> getWalkRecords({
    int limit = 20,
    int offset = 0,
    bool? ownerWalk,
  });

  /// 산책 기록 상세 조회
  Future<WalkRecord> getWalkRecord(String id);
}
