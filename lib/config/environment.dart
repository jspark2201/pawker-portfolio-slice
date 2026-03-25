// lib/config/environment.dart
import 'package:pawker/config/development.dart';
import 'package:pawker/config/production.dart';

enum Environment { development, production }

class AppConfig {
  static Environment _environment = Environment.development;
  static Environment get environment => _environment;

  static void setEnvironment(Environment env) {
    _environment = env;
  }

  static String get kakaoNativeAppKey {
    switch (_environment) {
      case Environment.development:
        return DevelopmentConfig.kakaoNativeAppKey;
      case Environment.production:
        return ProductionConfig.kakaoNativeAppKey;
    }
  }

  static String get kakaoRestApiKey {
    switch (_environment) {
      case Environment.development:
        return DevelopmentConfig.kakaoRestApiKey;
      case Environment.production:
        return ProductionConfig.kakaoRestApiKey;
    }
  }

  static String get naverClientId {
    switch (_environment) {
      case Environment.development:
        return DevelopmentConfig.naverClientId;
      case Environment.production:
        return ProductionConfig.naverClientId;
    }
  }

  static String get naverClientSecret {
    switch (_environment) {
      case Environment.development:
        return DevelopmentConfig.naverClientSecret;
      case Environment.production:
        return ProductionConfig.naverClientSecret;
    }
  }

  static String get naverClientName {
    switch (_environment) {
      case Environment.development:
        return DevelopmentConfig.naverClientName;
      case Environment.production:
        return ProductionConfig.naverClientName;
    }
  }

  static String get naverUrlScheme {
    switch (_environment) {
      case Environment.development:
        return DevelopmentConfig.naverUrlScheme;
      case Environment.production:
        return ProductionConfig.naverUrlScheme;
    }
  }

  static String get baseUrl {
    switch (_environment) {
      case Environment.development:
        return DevelopmentConfig.baseUrl;
      case Environment.production:
        return ProductionConfig.baseUrl;
    }
  }

  static String get naverMapClientId {
    switch (_environment) {
      case Environment.development:
        return DevelopmentConfig.naverMapClientId;
      case Environment.production:
        return ProductionConfig.naverMapClientId;
    }
  }

  /// SGIS API (통계청 통계지리정보서비스) Consumer Key
  static String get sgisConsumerKey {
    switch (_environment) {
      case Environment.development:
        return DevelopmentConfig.sgisConsumerKey;
      case Environment.production:
        return ProductionConfig.sgisConsumerKey;
    }
  }

  /// SGIS API (통계청 통계지리정보서비스) Consumer Secret
  static String get sgisConsumerSecret {
    switch (_environment) {
      case Environment.development:
        return DevelopmentConfig.sgisConsumerSecret;
      case Environment.production:
        return ProductionConfig.sgisConsumerSecret;
    }
  }

  static String get webSocketUrl {
    switch (_environment) {
      case Environment.development:
        return DevelopmentConfig.webSocketUrl;
      case Environment.production:
        return ProductionConfig.webSocketUrl;
    }
  }

  static String get weatherApiKey {
    switch (_environment) {
      case Environment.development:
        return DevelopmentConfig.weatherApiKey;
      case Environment.production:
        return ProductionConfig.weatherApiKey;
    }
  }

  static String get sentryDsn {
    switch (_environment) {
      case Environment.development:
        return DevelopmentConfig.sentryDsn;
      case Environment.production:
        return ProductionConfig.sentryDsn;
    }
  }
}
