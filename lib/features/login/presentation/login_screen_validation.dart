import 'package:subqdocs_bloc/core/constants/app_strings.dart';

/// Looser email check for settings and other non-login flows.
String? validateLoginEmail(String? value) {
  final String v = value?.trim() ?? '';
  if (v.isEmpty) {
    return AppStrings.requiredEmail;
  }
  if (!v.contains('@')) {
    return AppStrings.invalidEmail;
  }
  return null;
}

/// Login screen email (matches login API / UX copy).
String? validateLoginFormEmail(String? value) {
  final String v = value?.trim() ?? '';
  if (v.isEmpty) {
    return AppStrings.loginRequiredEmail;
  }
  final RegExp emailRegex = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$');
  if (!emailRegex.hasMatch(v)) {
    return AppStrings.loginInvalidEmail;
  }
  return null;
}

/// Login screen password rules.
String? validateLoginFormPassword(String? value) {
  final String v = value ?? '';
  if (v.isEmpty) {
    return AppStrings.loginRequiredPassword;
  }
  if (v.length < 8 || v.length > 20) {
    return AppStrings.loginPasswordLength;
  }
  if (!RegExp(r'[A-Za-z]').hasMatch(v)) {
    return AppStrings.loginPasswordLetter;
  }
  if (!RegExp(r'\d').hasMatch(v)) {
    return AppStrings.loginPasswordNumber;
  }
  if (!RegExp(r'[!@#$%^&*(),.?":{}|<>_\-\\/\[\]`~+=;]').hasMatch(v)) {
    return AppStrings.loginPasswordSpecial;
  }
  return null;
}
