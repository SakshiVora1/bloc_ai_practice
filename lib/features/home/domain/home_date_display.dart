import 'package:subqdocs_bloc/core/utils/date_formatters.dart';

/// Pure date display formatting for the schedule header (uses [formatDateMmDdYyyy]).
String formatDisplayDate(
  DateTime? startDate,
  DateTime? endDate, {
  required DateTime Function() now,
  required String todayLabel,
  required String yesterdayLabel,
  required String tomorrowLabel,
}) {
  if (startDate == null) {
    return '';
  }

  final DateTime start = _dateOnly(startDate);
  if (endDate != null) {
    final DateTime end = _dateOnly(endDate);
    final DateTime rangeStart = start.isBefore(end) ? start : end;
    final DateTime rangeEnd = start.isBefore(end) ? end : start;
    return '${formatDateMmDdYyyy(rangeStart)} - ${formatDateMmDdYyyy(rangeEnd)}';
  }

  final DateTime today = _dateOnly(now());
  if (_isSameDay(start, today)) {
    return todayLabel;
  }
  if (_isSameDay(start, today.subtract(const Duration(days: 1)))) {
    return yesterdayLabel;
  }
  if (_isSameDay(start, today.add(const Duration(days: 1)))) {
    return tomorrowLabel;
  }
  return formatDateMmDdYyyy(start);
}

DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

/// Normalizes [d] to midnight in the local calendar (for pickers / comparisons).
DateTime dateOnly(DateTime d) => _dateOnly(d);

bool _isSameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

/// Calendar-local “today” for initial selection and bloc anchors.
DateTime todayDateOnly(DateTime Function() now) => _dateOnly(now());
