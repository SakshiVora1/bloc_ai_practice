import 'package:subqdocs_bloc/core/utils/date_formatters.dart';
import 'package:subqdocs_bloc/data/models/login_model.dart';
import 'package:subqdocs_bloc/features/settings/presentation/utils/settings_profile_merge.dart';

/// Returns [value] trimmed, or `'-'` when null/empty.
String settingsDisplayOrDash(String? value) {
  final String v = (value ?? '').trim();
  return v.isEmpty ? '-' : v;
}

String? settingsOfficeLocationNamesText(User? user) {
  final List<OfficeLocation>? offices = user?.officeLocations;
  if (offices == null || offices.isEmpty) {
    return null;
  }
  final List<String> names = offices
      .map((OfficeLocation office) => (office.name ?? '').trim())
      .where((String name) => name.isNotEmpty)
      .toList();
  if (names.isEmpty) {
    return null;
  }
  return names.join(', ');
}

/// Parses ISO or API date strings and shows **MM/dd/yyyy**; otherwise `'-'`.
String settingsDisplayCalendarDate(Object? raw) {
  if (raw == null) {
    return '-';
  }
  final String s = raw.toString().trim();
  if (s.isEmpty) {
    return '-';
  }
  final DateTime? d = tryParseDate(s);
  if (d != null) {
    return formatDateMmDdYyyy(d);
  }
  return s;
}

/// US phone in `+1 (###) ###-####` for read-only display, or `'-'` when empty.
String settingsDisplayPhone(String? contactNo) {
  final String masked = settingsFormatPhoneMaskInitial(contactNo);
  return masked.isEmpty ? '-' : masked;
}
