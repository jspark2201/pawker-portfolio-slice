import 'package:pawker/domain/entities/dog.dart';
import 'package:pawker/domain/entities/dog/animal_registration_request.dart';
import 'package:pawker/domain/entities/dog/animal_registration_response.dart';

/// 강아지 관련 저장소 인터페이스
///
/// 이 인터페이스는 강아지와 관련된 모든 데이터 작업을 정의합니다.
/// 실제 구현은 데이터 계층에서 이루어집니다.
abstract class DogRepository {
  /// 현재 사용자의 모든 강아지 목록을 가져옵니다.
  Future<List<Dog>> getMyDogs();

  /// 새로운 강아지를 등록합니다.
  Future<Dog> createDog(Dog dog);

  /// 강아지 정보를 업데이트합니다.
  Future<Dog> updateDog(Dog dog);

  /// 강아지를 삭제합니다.
  Future<void> deleteDog(String dogId);

  /// 강아지 정보를 조회합니다.
  Future<Dog?> findDogById(String dogId);

  /// 공공데이터로부터 강아지 등록 정보를 확인합니다.
  Future<AnimalRegistrationResponse> verifyDogRegistration(
    AnimalRegistrationRequest request,
  );
}
