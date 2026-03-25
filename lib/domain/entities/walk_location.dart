import 'package:freezed_annotation/freezed_annotation.dart';

part 'walk_location.freezed.dart';
part 'walk_location.g.dart';

/// 실시간 산책 위치 데이터
@freezed
abstract class WalkLocation with _$WalkLocation {
  const factory WalkLocation({
    required double latitude,
    required double longitude,
    required DateTime timestamp,
    double? accuracy,
    double? altitude,
    double? speed,
    double? heading,
  }) = _WalkLocation;

  factory WalkLocation.fromJson(Map<String, dynamic> json) =>
      _$WalkLocationFromJson(json);
}
