import 'package:pawker/domain/entities/create_walk_record.dart';
import 'package:pawker/domain/entities/walk_record.dart';
import 'package:pawker/domain/repositories/walk_record_repository.dart';

/// 산책 기록 저장 Use Case
///
/// 산책이 끝난 뒤 경로/거리/시간을 기록으로 저장한다.
class SaveWalkRecordUseCase {
  const SaveWalkRecordUseCase({required this.walkRecordRepository});

  final WalkRecordRepository walkRecordRepository;

  Future<WalkRecord> call(CreateWalkRecord walkRecord) {
    return walkRecordRepository.createWalkRecord(walkRecord);
  }
}
