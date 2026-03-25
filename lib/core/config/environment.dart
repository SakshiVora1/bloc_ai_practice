import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Supported application environments.
///
/// Switching the environment in [AppConfig] automatically updates
/// every URL (API, socket, patient-chat) that depends on it.
enum Environment {
  dev,
  ngrok,
  stage,
  prod;

  // ────────────────────── API base URLs ──────────────────────────

  /// REST API base URL for the current environment.
  String get baseUrl {
    switch (this) {
      case Environment.dev:
        return dotenv.get('DEV_URL', fallback: '');
      case Environment.ngrok:
        return dotenv.get('NGROK_URL', fallback: '');
      case Environment.stage:
        return dotenv.get('STAGE_URL', fallback: '');
      case Environment.prod:
        return dotenv.get('PROD_URL', fallback: '');
    }
  }

  // ────────────────────── Socket URLs ────────────────────────────

  /// WebSocket URL for the current environment.
  String get socketUrl {
    switch (this) {
      case Environment.dev:
        return dotenv.get('SOCKET_DEV_URL', fallback: '');
      case Environment.ngrok:
        return dotenv.get('SOCKET_NGROK_URL', fallback: '');
      case Environment.stage:
        return dotenv.get('SOCKET_STAGE_URL', fallback: '');
      case Environment.prod:
        return dotenv.get('SOCKET_PROD_URL', fallback: '');
    }
  }

  // ────────────────────── Patient Chat URLs ──────────────────────

  /// Patient Chat API base URL for the current environment.
  String get patientChatBaseUrl {
    switch (this) {
      case Environment.dev:
        return dotenv.get('PATIENT_CHAT_DEV_URL', fallback: '');
      case Environment.ngrok:
        return dotenv.get('PATIENT_CHAT_NGROK_URL', fallback: '');
      case Environment.stage:
        return dotenv.get('PATIENT_CHAT_STAGE_URL', fallback: '');
      case Environment.prod:
        return dotenv.get('PATIENT_CHAT_PROD_URL', fallback: '');
    }
  }

  // ────────────────────── Google Maps ────────────────────────────

  /// Google Maps API key for the current environment.
  String get googleMapApiKey {
    switch (this) {
      case Environment.dev:
      case Environment.ngrok:
      case Environment.stage:
        return dotenv.get('GOOGLE_MAP_API_DEV', fallback: '');
      case Environment.prod:
        return dotenv.get('GOOGLE_MAP_API_PROD', fallback: '');
    }
  }

  // ────────────────────── Shared keys ────────────────────────────

  /// Crypto secret key (environment-independent).
  String get viteCryptoSecretKey {
    return dotenv.get('VITE_CRYPTO_SECRET_KEY', fallback: '');
  }
}
