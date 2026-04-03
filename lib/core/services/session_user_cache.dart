import 'package:flutter/foundation.dart';

/// Notifies widgets that read [SessionUserInfo.loadSync] after
/// [AppPreferencesKeys.loginResponse] changes so app bars and drawers refresh.
abstract final class SessionUserCache {
  SessionUserCache._();

  static final ValueNotifier<int> revision = ValueNotifier<int>(0);

  static void notifyLoginResponseChanged() {
    revision.value++;
  }
}
