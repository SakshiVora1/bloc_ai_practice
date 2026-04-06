import 'package:flutter/widgets.dart';

import 'package:subqdocs_bloc/core/routing/medical_record_route_args.dart';
import 'package:subqdocs_bloc/core/routing/route_names.dart';

/// Centralized navigation. Prefer this over calling [Navigator] from widgets.
abstract final class AppRouter {
  AppRouter._();

  /// Pops the current route (dialogs, bottom sheets). Use [maybePop] for drawers.
  static void pop(BuildContext context, [Object? result]) {
    Navigator.of(context).pop(result);
  }

  /// Pops only if the navigator can pop (e.g. closing an open drawer).
  static Future<bool> maybePop(BuildContext context) {
    return Navigator.of(context).maybePop();
  }

  static Future<void> replaceWithLogin(BuildContext context) {
    return Navigator.of(context).pushNamedAndRemoveUntil(
      RouteNames.login,
      (Route<dynamic> route) => false,
    );
  }

  static void replaceWithHome(BuildContext context) {
    Navigator.of(
      context,
    ).pushNamedAndRemoveUntil(RouteNames.home, (Route<dynamic> route) => false);
  }

  /// Alias for navigating to the main schedule shell (clears stack to [home]).
  static void goHome(BuildContext context) {
    replaceWithHome(context);
  }

  static void goPatients(BuildContext context) {
    final String? currentName = ModalRoute.of(context)?.settings.name;
    if (currentName == RouteNames.patients) {
      return;
    }
    Navigator.of(context).pushNamedAndRemoveUntil(
      RouteNames.patients,
      (Route<dynamic> route) => false,
    );
  }

  static void goSettings(BuildContext context) {
    final String? currentName = ModalRoute.of(context)?.settings.name;
    if (currentName == RouteNames.settings) {
      return;
    }
    Navigator.of(context).pushNamedAndRemoveUntil(
      RouteNames.settings,
      (Route<dynamic> route) => false,
    );
  }

  static Future<void> pushMedicalRecord(
    BuildContext context, {
    required int patientId,
  }) {
    return Navigator.of(context).pushNamed(
      RouteNames.medicalRecord,
      arguments: MedicalRecordRouteArgs(patientId: patientId),
    );
  }
}
