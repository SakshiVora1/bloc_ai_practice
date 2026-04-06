import 'package:subqdocs_bloc/features/patients/data/patients_list_api_envelope.dart';

abstract interface class PatientsRepository {
  /// GET [patient/getAllPatients]. [sorting] entries use keys `id` and `desc`.
  Future<PatientsListApiEnvelope> fetchPatients({
    required int page,
    required int limit,
    String search,
    List<Map<String, dynamic>> sorting,
  });
}
