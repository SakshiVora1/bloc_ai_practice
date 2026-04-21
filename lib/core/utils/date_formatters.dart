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

/// Extension for DateTime to provide ISO format yyyy-MM-dd.
extension DateExtensions on DateTime {
  String toIsoDateString() => formatYyyyMmDd(this);
}

/// Formats time as HH:mm:ss+OFFSET for visit creation.
/// [d] is the DateTime containing the visit time.
String formatVisitTimeWithOffset(DateTime d, {bool use24Hour = true}) {
  final DateTime local = d.toLocal();
  final String h = local.hour.toString().padLeft(2, '0');
  final String m = local.minute.toString().padLeft(2, '0');
  const String s = "00";

  // Get timezone offset: e.g. +05:30
  final Duration offset = d.timeZoneOffset;
  final String sign = offset.isNegative ? '-' : '+';
  final int absMinutes = offset.inMinutes.abs();
  final int offsetHours = absMinutes ~/ 60;
  final int offsetMins = absMinutes % 60;

  final String oh = offsetHours.toString().padLeft(1, '0');
  final String om = offsetMins.toString().padLeft(2, '0');

  return '$h:$m:$s$sign$oh:$om';
}
