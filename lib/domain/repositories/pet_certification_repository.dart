import 'package:pawker/domain/entities/pet_certification.dart';

abstract class PetCertificationRepository {
  Future<List<PetCertification>> getPetCertifications();
}
