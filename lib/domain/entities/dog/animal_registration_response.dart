import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pawker/data/models/dog/animal_registration_response_api_model.dart';

part 'animal_registration_response.freezed.dart';

@freezed
abstract class AnimalRegistrationResponse
    with _$AnimalRegistrationResponse {
  const factory AnimalRegistrationResponse({
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
  }) = _AnimalRegistrationResponse;

  const AnimalRegistrationResponse._();

  factory AnimalRegistrationResponse.fromApiModel(
    AnimalRegistrationResponseApiModel apiModel,
  ) {
    return AnimalRegistrationResponse(
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
    );
  }
}

