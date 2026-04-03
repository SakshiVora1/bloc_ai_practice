import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'environment.dart';

/// Central application configuration.
///
/// Set [environment] once (e.g. in `main()`) and every URL accessor
/// automatically resolves to the right value — no manual changes needed.
///
/// ```dart
/// await AppConfig.init(env: Environment.dev);
/// ```
class AppConfig {
  AppConfig._();

  // ────────────────────── Environment ────────────────────────────

  /// The active environment. Change this to switch **all** URLs at once.
  static Environment environment = Environment.dev;

  // ────────────────────── Initialisation ─────────────────────────

  /// Loads the `.env` file and sets the active environment.
  ///
  /// Must be called before `runApp`.
  static Future<void> init({
    Environment? env,
    String envFileName = '.env',
  }) async {
    await dotenv.load(fileName: envFileName);
    environment = env ?? _environmentFromDotEnv();
  }

  static Environment _environmentFromDotEnv() {
    final String rawEnv = dotenv
        .get('ENV', fallback: 'dev')
        .trim()
        .toLowerCase();
    switch (rawEnv) {
      case 'dev':
        return Environment.dev;
      case 'ngrok':
        return Environment.ngrok;
      case 'stage':
        return Environment.stage;
      case 'prod':
        return Environment.prod;
      default:
        return Environment.dev;
    }
  }

  // ────────────────────── API URLs ───────────────────────────────

  /// REST API base URL for the current environment.
  static String get baseUrl => environment.baseUrl;

  // ────────────────────── Socket URLs ────────────────────────────

  /// WebSocket URL for the current environment.
  static String get socketUrl => environment.socketUrl;

  // ────────────────────── Patient Chat ───────────────────────────

  /// Patient Chat API base URL for the current environment.
  static String get patientChatBaseUrl => environment.patientChatBaseUrl;

  // ────────────────────── Google Maps ────────────────────────────

  /// Google Maps API key resolved for the current environment.
  static String get googleMapApiKey => environment.googleMapApiKey;

  // ────────────────────── Image ──────────────────────────────────

  /// Cloud Storage image base URL (environment-independent).
  static String get imageUrl => dotenv.get('IMAGE_URL', fallback: '');

  // ────────────────────── Sentry ─────────────────────────────────

  /// Sentry DSN (environment-independent).
  static String get sentryUrl => dotenv.get('SENTRY_URL', fallback: '');

  // ────────────────────── Crypto ─────────────────────────────────

  /// Vite crypto secret key.
  static String get viteCryptoSecretKey => environment.viteCryptoSecretKey;

  // ────────────────────── Generic ────────────────────────────────

  /// Retrieve **any** `.env` value by its raw key name.
  static String? get(String key) => dotenv.maybeGet(key);
}
