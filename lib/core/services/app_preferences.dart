import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {
  AppPreferences._();

  static AppPreferences? _instance;

  static AppPreferences get instance => _instance ??= AppPreferences._();

  SharedPreferences? _prefs;
  Future<void>? _initializingFuture;

  Future<void> initialize() {
    if (_prefs != null) {
      return Future<void>.value();
    }

    return _initializingFuture ??= _initializeInternal();
  }

  Future<void> _initializeInternal() async {
    _prefs = await SharedPreferences.getInstance();
    _initializingFuture = null;
  }

  SharedPreferences get _safePrefs {
    final SharedPreferences? prefs = _prefs;
    if (prefs == null) {
      throw StateError(
        'AppPreferences is not initialized. Call and await initialize() first.',
      );
    }
    return prefs;
  }

  Future<bool> setString(String key, String value) async {
    await initialize();
    return _safePrefs.setString(key, value);
  }

  Future<bool> setInt(String key, int value) async {
    await initialize();
    return _safePrefs.setInt(key, value);
  }

  Future<bool> setDouble(String key, double value) async {
    await initialize();
    return _safePrefs.setDouble(key, value);
  }

  Future<bool> setBool(String key, bool value) async {
    await initialize();
    return _safePrefs.setBool(key, value);
  }

  Future<String?> getString(String key) async {
    await initialize();
    return _safePrefs.getString(key);
  }

  Future<int?> getInt(String key) async {
    await initialize();
    return _safePrefs.getInt(key);
  }

  Future<double?> getDouble(String key) async {
    await initialize();
    return _safePrefs.getDouble(key);
  }

  Future<bool?> getBool(String key) async {
    await initialize();
    return _safePrefs.getBool(key);
  }

  Future<bool> removeKey(String key) async {
    await initialize();
    return _safePrefs.remove(key);
  }

  Future<bool> clearAll() async {
    await initialize();
    return _safePrefs.clear();
  }
}
