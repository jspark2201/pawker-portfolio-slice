import 'package:pawker/data/models/walker_job_api_model.dart';
import 'package:pawker/domain/entities/user.dart';

class WalkerJob {
  final String id;
  final User walker;
  final String title;
  final String description;
  final List<String> availableLocations;
  final String availableTime;
  final int pricePerHour;
  final List<String> certificates;
  final DateTime createdAt;
  final bool? hasPetCareExperience;
  final String? walkerGender;
  final String? walkerAgeGroup;

  const WalkerJob({
    required this.id,
    required this.walker,
    required this.title,
    required this.description,
    required this.availableLocations,
    required this.availableTime,
    required this.pricePerHour,
    required this.certificates,
    required this.createdAt,
    required this.hasPetCareExperience,
    required this.walkerGender,
    required this.walkerAgeGroup,
  });
}

class WalkerJobMapper {
  static WalkerJob toDomain(WalkerJobApiModel apiModel) {
    return WalkerJob(
      id: apiModel.jobId,
      walker: UserMapper.toDomain(apiModel.walker),
      title: apiModel.title,
      description: apiModel.description,
      availableLocations: apiModel.availableLocations,
      availableTime: apiModel.availableTime,
      pricePerHour: apiModel.pricePerHour,
      certificates: apiModel.certificates,
      createdAt: DateTime.parse(apiModel.createdAt),
      hasPetCareExperience: apiModel.hasPetCareExperience,
      walkerGender: apiModel.walkerGender,
      walkerAgeGroup: apiModel.walkerAgeGroup,
    );
  }
}
