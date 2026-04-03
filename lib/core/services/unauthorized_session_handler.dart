import 'package:flutter/widgets.dart';

import 'package:subqdocs_bloc/core/constants/app_preferences_keys.dart';
import 'package:subqdocs_bloc/core/constants/app_strings.dart';
import 'package:subqdocs_bloc/core/models/session_user_info.dart';
import 'package:subqdocs_bloc/core/routing/app_router.dart';
import 'package:subqdocs_bloc/core/routing/root_navigator_key.dart';
import 'package:subqdocs_bloc/core/services/app_preferences.dart';
import 'package:subqdocs_bloc/core/services/app_toast.dart';
import 'package:subqdocs_bloc/core/services/session_user_cache.dart';

/// Clears stored session and returns the user to login when the API returns 401.
abstract final class UnauthorizedSessionHandler {
  UnauthorizedSessionHandler._();

  static bool _logoutUiScheduled = false;

  /// Removes the auth payload from preferences, notifies listeners, then
  /// navigates to login and shows [AppStrings.unauthorizedUser].
  ///
  /// Safe to call multiple times (e.g. parallel requests): navigation and
  /// toast run at most once per scheduler generation until the post-frame
  /// callback runs.
  static Future<void> handleHttpUnauthorized() async {
    await AppPreferences.instance.removeKey(AppPreferencesKeys.loginResponse);
    SessionUserInfo.clearCache();
    SessionUserCache.notifyLoginResponseChanged();

    if (_logoutUiScheduled) {
      return;
    }
    _logoutUiScheduled = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _logoutUiScheduled = false;

      final BuildContext? context = RootNavigatorKey.instance.currentContext;
      if (context == null || !context.mounted) {
        return;
      }

      AppRouter.replaceWithLogin(context);

      WidgetsBinding.instance.addPostFrameCallback((_) {
        final BuildContext? next = RootNavigatorKey.instance.currentContext;
        if (next != null && next.mounted) {
          AppToast.showError(next, AppStrings.unauthorizedUser);
        }
      });
    });
  }
}
