import 'package:subqdocs_bloc/data/models/login_model.dart';

/// Returns [value] trimmed, or `'-'` when null/empty.
String settingsDisplayOrDash(String? value) {
  final String v = (value ?? '').trim();
  return v.isEmpty ? '-' : v;
}

String? settingsOfficeLocationIdsText(User? user) {
  final Object? raw = user?.officeLocationIds;
  if (raw is! List<dynamic>) {
    return null;
  }
  final Iterable<int> ids = raw
      .map((dynamic e) {
        if (e is int) {
          return e;
        }
        if (e is String) {
          return int.tryParse(e) ?? 0;
        }
        return 0;
      })
      .where((int e) => e != 0);
  final List<int> list = ids.toList();
  if (list.isEmpty) {
    return null;
  }
  return list.join(', ');
}
