import 'app_config.dart';

/// Convenient shorthand for the most commonly used URLs.
///
/// All values are derived from [AppConfig.environment], so switching the
/// environment once updates every getter here automatically.
///
/// ```dart
/// final response = await dio.get('${UrlService.baseUrl}/api/users');
/// ```
class UrlService {
  UrlService._();

  // ────────────────────── API ────────────────────────────────────

  /// REST API base URL.
  static String get baseUrl => AppConfig.baseUrl;

  // ────────────────────── Socket ─────────────────────────────────

  /// WebSocket URL.
  static String get socketUrl => AppConfig.socketUrl;

  // ────────────────────── Patient Chat ───────────────────────────

  /// Patient Chat API base URL.
  static String get patientChatBaseUrl => AppConfig.patientChatBaseUrl;

  // ────────────────────── Others ─────────────────────────────────

  /// Crypto secret key.
  static String get viteCryptoSecretKey => AppConfig.viteCryptoSecretKey;

  /// Google Maps API key.
  static String get googleMapApiKey => AppConfig.googleMapApiKey;

  /// Cloud Storage image base URL.
  static String get imageUrl => AppConfig.imageUrl;

  /// Sentry DSN.
  static String get sentryUrl => AppConfig.sentryUrl;
}
