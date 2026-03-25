import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pawker/data/models/dog/animal_registration_request_api_model.dart';

part 'animal_registration_request.freezed.dart';

@freezed
abstract class AnimalRegistrationRequest
    with _$AnimalRegistrationRequest {
  const factory AnimalRegistrationRequest({
    required String dogRegNo,
    required String ownerName,
  }) = _AnimalRegistrationRequest;

  const AnimalRegistrationRequest._();

  AnimalRegistrationRequestApiModel toApiModel() {
    return AnimalRegistrationRequestApiModel(
      dogRegNo: dogRegNo,
      ownerName: ownerName,
    );
  }
}

