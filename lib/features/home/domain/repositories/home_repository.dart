import 'package:subqdocs_bloc/core/models/country_option.dart';
import 'package:subqdocs_bloc/data/models/organization_model.dart';
import 'package:subqdocs_bloc/data/models/staff_model.dart';
import 'package:subqdocs_bloc/data/models/office_location_model.dart';
import 'package:subqdocs_bloc/data/models/visit_type_model.dart';
import 'package:subqdocs_bloc/data/models/visit_model.dart';
import 'package:subqdocs_bloc/features/home/domain/models/schedule_visit_address_suggestion.dart';
import 'package:subqdocs_bloc/features/home/domain/models/saved_visit_filters.dart';
import 'package:subqdocs_bloc/features/patients/data/patients_list_api_envelope.dart';

abstract interface class HomeRepository {
  Future<OrganizationModel> getOrganization();
  Future<List<StaffModel>> getUsersByRole({required String role});
  Future<List<OfficeLocationModel>> getOfficeLocations();
  Future<List<VisitTypeModel>> getVisitTypes({
    int limit = 50,
    bool isVisibleToUser = true,
  });
  Future<SavedVisitFilters> getSavedVisitFilters();
  Future<Map<String, dynamic>> updateSavedVisitFilters(
    SavedVisitFilters filters,
  );
  Future<PatientsListApiEnvelope> fetchPatients({
    required int page,
    required int limit,
    String search = '',
    List<Map<String, dynamic>> sorting = const <Map<String, dynamic>>[],
  });
  Future<List<ScheduleVisitAddressSuggestion>> fetchStreetAddressSuggestions({
    required String search,
    required CountryOption country,
  });
  Future<ScheduleVisitAddressDetails> fetchStreetAddressDetails({
    required String placeId,
  });

  Future<VisitListResponse> getCurrentVisits({
    required SavedVisitFilters filters,
    int page = 1,
    int limit = 100,
  });
  Future<VisitListResponse> getUpcomingVisits({
    required SavedVisitFilters filters,
    int page = 1,
    int limit = 100,
  });
  Future<VisitListResponse> getRecordedVisits({
    required SavedVisitFilters filters,
    int page = 1,
    int limit = 100,
  });
}
