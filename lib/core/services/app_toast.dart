import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

/// App-wide [toastification] helpers. Prefer this over calling
/// [toastification.show] directly so duration, alignment, and style stay
/// consistent.
abstract final class AppToast {
  AppToast._();

  static const Duration _autoCloseDuration = Duration(seconds: 3);
  static const AlignmentGeometry _alignment = Alignment.bottomCenter;

  static void showError(BuildContext context, String message) {
    _show(context, ToastificationType.error, message);
  }

  static void showSuccess(BuildContext context, String message) {
    _show(context, ToastificationType.success, message);
  }

  static void showInfo(BuildContext context, String message) {
    _show(context, ToastificationType.info, message);
  }

  static void showWarning(BuildContext context, String message) {
    _show(context, ToastificationType.warning, message);
  }

  static void _show(
    BuildContext context,
    ToastificationType type,
    String message,
  ) {
    if (!context.mounted || message.isEmpty) {
      return;
    }
    toastification.show(
      context: context,
      type: type,
      style: ToastificationStyle.flatColored,
      alignment: _alignment,
      autoCloseDuration: _autoCloseDuration,
      title: Text(message),
    );
  }
}
