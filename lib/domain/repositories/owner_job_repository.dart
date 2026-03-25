import 'package:pawker/domain/entities/create_owner_job_request.dart';
import 'package:pawker/domain/entities/owner_job.dart';

abstract class OwnerJobRepository {
  Future<List<OwnerJob>> getOwnerJobsByOwnerId(
    String ownerId, {
    int? limit,
    int? offset,
  });
  Future<OwnerJob> getOwnerJobById(String jobId);
  Future<OwnerJob> createOwnerJob(CreateOwnerJobRequest request);
  Future<OwnerJob> updateOwnerJob(String jobId, CreateOwnerJobRequest request);
  Future<void> deleteOwnerJob(String jobId);
  Future<List<OwnerJob>> getOwnerJobs({
    String? keyword,
    String? regionCode,
    String? availableTime,
    int? minHourlyRate,
    int? maxHourlyRate,
    int? limit,
    int? offset,
  });
}
