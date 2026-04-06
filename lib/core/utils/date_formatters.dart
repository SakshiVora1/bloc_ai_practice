/// App-wide **calendar** display format: **MM/dd/yyyy** (see [formatDateMmDdYyyy]).
/// API payloads use ISO **yyyy-MM-dd** ([formatYyyyMmDd]) unless an endpoint dictates otherwise.
///
/// Parses [value] using [DateTime.tryParse]; returns null when invalid.
DateTime? tryParseDate(Object? value) {
  if (value == null) {
    return null;
  }
  if (value is DateTime) {
    return value;
  }
  if (value is String && value.trim().isNotEmpty) {
    return DateTime.tryParse(value.trim());
  }
  return null;
}

/// Formats [d] in the app-preferred calendar date style (MM/dd/yyyy).
String formatDateMmDdYyyy(DateTime d) {
  final DateTime local = d.toLocal();
  final String m = local.month.toString().padLeft(2, '0');
  final String day = local.day.toString().padLeft(2, '0');
  return '$m/$day/${local.year}';
}

/// API-style ISO date (yyyy-MM-dd) for profile update payloads.
String formatYyyyMmDd(DateTime d) {
  final DateTime local = d.toLocal();
  final String y = local.year.toString().padLeft(4, '0');
  final String m = local.month.toString().padLeft(2, '0');
  final String day = local.day.toString().padLeft(2, '0');
  return '$y-$m-$day';
}
