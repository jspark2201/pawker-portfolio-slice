import 'package:pawker/domain/entities/create_walker_job_request.dart';
import 'package:pawker/domain/entities/walker_job.dart';

abstract class WalkerJobRepository {
  Future<WalkerJob> getWalkerJob(String walkerId);
  Future<WalkerJob> createWalkerJob(CreateWalkerJobRequest request);
  Future<WalkerJob> updateWalkerJob(
    String jobId,
    CreateWalkerJobRequest request,
  );
  Future<void> deleteWalkerJob(String jobId);
  Future<List<WalkerJob>> getPublicWalkerJobs({
    String? keyword,
    String? regionCode,
    String? availableTime,
    int? minHourlyRate,
    int? maxHourlyRate,
    int? limit,
    int? offset,
  });
}
