import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:subqdocs_bloc/features/home/domain/home_date_display.dart';
import 'package:subqdocs_bloc/features/home/presentation/bloc/home_screen_bloc.dart';

import 'package:subqdocs_bloc/features/home/domain/repositories/home_repository.dart';
import 'package:subqdocs_bloc/data/models/organization_model.dart';
import 'package:subqdocs_bloc/data/models/staff_model.dart';
import 'package:subqdocs_bloc/data/models/office_location_model.dart';
import 'package:subqdocs_bloc/data/models/visit_type_model.dart';
import 'package:subqdocs_bloc/features/home/domain/models/saved_visit_filters.dart';

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
