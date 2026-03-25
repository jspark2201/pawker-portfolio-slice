import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pawker/data/models/owner_job/create_owner_job_request_api_model.dart';

part 'create_owner_job_request.freezed.dart';

@freezed
abstract class CreateOwnerJobRequest with _$CreateOwnerJobRequest {
  const factory CreateOwnerJobRequest({
    required String title,
    required String description,
    required List<String> availableRegionCodes,
    required String availableTime,
    int? preferredHourlyRate,
    required List<String> dogIds,
  }) = _CreateOwnerJobRequest;

  const CreateOwnerJobRequest._();

  CreateOwnerJobRequestApiModel toApiModel() {
    return CreateOwnerJobRequestApiModel(
      title: title,
      description: description,
      availableRegionCodes: availableRegionCodes,
      availableTime: availableTime,
      preferredHourlyRate: preferredHourlyRate,
      dogIds: dogIds,
    );
  }
}
