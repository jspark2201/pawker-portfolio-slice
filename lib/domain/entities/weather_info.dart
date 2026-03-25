import 'package:freezed_annotation/freezed_annotation.dart';

part 'weather_info.freezed.dart';
part 'weather_info.g.dart';

/// 날씨 정보 모델
@freezed
abstract class WeatherInfo with _$WeatherInfo {
  const factory WeatherInfo({
    required double temperature, // 온도 (섭씨)
    required String description, // 날씨 설명 (맑음, 흐림 등)
    required String icon, // 날씨 아이콘 코드
    required int humidity, // 습도 (%)
    required double windSpeed, // 풍속 (m/s)
    required int uvIndex, // 자외선 지수 (0-11+)
    required int pm10, // 미세먼지 (㎍/㎥)
    required int pm25, // 초미세먼지 (㎍/㎥)
    required DateTime timestamp, // 정보 생성 시간
  }) = _WeatherInfo;

  factory WeatherInfo.fromJson(Map<String, dynamic> json) =>
      _$WeatherInfoFromJson(json);
}

extension WeatherInfoExtension on WeatherInfo {
  /// 산책하기 좋은 날씨인지 판단
  bool get isGoodForWalking {
    // 온도: 10~28도 사이
    final tempOk = temperature >= 10 && temperature <= 28;
    // 미세먼지: 50 이하 (좋음 단계)
    final pm10Ok = pm10 <= 50;
    // 초미세먼지: 25 이하 (좋음 단계)
    final pm25Ok = pm25 <= 25;
    // 풍속: 10m/s 이하 (강풍 아님)
    final windOk = windSpeed <= 10;

    return tempOk && pm10Ok && pm25Ok && windOk;
  }

  /// 날씨 상태에 따른 이모지 반환
  String get emoji {
    if (description.contains('맑음') || description.contains('Clear')) {
      return '☀️';
    } else if (description.contains('구름') || description.contains('Cloud')) {
      return '☁️';
    } else if (description.contains('비') || description.contains('Rain')) {
      return '🌧️';
    } else if (description.contains('눈') || description.contains('Snow')) {
      return '❄️';
    } else if (description.contains('안개') || description.contains('Mist')) {
      return '🌫️';
    }
    return '🌤️';
  }

  /// 미세먼지 등급
  String get pm10Grade {
    if (pm10 <= 30) return '좋음';
    if (pm10 <= 80) return '보통';
    if (pm10 <= 150) return '나쁨';
    return '매우나쁨';
  }

  /// 초미세먼지 등급
  String get pm25Grade {
    if (pm25 <= 15) return '좋음';
    if (pm25 <= 35) return '보통';
    if (pm25 <= 75) return '나쁨';
    return '매우나쁨';
  }

  /// 자외선 지수 등급
  String get uvGrade {
    if (uvIndex <= 2) return '낮음';
    if (uvIndex <= 5) return '보통';
    if (uvIndex <= 7) return '높음';
    if (uvIndex <= 10) return '매우높음';
    return '위험';
  }

  /// 산책 추천 메시지
  String get walkRecommendation {
    if (isGoodForWalking) {
      return '산책하기 좋은 날씨예요! 🐕';
    } else if (pm10 > 80 || pm25 > 35) {
      return '미세먼지가 나쁘니 실내 활동을 권장해요 🏠';
    } else if (temperature < 10) {
      return '날씨가 쌀쌀하니 따뜻하게 입으세요 🧥';
    } else if (temperature > 28) {
      return '더운 날씨니 수분 섭취를 충분히 하세요 💧';
    } else if (windSpeed > 10) {
      return '바람이 강하니 주의하세요 💨';
    }
    return '산책 준비 완료! 출발해볼까요? 🚶';
  }
}
