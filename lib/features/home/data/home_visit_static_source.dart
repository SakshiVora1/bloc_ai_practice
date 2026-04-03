import 'package:subqdocs_bloc/core/models/home_models.dart';
import 'package:subqdocs_bloc/core/models/home_visit.dart';

/// Loads visits from [HomeModels.visitTable] without network I/O.
List<HomeVisit> loadHomeVisitsFromStaticJson() {
  final Object? responseData = HomeModels.visitTable['responseData'];
  if (responseData is! Map<String, dynamic>) {
    return <HomeVisit>[];
  }
  final Object? data = responseData['data'];
  if (data is! List<dynamic>) {
    return <HomeVisit>[];
  }
  return data
      .whereType<Map<String, dynamic>>()
      .map(HomeVisit.fromJson)
      .toList(growable: false);
}
