import 'package:subqdocs_bloc/core/constants/app_strings.dart';
import 'package:subqdocs_bloc/core/utils/date_formatters.dart';

/// Formats a visit calendar day for list display (local calendar semantics).
String scheduleVisitRelativeDateLabel(DateTime visitInstantUtc, DateTime now) {
  final DateTime visitLocal = visitInstantUtc.toLocal();
  final DateTime v = DateTime(
    visitLocal.year,
    visitLocal.month,
    visitLocal.day,
  );
  final DateTime t = DateTime(now.year, now.month, now.day);
  final int d = v.difference(t).inDays;
  if (d == 0) {
    return AppStrings.homeScheduleDateToday;
  }
  if (d == -1) {
    return AppStrings.homeScheduleDateYesterday;
  }
  if (d == 1) {
    return AppStrings.homeScheduleDateTomorrow;
  }
  return formatDateMmDdYyyy(visitLocal);
}

String scheduleVisitTimeLabel(DateTime visitInstantUtc) {
  final DateTime t = visitInstantUtc.toLocal();
  final int hour24 = t.hour;
  final int m = t.minute;
  final String period = hour24 >= 12 ? 'PM' : 'AM';
  final int h12 = hour24 % 12 == 0 ? 12 : hour24 % 12;
  final String mm = m.toString().padLeft(2, '0');
  return '$h12:$mm $period';
}
