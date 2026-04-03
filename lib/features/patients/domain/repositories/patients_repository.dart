import 'package:subqdocs_bloc/features/patients/data/patient_list_row.dart';

/// Paginated patients list + envelope fields for BLoC `response_type` handling.
final class PatientsListPageResult {
  const PatientsListPageResult({
    required this.rows,
    required this.totalCount,
    required this.totalPage,
    required this.page,
    required this.limit,
    required this.responseType,
    this.message,
  });

  final List<PatientListRow> rows;
  final int totalCount;
  final int totalPage;
  final int page;
  final int limit;
  final String? responseType;
  final String? message;
}

abstract interface class PatientsRepository {
  Future<PatientsListPageResult> fetchPatientsPage({
    required int page,
    required int limit,
    String? search,
    required List<Map<String, dynamic>> sorting,
  });
}
