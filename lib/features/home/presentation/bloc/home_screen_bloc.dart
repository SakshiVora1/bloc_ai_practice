import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:subqdocs_bloc/core/constants/app_strings.dart';
import 'package:subqdocs_bloc/core/models/organization_singleton.dart';
import 'package:subqdocs_bloc/features/home/domain/home_date_display.dart';
import 'package:subqdocs_bloc/features/home/domain/repositories/home_repository.dart';
import 'package:subqdocs_bloc/data/models/organization_model.dart';
import 'package:subqdocs_bloc/data/models/staff_model.dart';
import 'package:subqdocs_bloc/data/models/office_location_model.dart';
import 'package:subqdocs_bloc/data/models/visit_type_model.dart';
import 'package:subqdocs_bloc/data/models/visit_model.dart';
import 'package:subqdocs_bloc/features/home/domain/models/saved_visit_filters.dart';

part 'home_screen_event.dart';

part 'home_screen_state.dart';

class HomeScreenBloc extends Bloc<HomeScreenEvent, HomeScreenState> {
  HomeScreenBloc({required this.homeRepository}) : super(const HomeScreenInitial()) {
    on<HomeScreenStarted>(_onStarted);
    on<HomeScreenDateForward>(_onDateForward);
    on<HomeScreenDateBackward>(_onDateBackward);
    on<HomeScreenDateSelected>(_onDateSelected);
    on<HomeScreenFilterPanelOpened>(_onFilterPanelOpened);
    on<HomeScreenScheduleVisitOpened>(_onScheduleVisitOpened);
    on<HomeScreenEndDrawerOpenConsumed>(_onEndDrawerOpenConsumed);
    on<HomeScreenSearchQueryChanged>(_onSearchQueryChanged);
    on<HomeScreenErrorMessageConsumed>(_onErrorMessageConsumed);
    on<HomeScreenFilterStatusChanged>(_onFilterStatusChanged);
    on<HomeScreenFilterProviderChanged>(_onFilterProviderChanged);
    on<HomeScreenFilterMedicalAssistantChanged>(
      _onFilterMedicalAssistantChanged,
    );
    on<HomeScreenFilterOfficeLocationChanged>(_onFilterOfficeLocationChanged);
    on<HomeScreenFilterClearAll>(_onFilterClearAll);
    on<HomeScreenFilterCalendarVisibilityToggled>(
      _onFilterCalendarVisibilityToggled,
    );
    on<HomeScreenFilterPanelClosed>(_onFilterPanelClosed);
    on<HomeScreenSuccessMessageConsumed>(_onSuccessMessageConsumed);
    on<HomeScreenCurrentVisitsRequested>(_onCurrentVisitsRequested);
    on<HomeScreenUpcomingVisitsRequested>(_onUpcomingVisitsRequested);
    on<HomeScreenRecordedVisitsRequested>(_onRecordedVisitsRequested);
  }


  final HomeRepository homeRepository;

  Future<void> _onStarted(
    HomeScreenStarted event,
    Emitter<HomeScreenState> emit,
  ) async {
    final DateTime today = todayDateOnly(() => DateTime.now());
    emit(
      HomeScreenReady(
        startDate: today,
        endDate: null,
        displayLabel: _computeDisplayLabel(today, null),
        isLoadingOrganization: true,
        isLoadingVisits: true,
      ),
    );

    try {
      final results = await Future.wait([
        homeRepository.getOrganization(),
        homeRepository.getUsersByRole(role: 'Doctor'),
        homeRepository.getUsersByRole(role: 'Medical Assistant'),
        homeRepository.getOfficeLocations(),
        homeRepository.getVisitTypes(limit: 50, isVisibleToUser: true),
        homeRepository.getSavedVisitFilters(),
      ]);

      final allProviders = results[1] as List<StaffModel>;
      final allMAs = results[2] as List<StaffModel>;
      final allLocations = results[3] as List<OfficeLocationModel>;
      final allVisitTypes = results[4] as List<VisitTypeModel>;
      final savedFilters = results[5] as SavedVisitFilters;

      // Apply saved filters
      final List<StaffModel> selectedProviders = savedFilters.doctorIds
          .map((id) => allProviders.firstWhere((p) => p.id == id))
          .toList();
      final List<StaffModel> selectedMAs = savedFilters.maIds
          .map((id) => allMAs.firstWhere((m) => m.id == id))
          .toList();
      final List<OfficeLocationModel> selectedLocations = savedFilters
          .locationIds
          .map((id) => allLocations.firstWhere((l) => l.id == id))
          .toList();

      final DateTime finalStart = savedFilters.startDate ?? today;
      final DateTime? finalEnd = savedFilters.endDate;

      if (!isClosed) {
        emit(
          _asReady(state).copyWith(
            isLoadingOrganization: false,
            isLoadingVisits: true,
            allProviders: allProviders,
            allMedicalAssistants: allMAs,
            allOfficeLocations: allLocations,
            allVisitTypes: allVisitTypes,
            selectedProviders: selectedProviders,
            selectedMedicalAssistants: selectedMAs,
            selectedOfficeLocations: selectedLocations,
            selectedStatuses: savedFilters.status,
            startDate: finalStart,
            endDate: finalEnd,
            clearRange: finalEnd == null,
            displayLabel: _computeDisplayLabel(finalStart, finalEnd),
          ),
        );

        // Trigger visit fetching for all sections
        add(const HomeScreenCurrentVisitsRequested());
        add(const HomeScreenUpcomingVisitsRequested());
        add(const HomeScreenRecordedVisitsRequested());
      }
    } catch (e) {
      if (!isClosed) {
        emit(
          _asReady(state).copyWith(
            isLoadingOrganization: false,
            errorMessage: e.toString(),
          ),
        );
      }
    }
  }

  void _onDateForward(
    HomeScreenDateForward event,
    Emitter<HomeScreenState> emit,
  ) {
    final HomeScreenReady current = _asReady(state);
    final DateTime anchor =
        current.endDate ??
        current.startDate ??
        todayDateOnly(() => DateTime.now());
    final DateTime next = DateTime(
      anchor.year,
      anchor.month,
      anchor.day,
    ).add(const Duration(days: 1));
    final DateTime nextDay = DateTime(next.year, next.month, next.day);
    emit(
      current.copyWith(
        startDate: nextDay,
        endDate: null,
        clearRange: true,
        displayLabel: _computeDisplayLabel(nextDay, null),
      ),
    );
  }

  void _onDateBackward(
    HomeScreenDateBackward event,
    Emitter<HomeScreenState> emit,
  ) {
    final HomeScreenReady current = _asReady(state);
    final DateTime anchor =
        current.startDate ?? todayDateOnly(() => DateTime.now());
    final DateTime prev = DateTime(
      anchor.year,
      anchor.month,
      anchor.day,
    ).subtract(const Duration(days: 1));
    final DateTime prevDay = DateTime(prev.year, prev.month, prev.day);
    emit(
      current.copyWith(
        startDate: prevDay,
        endDate: null,
        clearRange: true,
        displayLabel: _computeDisplayLabel(prevDay, null),
      ),
    );
  }

  void _onDateSelected(
    HomeScreenDateSelected event,
    Emitter<HomeScreenState> emit,
  ) {
    if (state is! HomeScreenReady) return;
    final HomeScreenReady current = _asReady(state);
    final DateTime start = DateTime(
      event.start.year,
      event.start.month,
      event.start.day,
    );
    final DateTime? end = event.end != null
        ? DateTime(event.end!.year, event.end!.month, event.end!.day)
        : null;

    if (current.activeEndDrawer == HomeScreenEndDrawerKind.filter) {
      emit(
        current.copyWith(
          draftStartDate: start,
          draftEndDate: end,
          clearDraftRange: end == null,
        ),
      );
    } else {
      emit(
        current.copyWith(
          startDate: start,
          endDate: end,
          clearRange: end == null,
          displayLabel: _computeDisplayLabel(start, end),
        ),
      );
    }
  }

  void _onFilterPanelOpened(
    HomeScreenFilterPanelOpened event,
    Emitter<HomeScreenState> emit,
  ) {
    final HomeScreenReady current = _asReady(state);
    emit(
      current.copyWith(
        activeEndDrawer: HomeScreenEndDrawerKind.filter,
        signalOpenEndDrawer: true,
        draftStartDate: current.startDate,
        draftEndDate: current.endDate,
        clearDraftRange: current.endDate == null,
        draftStatuses: List.from(current.selectedStatuses),
        draftProviders: List.from(current.selectedProviders),
        draftMedicalAssistants: List.from(current.selectedMedicalAssistants),
        draftOfficeLocations: List.from(current.selectedOfficeLocations),
      ),
    );
  }

  void _onScheduleVisitOpened(
    HomeScreenScheduleVisitOpened event,
    Emitter<HomeScreenState> emit,
  ) {
    final HomeScreenReady current = _asReady(state);
    emit(
      current.copyWith(
        activeEndDrawer: HomeScreenEndDrawerKind.scheduleVisit,
        signalOpenEndDrawer: true,
      ),
    );
  }

  void _onEndDrawerOpenConsumed(
    HomeScreenEndDrawerOpenConsumed event,
    Emitter<HomeScreenState> emit,
  ) {
    final HomeScreenReady current = _asReady(state);
    emit(current.copyWith(signalOpenEndDrawer: false));
  }

  void _onSearchQueryChanged(
    HomeScreenSearchQueryChanged event,
    Emitter<HomeScreenState> emit,
  ) {
    final HomeScreenReady current = _asReady(state);
    emit(current.copyWith(searchQuery: event.query));
  }

  void _onErrorMessageConsumed(
    HomeScreenErrorMessageConsumed event,
    Emitter<HomeScreenState> emit,
  ) {
    if (state is HomeScreenReady) {
      emit(_asReady(state).copyWith(clearErrorMessage: true));
    }
  }

  void _onSuccessMessageConsumed(
    HomeScreenSuccessMessageConsumed event,
    Emitter<HomeScreenState> emit,
  ) {
    if (state is HomeScreenReady) {
      emit(_asReady(state).copyWith(clearSuccessMessage: true));
    }
  }

  void _onFilterStatusChanged(
    HomeScreenFilterStatusChanged event,
    Emitter<HomeScreenState> emit,
  ) {
    if (state is HomeScreenReady) {
      final current = _asReady(state);
      if (current.activeEndDrawer == HomeScreenEndDrawerKind.filter) {
        emit(current.copyWith(draftStatuses: event.statuses));
      } else {
        emit(current.copyWith(selectedStatuses: event.statuses));
        _syncFiltersToApi(current.copyWith(selectedStatuses: event.statuses));
      }
    }
  }

  void _onFilterProviderChanged(
    HomeScreenFilterProviderChanged event,
    Emitter<HomeScreenState> emit,
  ) {
    if (state is HomeScreenReady) {
      final current = _asReady(state);
      if (current.activeEndDrawer == HomeScreenEndDrawerKind.filter) {
        emit(current.copyWith(draftProviders: event.providers));
      } else {
        emit(current.copyWith(selectedProviders: event.providers));
        _syncFiltersToApi(current.copyWith(selectedProviders: event.providers));
      }
    }
  }

  void _onFilterMedicalAssistantChanged(
    HomeScreenFilterMedicalAssistantChanged event,
    Emitter<HomeScreenState> emit,
  ) {
    if (state is HomeScreenReady) {
      final current = _asReady(state);
      if (current.activeEndDrawer == HomeScreenEndDrawerKind.filter) {
        emit(current.copyWith(draftMedicalAssistants: event.medicalAssistants));
      } else {
        final next = current.copyWith(
          selectedMedicalAssistants: event.medicalAssistants,
        );
        emit(next);
        _syncFiltersToApi(next);
      }
    }
  }

  void _onFilterOfficeLocationChanged(
    HomeScreenFilterOfficeLocationChanged event,
    Emitter<HomeScreenState> emit,
  ) {
    if (state is HomeScreenReady) {
      final current = _asReady(state);
      if (current.activeEndDrawer == HomeScreenEndDrawerKind.filter) {
        emit(current.copyWith(draftOfficeLocations: event.locations));
      } else {
        emit(current.copyWith(selectedOfficeLocations: event.locations));
        _syncFiltersToApi(
          current.copyWith(selectedOfficeLocations: event.locations),
        );
      }
    }
  }

  void _onFilterClearAll(
    HomeScreenFilterClearAll event,
    Emitter<HomeScreenState> emit,
  ) {
    if (state is HomeScreenReady) {
      final current = _asReady(state);
      final DateTime today = todayDateOnly(() => DateTime.now());
      if (current.activeEndDrawer == HomeScreenEndDrawerKind.filter) {
        emit(
          current.copyWith(
            draftStartDate: today,
            draftEndDate: null,
            clearDraftRange: true,
            draftStatuses: [],
            draftProviders: [],
            draftMedicalAssistants: [],
            draftOfficeLocations: [],
            isCalendarVisible: false,
          ),
        );
      } else {
        final next = current.copyWith(
          startDate: today,
          endDate: null,
          clearRange: true,
          displayLabel: _computeDisplayLabel(today, null),
          selectedStatuses: [],
          selectedProviders: [],
          selectedMedicalAssistants: [],
          selectedOfficeLocations: [],
          isCalendarVisible: false,
        );
        emit(next);
        _syncFiltersToApi(next);
      }
    }
  }

  void _onFilterCalendarVisibilityToggled(
    HomeScreenFilterCalendarVisibilityToggled event,
    Emitter<HomeScreenState> emit,
  ) {
    if (state is HomeScreenReady) {
      final HomeScreenReady current = _asReady(state);
      emit(current.copyWith(isCalendarVisible: !current.isCalendarVisible));
    }
  }

  void _onFilterPanelClosed(
    HomeScreenFilterPanelClosed event,
    Emitter<HomeScreenState> emit,
  ) {
    if (state is HomeScreenReady) {
      final current = _asReady(state);
      final next = current.copyWith(
        startDate: current.draftStartDate,
        endDate: current.draftEndDate,
        clearRange: current.draftEndDate == null,
        displayLabel: _computeDisplayLabel(
          current.draftStartDate,
          current.draftEndDate,
        ),
        selectedStatuses: current.draftStatuses,
        selectedProviders: current.draftProviders,
        selectedMedicalAssistants: current.draftMedicalAssistants,
        selectedOfficeLocations: current.draftOfficeLocations,
        clearActiveEndDrawer: true,
      );
      emit(next);
      _syncFiltersToApi(next);
    }
  }

  HomeScreenReady _asReady(HomeScreenState s) {
    return switch (s) {
      HomeScreenReady() => s,
      HomeScreenInitial() => throw StateError('HomeScreen not ready'),
    };
  }

  String _computeDisplayLabel(DateTime? start, DateTime? end) {
    return formatDisplayDate(
      start,
      end,
      now: () => DateTime.now(),
      todayLabel: AppStrings.homeScheduleDateToday,
      yesterdayLabel: AppStrings.homeScheduleDateYesterday,
      tomorrowLabel: AppStrings.homeScheduleDateTomorrow,
    );
  }

  Future<void> _syncFiltersToApi(HomeScreenReady readyState) async {
    final filters = SavedVisitFilters(
      status: readyState.selectedStatuses,
      doctorIds: readyState.selectedProviders.map((p) => p.id).toList(),
      maIds: readyState.selectedMedicalAssistants.map((m) => m.id).toList(),
      locationIds: readyState.selectedOfficeLocations.map((l) => l.id).toList(),
      startDate: readyState.startDate,
      endDate: readyState.endDate,
    );

    try {
      final response = await homeRepository.updateSavedVisitFilters(filters);
      final bool shouldToast = response['toast'] == true;
      final String? message = response['message'] as String?;

      if (!isClosed && shouldToast && message != null && message.isNotEmpty) {
        emit(readyState.copyWith(successMessage: message));
      }
      
      // Refresh visits after syncing filters
      if (!isClosed) {
        add(const HomeScreenCurrentVisitsRequested());
        add(const HomeScreenUpcomingVisitsRequested());
        add(const HomeScreenRecordedVisitsRequested());
      }
    } catch (e) {
      if (!isClosed) {
        emit(readyState.copyWith(errorMessage: e.toString()));
      }
    }
  }

  Future<void> _onCurrentVisitsRequested(
    HomeScreenCurrentVisitsRequested event,
    Emitter<HomeScreenState> emit,
  ) async {
    if (state is! HomeScreenReady) return;
    final currentState = _asReady(state);
    
    final int targetPage = event.isNextPage ? currentState.pageCurrent + 1 : 1;
    if (event.isNextPage && targetPage > currentState.totalPageCurrent) return;

    if (event.isNextPage) {
      emit(currentState.copyWith(isFetchingMoreCurrent: true));
    } else {
      emit(currentState.copyWith(isLoadingVisits: true));
    }

    try {
      final filters = _buildFilters(currentState);
      final response = await homeRepository.getCurrentVisits(
        filters: filters,
        page: targetPage,
      );

      if (!isClosed) {
        final List<VisitModel> updatedList = event.isNextPage 
            ? [...currentState.currentVisits, ...response.data]
            : response.data;
            
        emit(_asReady(state).copyWith(
          currentVisits: updatedList,
          pageCurrent: response.page,
          totalPageCurrent: response.totalPage,
          filteredCountCurrent: response.filteredCount,
          isFetchingMoreCurrent: false,
          isLoadingVisits: false,
        ));
      }
    } catch (e) {
      if (!isClosed) {
        emit(_asReady(state).copyWith(
          errorMessage: e.toString(),
          isFetchingMoreCurrent: false,
          isLoadingVisits: false,
        ));
      }
    }
  }

  Future<void> _onUpcomingVisitsRequested(
    HomeScreenUpcomingVisitsRequested event,
    Emitter<HomeScreenState> emit,
  ) async {
    if (state is! HomeScreenReady) return;
    final currentState = _asReady(state);
    
    final int targetPage = event.isNextPage ? currentState.pageUpcoming + 1 : 1;
    if (event.isNextPage && targetPage > currentState.totalPageUpcoming) return;

    if (event.isNextPage) {
      emit(currentState.copyWith(isFetchingMoreUpcoming: true));
    } else {
      emit(currentState.copyWith(isLoadingVisits: true));
    }

    try {
      final filters = _buildFilters(currentState);
      final response = await homeRepository.getUpcomingVisits(
        filters: filters,
        page: targetPage,
      );

      if (!isClosed) {
        final List<VisitModel> updatedList = event.isNextPage 
            ? [...currentState.upcomingVisits, ...response.data]
            : response.data;
            
        emit(_asReady(state).copyWith(
          upcomingVisits: updatedList,
          pageUpcoming: response.page,
          totalPageUpcoming: response.totalPage,
          filteredCountUpcoming: response.filteredCount,
          isFetchingMoreUpcoming: false,
          isLoadingVisits: false,
        ));
      }
    } catch (e) {
      if (!isClosed) {
        emit(_asReady(state).copyWith(
          errorMessage: e.toString(),
          isFetchingMoreUpcoming: false,
          isLoadingVisits: false,
        ));
      }
    }
  }

  Future<void> _onRecordedVisitsRequested(
    HomeScreenRecordedVisitsRequested event,
    Emitter<HomeScreenState> emit,
  ) async {
    if (state is! HomeScreenReady) return;
    final currentState = _asReady(state);
    
    final int targetPage = event.isNextPage ? currentState.pageRecorded + 1 : 1;
    if (event.isNextPage && targetPage > currentState.totalPageRecorded) return;

    if (event.isNextPage) {
      emit(currentState.copyWith(isFetchingMoreRecorded: true));
    } else {
      emit(currentState.copyWith(isLoadingVisits: true));
    }

    try {
      final filters = _buildFilters(currentState);
      final response = await homeRepository.getRecordedVisits(
        filters: filters,
        page: targetPage,
      );

      if (!isClosed) {
        final List<VisitModel> updatedList = event.isNextPage 
            ? [...currentState.recordedVisits, ...response.data]
            : response.data;
            
        emit(_asReady(state).copyWith(
          recordedVisits: updatedList,
          pageRecorded: response.page,
          totalPageRecorded: response.totalPage,
          filteredCountRecorded: response.filteredCount,
          isFetchingMoreRecorded: false,
          isLoadingVisits: false,
        ));
      }
    } catch (e) {
      if (!isClosed) {
        emit(_asReady(state).copyWith(
          errorMessage: e.toString(),
          isFetchingMoreRecorded: false,
          isLoadingVisits: false,
        ));
      }
    }
  }

  SavedVisitFilters _buildFilters(HomeScreenReady readyState) {
    return SavedVisitFilters(
      status: readyState.selectedStatuses,
      doctorIds: readyState.selectedProviders.map((p) => p.id).toList(),
      maIds: readyState.selectedMedicalAssistants.map((m) => m.id).toList(),
      locationIds: readyState.selectedOfficeLocations.map((l) => l.id).toList(),
      startDate: readyState.startDate,
      endDate: readyState.endDate,
    );
  }
}
