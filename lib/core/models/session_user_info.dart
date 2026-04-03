import 'package:flutter/material.dart';
import 'package:subqdocs_bloc/core/constants/app_preferences_keys.dart';
import 'package:subqdocs_bloc/core/services/app_preferences.dart';
import 'package:subqdocs_bloc/data/models/login_model.dart';

/// Lightweight profile for app bars and drawer, hydrated from [loginResponse].
final class SessionUserInfo {
  SessionUserInfo({
    required this.displayName,
    required this.title,
    required this.profileImageUrl,
    required this.fallbackDarkColor,
    required this.initials,
  });

  final String displayName;
  final String title;
  final String profileImageUrl;
  final Color fallbackDarkColor;
  final String initials;

  static SessionUserInfo _cached = SessionUserInfo._empty();

  static SessionUserInfo _empty() {
    return SessionUserInfo(
      displayName: '',
      title: '',
      profileImageUrl: '',
      fallbackDarkColor: const Color(0xFF5B5BE1),
      initials: '?',
    );
  }

  /// Call after [AppPreferences.initialize] and whenever login / user payload changes.
  static Future<void> hydrate() async {
    final String? raw = await AppPreferences.instance.getString(
      AppPreferencesKeys.loginResponse,
    );
    _cached = _fromLoginResponseRaw(raw);
  }

  /// Clears cached profile (e.g. after logout).
  static void clearCache() {
    _cached = SessionUserInfo._empty();
  }

  static SessionUserInfo loadSync() => _cached;

  static SessionUserInfo _fromLoginResponseRaw(String? raw) {
    if (raw == null || raw.trim().isEmpty) {
      return SessionUserInfo._empty();
    }
    try {
      final LoginModel model = loginModelFromJson(raw);
      final User? user = model.responseData?.user;
      if (user == null) {
        return SessionUserInfo._empty();
      }
      final String first = (user.firstName ?? '').trim();
      final String last = (user.lastName ?? '').trim();
      final String display = '$first $last'.trim();
      final String email = (user.email ?? '').trim();
      final String showName = display.isNotEmpty
          ? display
          : (email.isNotEmpty ? email : 'User');
      final String ini = _initials(first, last, email);
      final String? pic = user.profileImage?.trim();
      return SessionUserInfo(
        displayName: showName,
        title: (user.title ?? '').trim(),
        profileImageUrl: pic != null && pic.isNotEmpty ? pic : '',
        fallbackDarkColor: _colorForSeed(email.isNotEmpty ? email : showName),
        initials: ini,
      );
    } catch (_) {
      return SessionUserInfo._empty();
    }
  }

  static String _initials(String first, String last, String email) {
    String one(String s) => s.isEmpty ? '' : s.substring(0, 1).toUpperCase();
    if (first.isNotEmpty && last.isNotEmpty) {
      return '${one(first)}${one(last)}';
    }
    if (first.isNotEmpty) {
      return one(first);
    }
    if (email.isNotEmpty) {
      return one(email);
    }
    return '?';
  }

  static Color _colorForSeed(String seed) {
    if (seed.isEmpty) {
      return const Color(0xFF5B5BE1);
    }
    int h = 0;
    for (final int u in seed.codeUnits) {
      h = (h * 31 + u) & 0x7fffffff;
    }
    final double t = (h % 360) / 360.0;
    return HSLColor.fromAHSL(1, t * 360, 0.45, 0.42).toColor();
  }
}
