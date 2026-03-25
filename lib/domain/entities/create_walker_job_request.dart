import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pawker/data/models/walker_job/create_walker_job_request_api_model.dart';

part 'create_walker_job_request.freezed.dart';

@freezed
abstract class CreateWalkerJobRequest with _$CreateWalkerJobRequest {
  const factory CreateWalkerJobRequest({
    required String title,
    required String description,
    required List<String> availableRegionCodes, // 최하위 레벨 지역 코드들
    required String availableTime,
    required int hourlyRate,
    required List<String> certificates,
    required bool? hasPetCareExperience,
    required String? walkerGender,
    required String? walkerAgeGroup,
  }) = _CreateWalkerJobRequest;

  const CreateWalkerJobRequest._();

  /// Domain 모델을 API 모델로 변환
  CreateWalkerJobRequestApiModel toApiModel() {
    return CreateWalkerJobRequestApiModel(
      title: title,
      description: description,
      availableRegionCodes: availableRegionCodes,
      availableTime: availableTime,
      hourlyRate: hourlyRate,
      certificates: certificates,
      hasPetCareExperience: hasPetCareExperience,
      walkerGender: walkerGender,
      walkerAgeGroup: walkerAgeGroup,
    );
  }
}
