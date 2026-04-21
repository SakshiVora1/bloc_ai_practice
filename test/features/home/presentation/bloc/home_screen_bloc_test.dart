import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:subqdocs_bloc/core/models/country_option.dart';
import 'package:subqdocs_bloc/features/home/domain/home_date_display.dart';
import 'package:subqdocs_bloc/features/home/domain/models/schedule_visit_address_suggestion.dart';
import 'package:subqdocs_bloc/features/home/presentation/bloc/home_screen_bloc.dart';

import 'package:subqdocs_bloc/features/home/domain/repositories/home_repository.dart';
import 'package:subqdocs_bloc/data/models/organization_model.dart';
import 'package:subqdocs_bloc/data/models/staff_model.dart';
import 'package:subqdocs_bloc/data/models/office_location_model.dart';
import 'package:subqdocs_bloc/data/models/visit_type_model.dart';
import 'package:subqdocs_bloc/data/models/visit_model.dart';
import 'package:subqdocs_bloc/features/home/domain/models/saved_visit_filters.dart';
import 'package:subqdocs_bloc/features/patients/data/patients_list_api_envelope.dart';

class _MockHomeRepository implements HomeRepository {
  @override
  Future<OrganizationModel> getOrganization() async {
    return OrganizationModel();
  }

  @override
  Future<List<OfficeLocationModel>> getOfficeLocations() async {
    return [];
  }

  @override
  Future<List<StaffModel>> getUsersByRole({required String role}) async {
    return [];
  }

  @override
  Future<List<VisitTypeModel>> getVisitTypes({
    int limit = 50,
    bool isVisibleToUser = true,
  }) async {
    return [];
  }

  @override
  Future<SavedVisitFilters> getSavedVisitFilters() async {
    return SavedVisitFilters();
  }

  @override
  Future<Map<String, dynamic>> updateSavedVisitFilters(
    SavedVisitFilters filters,
  ) async {
    return {'toast': true, 'message': 'Success'};
  }

  @override
  Future<PatientsListApiEnvelope> fetchPatients({
    required int page,
    required int limit,
    String search = '',
    List<Map<String, dynamic>> sorting = const <Map<String, dynamic>>[],
  }) async {
    return const PatientsListApiEnvelope(
      responseType: 'success',
      message: null,
      responseData: PatientsListPageData(
        rows: [],
        totalCount: 0,
        totalPage: 1,
        page: 1,
        limit: 15,
      ),
    );
  }

  @override
  Future<List<ScheduleVisitAddressSuggestion>> fetchStreetAddressSuggestions({
    required String search,
    required CountryOption country,
  }) async {
    return const <ScheduleVisitAddressSuggestion>[];
  }

  @override
  Future<ScheduleVisitAddressDetails> fetchStreetAddressDetails({
    required String placeId,
  }) async {
    return const ScheduleVisitAddressDetails(
      streetAddress: '',
      city: '',
      state: '',
      postalCode: '',
    );
  }

  @override
  Future<VisitListResponse> getCurrentVisits({
    required SavedVisitFilters filters,
    int page = 1,
    int limit = 100,
  }) async {
    return VisitListResponse(
      data: [],
      filteredCount: 0,
      page: 1,
      limit: 100,
      totalPage: 1,
    );
  }

  @override
  Future<VisitListResponse> getUpcomingVisits({
    required SavedVisitFilters filters,
    int page = 1,
    int limit = 100,
  }) async {
    return VisitListResponse(
      data: [],
      filteredCount: 0,
      page: 1,
      limit: 100,
      totalPage: 1,
    );
  }

  @override
  Future<VisitListResponse> getRecordedVisits({
    required SavedVisitFilters filters,
    int page = 1,
    int limit = 100,
  }) async {
    return VisitListResponse(
      data: [],
      filteredCount: 0,
      page: 1,
      limit: 100,
      totalPage: 1,
    );
  }

  @override
  Future<Map<String, dynamic>> createVisit({required Map<String, dynamic> body}) async {
    return {'response_type': 'success', 'message': 'Visit scheduled successfully'};
  }

  @override
  Future<Map<String, dynamic>> updatePatient({
    required int patientId,
    required Map<String, dynamic> body,
  }) async {
    return {'response_type': 'success', 'message': 'Patient updated successfully'};
  }

  @override
  Future<Map<String, dynamic>> createMobilePatient({required Map<String, dynamic> body}) async {
    return {
      'response_type': 'success',
      'message': 'Patient created',
      'response_data': {'id': 123}
    };
  }
}

void main() {
  group('HomeScreenBloc', () {
    blocTest<HomeScreenBloc, HomeScreenState>(
      'emits HomeScreenReady when HomeScreenStarted is added',
      build: () => HomeScreenBloc(homeRepository: _MockHomeRepository()),
      act: (HomeScreenBloc b) => b.add(const HomeScreenStarted()),
      verify: (HomeScreenBloc b) {
        final HomeScreenState state = b.state;
        expect(state, isA<HomeScreenReady>());
        final HomeScreenReady ready = state as HomeScreenReady;
        final DateTime today = todayDateOnly(() => DateTime.now());
        expect(ready.startDate, today);
        expect(ready.endDate, isNull);
        expect(ready.displayLabel, isNotEmpty);
      },
    );
  });
}
