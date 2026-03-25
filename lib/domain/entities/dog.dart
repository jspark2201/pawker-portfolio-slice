import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pawker/data/models/dog/dog_api_model.dart';

part 'dog.freezed.dart';
part 'dog.g.dart';

@freezed
abstract class Dog with _$Dog {
  const factory Dog({
    required String id,
    required String userId,
    required String dogRegNo,
    required String rfidCd,
    required String rfidGubun,
    required String dogNm,
    required String birthDt,
    required String sexNm,
    required String kindNm,
    required String neuterYn,
    required String orgNm,
    required String aprGbNm,
    required String regTm,
    required String aprTm,
    String? profileImage,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Dog;

  factory Dog.fromJson(Map<String, dynamic> json) => _$DogFromJson(json);
}

extension DogExtension on Dog {
  /// 생년월일(birthDt)로부터 나이를 계산합니다.
  /// birthDt 형식: "YYYYMMDD" 또는 "YYYY-MM-DD"
  int? get age {
    if (birthDt.isEmpty) return null;

    try {
      // "YYYYMMDD" 형식 파싱
      String dateStr = birthDt.replaceAll('-', '').replaceAll('/', '');
      if (dateStr.length < 8) return null;

      final year = int.parse(dateStr.substring(0, 4));
      final month = int.parse(dateStr.substring(4, 6));
      final day = int.parse(dateStr.substring(6, 8));

      final birthDate = DateTime(year, month, day);
      final now = DateTime.now();

      int age = now.year - birthDate.year;

      // 생일이 아직 지나지 않았으면 1살 빼기
      if (now.month < birthDate.month ||
          (now.month == birthDate.month && now.day < birthDate.day)) {
        age--;
      }

      return age >= 0 ? age : null;
    } catch (e) {
      return null;
    }
  }

  /// 나이를 문자열로 반환합니다 (예: "3세", "5세")
  String get ageString {
    final calculatedAge = age;
    if (calculatedAge == null) return '알 수 없음';
    return '$calculatedAge세';
  }
}

class DogMapper {
  static Dog toDomain(DogApiModel apiModel) {
    return Dog(
      id: apiModel.id,
      userId: apiModel.userId,
      dogRegNo: apiModel.dogRegNo,
      rfidCd: apiModel.rfidCd,
      rfidGubun: apiModel.rfidGubun,
      dogNm: apiModel.dogNm,
      birthDt: apiModel.birthDt,
      sexNm: apiModel.sexNm,
      kindNm: apiModel.kindNm,
      neuterYn: apiModel.neuterYn,
      orgNm: apiModel.orgNm,
      aprGbNm: apiModel.aprGbNm,
      regTm: apiModel.regTm,
      aprTm: apiModel.aprTm,
      profileImage: apiModel.profileImage,
      createdAt: DateTime.parse(apiModel.createdAt),
      updatedAt: DateTime.parse(apiModel.updatedAt),
    );
  }

  static List<Dog> toDomainList(List<DogApiModel> apiModels) {
    return apiModels.map((model) => toDomain(model)).toList();
  }

  static DogApiModel toApiModel(Dog dog) {
    return DogApiModel(
      id: dog.id,
      userId: dog.userId,
      dogRegNo: dog.dogRegNo,
      rfidCd: dog.rfidCd,
      rfidGubun: dog.rfidGubun,
      dogNm: dog.dogNm,
      birthDt: dog.birthDt,
      sexNm: dog.sexNm,
      kindNm: dog.kindNm,
      neuterYn: dog.neuterYn,
      orgNm: dog.orgNm,
      aprGbNm: dog.aprGbNm,
      regTm: dog.regTm,
      aprTm: dog.aprTm,
      profileImage: dog.profileImage,
      createdAt: dog.createdAt.toIso8601String(),
      updatedAt: dog.updatedAt.toIso8601String(),
    );
  }
}
