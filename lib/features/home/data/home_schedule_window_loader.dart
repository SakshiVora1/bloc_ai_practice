import 'dart:math' as math;

import 'package:subqdocs_bloc/core/models/home_visit.dart';
import 'package:subqdocs_bloc/models/home_models.dart';

/// Parses the single static dataset and applies fixed index windows (no recomputation).
List<List<HomeVisit>> loadScheduleWindowsFromStaticJson() {
  final Object? responseData = HomeModels.visitTable['responseData'];
  if (responseData is! Map) {
    return <List<HomeVisit>>[<HomeVisit>[], <HomeVisit>[], <HomeVisit>[]];
  }
  final Object? data = responseData['data'];
  if (data is! List) {
    return <List<HomeVisit>>[<HomeVisit>[], <HomeVisit>[], <HomeVisit>[]];
  }

  final List<HomeVisit> all = <HomeVisit>[];
  for (final Object? row in data) {
    if (row is Map) {
      all.add(HomeVisit.fromJson(Map<String, dynamic>.from(row)));
    }
  }

  List<HomeVisit> slice(int startInclusive, int endExclusive) {
    if (startInclusive >= all.length) {
      return <HomeVisit>[];
    }
    final int end = math.min(endExclusive, all.length);
    return List<HomeVisit>.unmodifiable(all.sublist(startInclusive, end));
  }

  return <List<HomeVisit>>[slice(0, 20), slice(20, 40), slice(40, all.length)];
}
