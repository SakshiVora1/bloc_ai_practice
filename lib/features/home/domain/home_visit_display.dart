import 'package:subqdocs_bloc/core/constants/app_strings.dart';
import 'package:subqdocs_bloc/core/utils/date_formatters.dart';

String formatHomeVisitDateTime(
  String? appointmentTime,
  String? fallbackVisitTime,
) {
  final DateTime? parsed =
      parseHomeVisitDateTime(appointmentTime) ??
      parseHomeVisitDateTime(fallbackVisitTime);
  if (parsed == null) {
    return AppStrings.homeUnknownLabel;
  }
  final DateTime local = parsed.toLocal();
  final String hh = local.hour == 0
      ? '12'
      : (local.hour > 12 ? '${local.hour - 12}' : '${local.hour}').padLeft(
          2,
          '0',
        );
  final String mm = '${local.minute}'.padLeft(2, '0');
  final String amPm = local.hour >= 12 ? 'PM' : 'AM';
  return '$hh:$mm $amPm ${formatDateMmDdYyyy(local)}';
}

DateTime? parseHomeVisitDateTime(String? value) {
  if (value == null || value.isEmpty) {
    return null;
  }
  try {
    return DateTime.parse(value);
  } catch (_) {
    return null;
  }
}

String homeVisitDoctorName(String? doctor) {
  if (doctor == null || doctor.trim().isEmpty) {
    return AppStrings.homeUnknownLabel;
  }
  return doctor.trim();
}

/// Two-letter initials from a display name (first + last word or first letter).
String initialsFromFullName(String rawName) {
  final String t = rawName.trim();
  if (t.isEmpty) {
    return '?';
  }
  final List<String> parts = t
      .split(RegExp(r'\s+'))
      .where((String p) => p.isNotEmpty)
      .toList();
  if (parts.length >= 2) {
    final String a = parts.first.isNotEmpty ? parts.first[0] : '';
    final String b = parts.last.isNotEmpty ? parts.last[0] : '';
    return '${a.toUpperCase()}${b.toUpperCase()}';
  }
  return parts.first[0].toUpperCase();
}

/// Short gender code for list rows (pass-through or `'—'`).
String homeVisitGenderCode(String? gender) {
  final String g = gender?.trim() ?? '';
  if (g.isEmpty) {
    return AppStrings.homeUnknownLabel;
  }
  if (g.length <= 2) {
    return g.toUpperCase();
  }
  return g[0].toUpperCase();
}

/// Combines DOB and age when available for a subtitle line.
String homeVisitDateAndAge(Object? dobRaw, Object? ageRaw) {
  final String? dob = dobRaw?.toString().trim();
  final int? age = ageRaw is int
      ? ageRaw
      : int.tryParse(ageRaw?.toString().trim() ?? '');
  final Object? parsed = dob != null && dob.isNotEmpty
      ? DateTime.tryParse(dob)
      : null;
  final String datePart = parsed is DateTime
      ? formatDateMmDdYyyy(parsed)
      : AppStrings.homeUnknownLabel;
  if (age != null && age > 0) {
    return '$datePart · $age';
  }
  return datePart;
}
