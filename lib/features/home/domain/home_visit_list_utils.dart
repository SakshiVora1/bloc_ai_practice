import 'package:subqdocs_bloc/core/constants/app_strings.dart';
import 'package:subqdocs_bloc/data/models/visit_model.dart';

List<Map<String, dynamic>> extractHomeVisits(Map<dynamic, dynamic> source) {
  final dynamic responseData = source['responseData'];
  if (responseData is! Map) {
    return <Map<String, dynamic>>[];
  }
  final dynamic data = responseData['data'];
  if (data is! List) {
    return <Map<String, dynamic>>[];
  }
  return data
      .whereType<Map>()
      .map((Map entry) => Map<String, dynamic>.from(entry))
      .toList();
}

List<Map<String, dynamic>> filterHomeVisits(
  List<Map<String, dynamic>> visits,
  String rawQuery,
) {
  final String query = rawQuery.trim().toLowerCase();
  if (query.isEmpty || query == AppStrings.homeScheduleSearchInitial) {
    return visits;
  }
  return visits.where((Map<String, dynamic> visit) {
    final String first = visit['first_name']?.toString().toLowerCase() ?? '';
    final String last = visit['last_name']?.toString().toLowerCase() ?? '';
    final String status = visit['visit_status']?.toString().toLowerCase() ?? '';
    final String visitType =
        visit['visitTypeName']?.toString().toLowerCase() ?? '';
    final String doctor = visit['doctorName']?.toString().toLowerCase() ?? '';
    final String haystack = '$first $last $status $visitType $doctor';
    return haystack.contains(query);
  }).toList();
}

List<VisitModel> filterHomeVisitModels(
  List<VisitModel> visits,
  String rawQuery,
) {
  final String query = rawQuery.trim().toLowerCase();
  if (query.isEmpty || query == AppStrings.homeScheduleSearchInitial) {
    return visits;
  }
  return visits.where((VisitModel visit) {
    final String first = visit.firstName.toLowerCase();
    final String last = visit.lastName.toLowerCase();
    final String status = visit.visitStatus.toLowerCase();
    final String visitType = visit.visitTypeName?.toLowerCase() ?? '';
    final String doctor = visit.doctorName?.toLowerCase() ?? '';
    final String haystack = '$first $last $status $visitType $doctor';
    return haystack.contains(query);
  }).toList();
}
