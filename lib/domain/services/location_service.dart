/// 위치 권한 상태
enum LocationPermissionStatus {
  granted,
  denied,
  deniedForever,
  notDetermined,
}

/// 위치 정보 도메인 서비스 인터페이스
///
/// GPS 권한 요청 및 현재 위치 조회 동작을 추상화한다.
/// 구현체: [LocationPermissionService] (services/location/location_permission_service.dart)
abstract interface class LocationService {
  /// 현재 위치 권한 상태 확인
  Future<LocationPermissionStatus> checkPermission();

  /// 위치 권한 요청
  Future<LocationPermissionStatus> requestPermission();

  /// 앱 설정 열기 (권한이 영구 거부된 경우)
  Future<void> openAppSettings();
}
