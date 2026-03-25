import 'package:pawker/data/models/owner_job_api_model.dart';
import 'package:pawker/domain/entities/user.dart';

/// 견주 구인 글에 노출되는 강아지 요약 정보
class OwnerJobDog {
  final String id;
  final String dogNm;
  final String kindNm;
  final String? profileImage;

  const OwnerJobDog({
    required this.id,
    required this.dogNm,
    required this.kindNm,
    this.profileImage,
  });
}

class OwnerJob {
  final String id;
  final User owner;
  final String title;
  final String description;
  final List<String> availableLocations;
  final String availableTime;
  final int? preferredHourlyRate;
  final List<OwnerJobDog> dogs;
  final DateTime createdAt;

  const OwnerJob({
    required this.id,
    required this.owner,
    required this.title,
    required this.description,
    required this.availableLocations,
    required this.availableTime,
    this.preferredHourlyRate,
    required this.dogs,
    required this.createdAt,
  });
}

class OwnerJobMapper {
  static OwnerJob toDomain(OwnerJobApiModel apiModel) {
    return OwnerJob(
      id: apiModel.jobId,
      owner: UserMapper.toDomain(apiModel.owner),
      title: apiModel.title,
      description: apiModel.description,
      availableLocations: apiModel.availableLocations,
      availableTime: apiModel.availableTime,
      preferredHourlyRate: apiModel.preferredHourlyRate,
      dogs: apiModel.dogs
          .map(
            (d) => OwnerJobDog(
              id: d.id,
              dogNm: d.dogNm,
              kindNm: d.kindNm,
              profileImage: d.profileImage,
            ),
          )
          .toList(),
      createdAt: DateTime.parse(apiModel.createdAt),
    );
  }
}
