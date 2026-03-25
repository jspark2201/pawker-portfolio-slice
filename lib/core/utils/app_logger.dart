import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

/// 앱 전역 Logger 서비스
///
/// 개발 중에는 모든 로그를 출력하고,
/// 프로덕션에서는 경고와 에러만 출력합니다.
class AppLogger {
  static final AppLogger _instance = AppLogger._internal();
  factory AppLogger() => _instance;
  AppLogger._internal();

  late final Logger _logger;

  /// Logger 초기화
  void init() {
    _logger = Logger(
      level: kReleaseMode ? Level.warning : Level.debug,
      printer: PrettyPrinter(
        methodCount: 0, // 스택 트레이스 표시 안함
        errorMethodCount: 5, // 에러 시에만 스택 트레이스 5줄
        lineLength: 120,
        colors: true,
        printEmojis: true,
        printTime: false,
      ),
    );
  }

  /// Debug 로그 (개발용)
  void d(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.d(message, error: error, stackTrace: stackTrace);
  }

  /// Info 로그
  void i(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.i(message, error: error, stackTrace: stackTrace);
  }

  /// Warning 로그
  void w(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.w(message, error: error, stackTrace: stackTrace);
  }

  /// Error 로그
  void e(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }

  /// 민감한 데이터를 마스킹하는 메서드
  static String maskSensitiveData(String data) {
    // 이메일 마스킹
    data = data.replaceAllMapped(
      RegExp(r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b'),
      (match) => '***@***.***',
    );

    // 전화번호 마스킹 (010-1234-5678 형태)
    data = data.replaceAllMapped(
      RegExp(r'\b\d{3}-\d{4}-\d{4}\b'),
      (match) => '***-****-****',
    );

    // 전화번호 마스킹 (01012345678 형태)
    data = data.replaceAllMapped(
      RegExp(r'\b\d{11}\b'),
      (match) => '***********',
    );

    // Bearer 토큰 마스킹
    data = data.replaceAllMapped(
      RegExp(r'Bearer [A-Za-z0-9\-._~+/]+=*'),
      (match) => 'Bearer ***MASKED***',
    );

    return data;
  }
}

/// 전역 logger 인스턴스
final logger = AppLogger();
