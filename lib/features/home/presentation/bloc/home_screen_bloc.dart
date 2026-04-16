import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:subqdocs_bloc/core/constants/app_strings.dart';
import 'package:subqdocs_bloc/core/models/country_option.dart';
import 'package:subqdocs_bloc/core/services/api_exceptions.dart';
import 'package:subqdocs_bloc/core/services/app_preferences.dart';
import 'package:subqdocs_bloc/data/models/login_model.dart';
import 'package:subqdocs_bloc/data/models/office_location_model.dart';
import 'package:subqdocs_bloc/data/models/staff_model.dart';
import 'package:subqdocs_bloc/data/models/visit_type_model.dart';
import 'package:subqdocs_bloc/data/models/visit_model.dart';
import 'package:subqdocs_bloc/features/home/domain/home_date_display.dart';
import 'package:subqdocs_bloc/features/home/domain/models/schedule_visit_address_suggestion.dart';
import 'package:subqdocs_bloc/features/home/domain/models/saved_visit_filters.dart';
import 'package:subqdocs_bloc/features/home/domain/repositories/home_repository.dart';
import 'package:subqdocs_bloc/features/patients/data/patient_list_row.dart';
import 'package:subqdocs_bloc/features/patients/data/patients_list_api_envelope.dart';

import '../../../../core/constants/app_preferences_keys.dart';

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
    on<HomeScreenFilterMedicalAssistantChanged>(_onFilterMedicalAssistantChanged);
    on<HomeScreenFilterOfficeLocationChanged>(_onFilterOfficeLocationChanged);
    on<HomeScreenFilterClearAll>(_onFilterClearAll);
    on<HomeScreenFilterCalendarVisibilityToggled>(_onFilterCalendarVisibilityToggled);
    on<HomeScreenFilterPanelClosed>(_onFilterPanelClosed);
    on<HomeScreenSuccessMessageConsumed>(_onSuccessMessageConsumed);
    on<HomeScreenCurrentVisitsRequested>(_onCurrentVisitsRequested);
    on<HomeScreenUpcomingVisitsRequested>(_onUpcomingVisitsRequested);
    on<HomeScreenRecordedVisitsRequested>(_onRecordedVisitsRequested);
    on<HomeScreenScheduleVisitPatientDropdownOpened>(_onScheduleVisitPatientDropdownOpened);
    on<HomeScreenScheduleVisitPatientDropdownClosed>(_onScheduleVisitPatientDropdownClosed);
    on<HomeScreenScheduleVisitPatientSearchChanged>(_onScheduleVisitPatientSearchChanged);
    on<HomeScreenScheduleVisitPatientSearchDebounced>(_onScheduleVisitPatientSearchDebounced);
    on<HomeScreenScheduleVisitPatientSuggestionsRequested>(_onScheduleVisitPatientSuggestionsRequested);
    on<HomeScreenScheduleVisitAddPatientSelected>(_onScheduleVisitAddPatientSelected);
    on<HomeScreenScheduleVisitSearchExistingPatientSelected>(_onScheduleVisitSearchExistingPatientSelected);
    on<HomeScreenScheduleVisitPatientSelected>(_onScheduleVisitPatientSelected);
    on<HomeScreenScheduleVisitFirstNameChanged>(_onScheduleVisitFirstNameChanged);
    on<HomeScreenScheduleVisitLastNameChanged>(_onScheduleVisitLastNameChanged);
    on<HomeScreenScheduleVisitOfficeLocationChanged>(_onScheduleVisitOfficeLocationChanged);
    on<HomeScreenScheduleVisitProviderChanged>(_onScheduleVisitProviderChanged);
    on<HomeScreenScheduleVisitDateChanged>(_onScheduleVisitDateChanged);
    on<HomeScreenScheduleVisitTimeChanged>(_onScheduleVisitTimeChanged);
    on<HomeScreenScheduleVisitTypeChanged>(_onScheduleVisitTypeChanged);
    on<HomeScreenScheduleVisitNoteChanged>(_onScheduleVisitNoteChanged);
    on<HomeScreenScheduleVisitPaymentMethodChanged>(_onScheduleVisitPaymentMethodChanged);
    on<HomeScreenScheduleVisitReasonChanged>(_onScheduleVisitReasonChanged);
    on<HomeScreenScheduleVisitGender>(_onScheduleVisitGender);
    on<HomeScreenScheduleVisitDateOfBirthChanged>(_onScheduleVisitDateOfBirthChanged);
    on<HomeScreenScheduleVisitCountryChanged>(_onScheduleVisitCountryChanged);
    on<HomeScreenScheduleVisitStreetAddressChanged>(_onScheduleVisitStreetAddressChanged);
    on<HomeScreenScheduleVisitStreetAddressSuggestionsRequested>(_onScheduleVisitStreetAddressSuggestionsRequested);
    on<HomeScreenScheduleVisitStreetAddressSelected>(_onScheduleVisitStreetAddressSelected);
    on<HomeScreenScheduleVisitPhoneCountryChanged>(_onScheduleVisitPhoneCountryChanged);
    on<HomeScreenScheduleVisitPhoneNumberChanged>(_onScheduleVisitPhoneNumberChanged);
  }

  final HomeRepository homeRepository;
  Timer? _scheduleVisitSearchDebounceTimer;
  static const int _scheduleVisitPatientSearchLimit = 15;

  @override
  Future<void> close() {
    _scheduleVisitSearchDebounceTimer?.cancel();
    return super.close();
  }

  Future<void> _onStarted(HomeScreenStarted event, Emitter<HomeScreenState> emit) async {
    final DateTime today = todayDateOnly(() => DateTime.now());
    emit(HomeScreenReady(startDate: today, endDate: null, displayLabel: _computeDisplayLabel(today, null), isLoadingOrganization: true, isLoadingVisits: true));

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
      final List<StaffModel> selectedProviders = savedFilters.doctorIds.map((id) => allProviders.firstWhere((p) => p.id == id)).toList();
      final List<StaffModel> selectedMAs = savedFilters.maIds.map((id) => allMAs.firstWhere((m) => m.id == id)).toList();
      final List<OfficeLocationModel> selectedLocations = savedFilters.locationIds.map((id) => allLocations.firstWhere((l) => l.id == id)).toList();

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
        emit(_asReady(state).copyWith(isLoadingOrganization: false, errorMessage: e.toString()));
      }
    }
  }

  void _onDateForward(HomeScreenDateForward event, Emitter<HomeScreenState> emit) {
    final HomeScreenReady current = _asReady(state);
    final DateTime anchor = current.endDate ?? current.startDate ?? todayDateOnly(() => DateTime.now());
    final DateTime next = DateTime(anchor.year, anchor.month, anchor.day).add(const Duration(days: 1));
    final DateTime nextDay = DateTime(next.year, next.month, next.day);
    emit(current.copyWith(startDate: nextDay, endDate: null, clearRange: true, displayLabel: _computeDisplayLabel(nextDay, null)));
  }

  void _onDateBackward(HomeScreenDateBackward event, Emitter<HomeScreenState> emit) {
    final HomeScreenReady current = _asReady(state);
    final DateTime anchor = current.startDate ?? todayDateOnly(() => DateTime.now());
    final DateTime prev = DateTime(anchor.year, anchor.month, anchor.day).subtract(const Duration(days: 1));
    final DateTime prevDay = DateTime(prev.year, prev.month, prev.day);
    emit(current.copyWith(startDate: prevDay, endDate: null, clearRange: true, displayLabel: _computeDisplayLabel(prevDay, null)));
  }

  void _onDateSelected(HomeScreenDateSelected event, Emitter<HomeScreenState> emit) {
    if (state is! HomeScreenReady) return;
    final HomeScreenReady current = _asReady(state);
    final DateTime start = DateTime(event.start.year, event.start.month, event.start.day);
    final DateTime? end = event.end != null ? DateTime(event.end!.year, event.end!.month, event.end!.day) : null;

    if (current.activeEndDrawer == HomeScreenEndDrawerKind.filter) {
      emit(current.copyWith(draftStartDate: start, draftEndDate: end, clearDraftRange: end == null));
    } else {
      emit(current.copyWith(startDate: start, endDate: end, clearRange: end == null, displayLabel: _computeDisplayLabel(start, end)));
    }
  }

  void _onFilterPanelOpened(HomeScreenFilterPanelOpened event, Emitter<HomeScreenState> emit) {
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

  void _onScheduleVisitOpened(HomeScreenScheduleVisitOpened event, Emitter<HomeScreenState> emit) {
    final HomeScreenReady current = _asReady(state);

    // Default Date and Time
    final now = DateTime.now();
    final today = todayDateOnly(() => now);
    final nextRoundedTime = _roundToNext15Minutes(now);

    // Default Provider (matched from loginResponse via user id)
    StaffModel? defaultProvider;
    OfficeLocationModel? defaultLocation;
    try {
      final loginResponseRaw = AppPreferences.instance.getStringSync(AppPreferencesKeys.loginResponse);
      if (loginResponseRaw != null) {
        final loginModel = loginModelFromJson(loginResponseRaw);
        final userId = loginModel.responseData?.user?.id;
        if (userId != null) {
          // Find provider with matching user id.
          // Note: getUsersByRole('Doctor') might not have been called yet if we are opening from fresh state.
          // But usually, allProviders is populated in the initial HomeScreenStarted.
          defaultProvider = current.allProviders.where((p) => p.id == userId).firstOrNull;
        }

        final officeLocationIds = loginModel.responseData?.user?.officeLocationIds;
        if (officeLocationIds != null && officeLocationIds.isNotEmpty) {
          defaultLocation = current.allOfficeLocations.where((l) => l.id == officeLocationIds.first).firstOrNull;
        }

        // Fallback: If no officeLocationIds found or didn't match, pick the primary office
        if (defaultLocation == null) {
          defaultLocation = current.allOfficeLocations.where((l) => l.primaryOffice == true).firstOrNull;
        }
      }
    } catch (_) {
      // Fallback
    }

    // Default Visit Type
    VisitTypeModel? defaultVisitType = current.allVisitTypes.where((v) => v.isDefault == true).firstOrNull;

    emit(
      current.copyWith(
        activeEndDrawer: HomeScreenEndDrawerKind.scheduleVisit,
        signalOpenEndDrawer: true,
        scheduleVisitPatientSearchQuery: '',
        scheduleVisitPatientResults: const <PatientListRow>[],
        scheduleVisitIsPatientSearchLoading: false,
        scheduleVisitShowPatientDropdown: false,
        scheduleVisitIsAddingPatient: false,
        clearScheduleVisitSelectedPatient: true,
        scheduleVisitFirstName: '',
        scheduleVisitLastName: '',
        scheduleVisitOfficeLocation: defaultLocation,
        clearScheduleVisitOfficeLocation: defaultLocation == null,
        scheduleVisitProvider: defaultProvider,
        clearScheduleVisitProvider: defaultProvider == null,
        scheduleVisitDate: today,
        scheduleVisitTime: nextRoundedTime,
        scheduleVisitType: defaultVisitType,
        clearScheduleVisitType: defaultVisitType == null,
        scheduleVisitNote: '',
        scheduleVisitPaymentMethod: null,
        clearScheduleVisitPaymentMethod: true,
        scheduleVisitReason: null,
        clearScheduleVisitReason: true,
        scheduleVisitGender: AppStrings.scheduleVisitGenderUndeclared,
        clearDateOfBirth: true,
        scheduleVisitCountry: CountryOption.unitedStates,
        scheduleVisitStreetAddress: '',
        scheduleVisitCity: '',
        scheduleVisitStateProvince: '',
        scheduleVisitPostalCode: '',
        scheduleVisitPhoneCountry: CountryOption.unitedStates,
        scheduleVisitPhoneNumber: '',
      ),
    );
  }

  DateTime _roundToNext15Minutes(DateTime dt) {
    final int minutes = dt.minute;
    if (minutes % 15 == 0) return dt.copyWith(second: 0, millisecond: 0);

    final int next15 = ((minutes / 15).floor() + 1) * 15;
    if (next15 >= 60) {
      return dt.add(const Duration(hours: 1)).copyWith(minute: 0, second: 0, millisecond: 0);
    }
    return dt.copyWith(minute: next15, second: 0, millisecond: 0);
  }

  void _onEndDrawerOpenConsumed(HomeScreenEndDrawerOpenConsumed event, Emitter<HomeScreenState> emit) {
    final HomeScreenReady current = _asReady(state);
    emit(current.copyWith(signalOpenEndDrawer: false));
  }

  void _onSearchQueryChanged(HomeScreenSearchQueryChanged event, Emitter<HomeScreenState> emit) {
    final HomeScreenReady current = _asReady(state);
    emit(current.copyWith(searchQuery: event.query));
  }

  void _onErrorMessageConsumed(HomeScreenErrorMessageConsumed event, Emitter<HomeScreenState> emit) {
    if (state is HomeScreenReady) {
      emit(_asReady(state).copyWith(clearErrorMessage: true));
    }
  }

  void _onSuccessMessageConsumed(HomeScreenSuccessMessageConsumed event, Emitter<HomeScreenState> emit) {
    if (state is HomeScreenReady) {
      emit(_asReady(state).copyWith(clearSuccessMessage: true));
    }
  }

  void _onScheduleVisitPatientDropdownOpened(HomeScreenScheduleVisitPatientDropdownOpened event, Emitter<HomeScreenState> emit) {
    final HomeScreenReady current = _asReady(state);
    emit(current.copyWith(scheduleVisitShowPatientDropdown: true));
  }

  void _onScheduleVisitPatientDropdownClosed(HomeScreenScheduleVisitPatientDropdownClosed event, Emitter<HomeScreenState> emit) {
    final HomeScreenReady current = _asReady(state);
    emit(current.copyWith(scheduleVisitShowPatientDropdown: false));
  }

  void _onScheduleVisitPatientSearchChanged(HomeScreenScheduleVisitPatientSearchChanged event, Emitter<HomeScreenState> emit) {
    final HomeScreenReady current = _asReady(state);
    _scheduleVisitSearchDebounceTimer?.cancel();

    final String query = event.query.trimLeft();
    emit(
      current.copyWith(
        scheduleVisitPatientSearchQuery: query,
        scheduleVisitShowPatientDropdown: query.trim().isNotEmpty,
        clearScheduleVisitSelectedPatient: true,
        scheduleVisitIsPatientSearchLoading: false,
        scheduleVisitPatientResults: const <PatientListRow>[],
      ),
    );
  }

  Future<void> _onScheduleVisitPatientSearchDebounced(HomeScreenScheduleVisitPatientSearchDebounced event, Emitter<HomeScreenState> emit) async {
    if (!isClosed && state is HomeScreenReady) {
      emit(_asReady(state).copyWith(scheduleVisitIsPatientSearchLoading: false, scheduleVisitPatientResults: const <PatientListRow>[]));
    }
  }

  Future<void> _onScheduleVisitPatientSuggestionsRequested(HomeScreenScheduleVisitPatientSuggestionsRequested event, Emitter<HomeScreenState> emit) async {
    final String query = event.query.trim();
    if (query.isEmpty) {
      event.completer.complete(const <PatientListRow>[]);
      return;
    }

    try {
      final PatientsListApiEnvelope envelope = await homeRepository.fetchPatients(page: 1, limit: _scheduleVisitPatientSearchLimit, search: query);
      if (isClosed) {
        if (!event.completer.isCompleted) {
          event.completer.complete(const <PatientListRow>[]);
        }
        return;
      }

      final bool isSuccess = (envelope.responseType ?? '').trim().toLowerCase() == 'success';
      if (isSuccess) {
        event.completer.complete(envelope.responseData?.rows ?? const <PatientListRow>[]);
        return;
      }

      if (!event.completer.isCompleted) {
        event.completer.complete(const <PatientListRow>[]);
      }
      emit(_asReady(state).copyWith(errorMessage: (envelope.message ?? '').trim().isNotEmpty ? envelope.message!.trim() : AppStrings.scheduleVisitPatientSearchFailure));
    } on ApiException catch (e) {
      if (!event.completer.isCompleted) {
        event.completer.complete(const <PatientListRow>[]);
      }
      if (isClosed) {
        return;
      }
      emit(_asReady(state).copyWith(errorMessage: e.message.trim().isNotEmpty ? e.message.trim() : AppStrings.scheduleVisitStreetAddressSearchFailure));
    } catch (_) {
      if (!event.completer.isCompleted) {
        event.completer.complete(const <PatientListRow>[]);
      }
      if (isClosed) {
        return;
      }
      emit(_asReady(state).copyWith(errorMessage: AppStrings.scheduleVisitPatientSearchFailure));
    }
  }

  void _onScheduleVisitAddPatientSelected(HomeScreenScheduleVisitAddPatientSelected event, Emitter<HomeScreenState> emit) {
    final HomeScreenReady current = _asReady(state);
    _scheduleVisitSearchDebounceTimer?.cancel();

    String firstName = '';
    String lastName = '';
    final query = current.scheduleVisitPatientSearchQuery.trim();
    if (query.isNotEmpty) {
      final parts = query.split(RegExp(r'\s+'));
      if (parts.isNotEmpty) {
        firstName = parts.first;
        if (parts.length > 1) {
          lastName = parts.last;
        }
      }
    }

    emit(
      current.copyWith(
        scheduleVisitIsAddingPatient: true,
        scheduleVisitShowPatientDropdown: false,
        scheduleVisitPatientSearchQuery: '',
        scheduleVisitPatientResults: const <PatientListRow>[],
        scheduleVisitIsPatientSearchLoading: false,
        clearScheduleVisitSelectedPatient: true,
        scheduleVisitFirstName: firstName,
        scheduleVisitLastName: lastName,
      ),
    );
  }

  void _onScheduleVisitSearchExistingPatientSelected(HomeScreenScheduleVisitSearchExistingPatientSelected event, Emitter<HomeScreenState> emit) {
    final HomeScreenReady current = _asReady(state);
    emit(current.copyWith(scheduleVisitIsAddingPatient: false, scheduleVisitShowPatientDropdown: false, scheduleVisitFirstName: '', scheduleVisitLastName: ''));
  }

  void _onScheduleVisitPatientSelected(HomeScreenScheduleVisitPatientSelected event, Emitter<HomeScreenState> emit) {
    final HomeScreenReady current = _asReady(state);
    _scheduleVisitSearchDebounceTimer?.cancel();
    OfficeLocationModel? newLocation = current.scheduleVisitOfficeLocation;
    bool clearLocation = false;

    if (event.patient.officeLocationId != null) {
      final matchedLocation = current.allOfficeLocations.where((l) => l.id == event.patient.officeLocationId).firstOrNull;
      if (matchedLocation != null) {
        newLocation = matchedLocation;
      }
    }

    emit(
      current.copyWith(
        scheduleVisitSelectedPatient: event.patient,
        scheduleVisitPatientSearchQuery: event.patient.fullName,
        scheduleVisitShowPatientDropdown: false,
        scheduleVisitIsPatientSearchLoading: false,
        scheduleVisitOfficeLocation: newLocation,
        clearScheduleVisitOfficeLocation: clearLocation,
      ),
    );
  }

  void _onScheduleVisitFirstNameChanged(HomeScreenScheduleVisitFirstNameChanged event, Emitter<HomeScreenState> emit) {
    emit(_asReady(state).copyWith(scheduleVisitFirstName: event.value));
  }

  void _onScheduleVisitLastNameChanged(HomeScreenScheduleVisitLastNameChanged event, Emitter<HomeScreenState> emit) {
    emit(_asReady(state).copyWith(scheduleVisitLastName: event.value));
  }

  void _onScheduleVisitCountryChanged(HomeScreenScheduleVisitCountryChanged event, Emitter<HomeScreenState> emit) {
    emit(_asReady(state).copyWith(scheduleVisitCountry: event.country, scheduleVisitStreetAddress: '', scheduleVisitCity: '', scheduleVisitStateProvince: '', scheduleVisitPostalCode: ''));
  }

  void _onScheduleVisitStreetAddressChanged(HomeScreenScheduleVisitStreetAddressChanged event, Emitter<HomeScreenState> emit) {
    emit(
      _asReady(state).copyWith(
        scheduleVisitStreetAddress: event.value,
        scheduleVisitCity: event.value.trim().isEmpty ? '' : _asReady(state).scheduleVisitCity,
        scheduleVisitStateProvince: event.value.trim().isEmpty ? '' : _asReady(state).scheduleVisitStateProvince,
        scheduleVisitPostalCode: event.value.trim().isEmpty ? '' : _asReady(state).scheduleVisitPostalCode,
      ),
    );
  }

  Future<void> _onScheduleVisitStreetAddressSuggestionsRequested(HomeScreenScheduleVisitStreetAddressSuggestionsRequested event, Emitter<HomeScreenState> emit) async {
    final String query = event.query.trim();
    if (query.isEmpty) {
      event.completer.complete(const <ScheduleVisitAddressSuggestion>[]);
      return;
    }

    try {
      final List<ScheduleVisitAddressSuggestion> suggestions = await homeRepository.fetchStreetAddressSuggestions(search: query, country: event.country);
      if (!event.completer.isCompleted) {
        event.completer.complete(suggestions);
      }
    } on ApiException catch (e) {
      if (!event.completer.isCompleted) {
        event.completer.complete(const <ScheduleVisitAddressSuggestion>[]);
      }
      if (isClosed) {
        return;
      }
      emit(_asReady(state).copyWith(errorMessage: e.message.trim().isNotEmpty ? e.message.trim() : AppStrings.scheduleVisitPatientSearchFailure));
    } catch (_) {
      if (!event.completer.isCompleted) {
        event.completer.complete(const <ScheduleVisitAddressSuggestion>[]);
      }
      if (isClosed) {
        return;
      }
      emit(_asReady(state).copyWith(errorMessage: AppStrings.scheduleVisitStreetAddressSearchFailure));
    }
  }

  Future<void> _onScheduleVisitStreetAddressSelected(HomeScreenScheduleVisitStreetAddressSelected event, Emitter<HomeScreenState> emit) async {
    final HomeScreenReady current = _asReady(state);
    emit(current.copyWith(scheduleVisitStreetAddress: event.suggestion.description));

    try {
      final ScheduleVisitAddressDetails details = await homeRepository.fetchStreetAddressDetails(placeId: event.suggestion.placeId);
      if (isClosed) {
        return;
      }
      emit(
        _asReady(state).copyWith(
          scheduleVisitStreetAddress: details.streetAddress.isNotEmpty ? details.streetAddress : event.suggestion.description,
          scheduleVisitCity: details.city,
          scheduleVisitStateProvince: details.state,
          scheduleVisitPostalCode: details.postalCode,
        ),
      );
    } on ApiException catch (e) {
      if (isClosed) {
        return;
      }
      emit(_asReady(state).copyWith(errorMessage: e.message.trim().isNotEmpty ? e.message.trim() : AppStrings.scheduleVisitStreetAddressSearchFailure));
    } catch (_) {
      if (isClosed) {
        return;
      }
      emit(_asReady(state).copyWith(errorMessage: AppStrings.scheduleVisitStreetAddressSearchFailure));
    }
  }

  void _onScheduleVisitPhoneCountryChanged(HomeScreenScheduleVisitPhoneCountryChanged event, Emitter<HomeScreenState> emit) {
    emit(_asReady(state).copyWith(scheduleVisitPhoneCountry: event.country));
  }

  void _onScheduleVisitPhoneNumberChanged(HomeScreenScheduleVisitPhoneNumberChanged event, Emitter<HomeScreenState> emit) {
    emit(_asReady(state).copyWith(scheduleVisitPhoneNumber: event.value));
  }

  void _onScheduleVisitOfficeLocationChanged(HomeScreenScheduleVisitOfficeLocationChanged event, Emitter<HomeScreenState> emit) {
    emit(_asReady(state).copyWith(scheduleVisitOfficeLocation: event.location, clearScheduleVisitOfficeLocation: event.location == null));
  }

  void _onScheduleVisitProviderChanged(HomeScreenScheduleVisitProviderChanged event, Emitter<HomeScreenState> emit) {
    emit(_asReady(state).copyWith(scheduleVisitProvider: event.provider, clearScheduleVisitProvider: event.provider == null));
  }

  void _onScheduleVisitDateChanged(HomeScreenScheduleVisitDateChanged event, Emitter<HomeScreenState> emit) {
    emit(_asReady(state).copyWith(scheduleVisitDate: event.date, clearScheduleVisitDate: event.date == null));
  }

  void _onScheduleVisitTimeChanged(HomeScreenScheduleVisitTimeChanged event, Emitter<HomeScreenState> emit) {
    emit(_asReady(state).copyWith(scheduleVisitTime: event.time, clearScheduleVisitTime: event.time == null));
  }

  void _onScheduleVisitTypeChanged(HomeScreenScheduleVisitTypeChanged event, Emitter<HomeScreenState> emit) {
    emit(_asReady(state).copyWith(scheduleVisitType: event.visitType, clearScheduleVisitType: event.visitType == null));
  }

  void _onScheduleVisitNoteChanged(HomeScreenScheduleVisitNoteChanged event, Emitter<HomeScreenState> emit) {
    emit(_asReady(state).copyWith(scheduleVisitNote: event.note));
  }

  void _onScheduleVisitPaymentMethodChanged(HomeScreenScheduleVisitPaymentMethodChanged event, Emitter<HomeScreenState> emit) {
    emit(_asReady(state).copyWith(scheduleVisitPaymentMethod: event.method, clearScheduleVisitPaymentMethod: event.method == null));
  }

  void _onScheduleVisitReasonChanged(HomeScreenScheduleVisitReasonChanged event, Emitter<HomeScreenState> emit) {
    emit(_asReady(state).copyWith(scheduleVisitReason: event.reason, clearScheduleVisitReason: event.reason == null));
  }

  void _onFilterStatusChanged(HomeScreenFilterStatusChanged event, Emitter<HomeScreenState> emit) {
    if (state is HomeScreenReady) {
      final current = _asReady(state);
      if (current.activeEndDrawer == HomeScreenEndDrawerKind.filter) {
        emit(current.copyWith(draftStatuses: event.statuses));
      } else {
        emit(current.copyWith(selectedStatuses: event.statuses));
        _syncFiltersToApi(current.copyWith(selectedStatuses: event.statuses), emit);
      }
    }
  }

  void _onFilterProviderChanged(HomeScreenFilterProviderChanged event, Emitter<HomeScreenState> emit) {
    if (state is HomeScreenReady) {
      final current = _asReady(state);
      if (current.activeEndDrawer == HomeScreenEndDrawerKind.filter) {
        emit(current.copyWith(draftProviders: event.providers));
      } else {
        emit(current.copyWith(selectedProviders: event.providers));
        _syncFiltersToApi(current.copyWith(selectedProviders: event.providers), emit);
      }
    }
  }

  void _onFilterMedicalAssistantChanged(HomeScreenFilterMedicalAssistantChanged event, Emitter<HomeScreenState> emit) {
    if (state is HomeScreenReady) {
      final current = _asReady(state);
      if (current.activeEndDrawer == HomeScreenEndDrawerKind.filter) {
        emit(current.copyWith(draftMedicalAssistants: event.medicalAssistants));
      } else {
        final next = current.copyWith(selectedMedicalAssistants: event.medicalAssistants);
        emit(next);
        _syncFiltersToApi(next, emit);
      }
    }
  }

  void _onFilterOfficeLocationChanged(HomeScreenFilterOfficeLocationChanged event, Emitter<HomeScreenState> emit) {
    if (state is HomeScreenReady) {
      final current = _asReady(state);
      if (current.activeEndDrawer == HomeScreenEndDrawerKind.filter) {
        emit(current.copyWith(draftOfficeLocations: event.locations));
      } else {
        emit(current.copyWith(selectedOfficeLocations: event.locations));
        _syncFiltersToApi(current.copyWith(selectedOfficeLocations: event.locations), emit);
      }
    }
  }

  void _onFilterClearAll(HomeScreenFilterClearAll event, Emitter<HomeScreenState> emit) {
    if (state is HomeScreenReady) {
      final current = _asReady(state);
      final DateTime today = todayDateOnly(() => DateTime.now());
      if (current.activeEndDrawer == HomeScreenEndDrawerKind.filter) {
        emit(current.copyWith(draftStartDate: today, draftEndDate: null, clearDraftRange: true, draftStatuses: [], draftProviders: [], draftMedicalAssistants: [], draftOfficeLocations: [], isCalendarVisible: false));
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
        _syncFiltersToApi(next, emit);
      }
    }
  }

  void _onFilterCalendarVisibilityToggled(HomeScreenFilterCalendarVisibilityToggled event, Emitter<HomeScreenState> emit) {
    if (state is HomeScreenReady) {
      final HomeScreenReady current = _asReady(state);
      emit(current.copyWith(isCalendarVisible: !current.isCalendarVisible));
    }
  }

  void _onFilterPanelClosed(HomeScreenFilterPanelClosed event, Emitter<HomeScreenState> emit) {
    if (state is HomeScreenReady) {
      final current = _asReady(state);
      final next = current.copyWith(
        startDate: current.draftStartDate,
        endDate: current.draftEndDate,
        clearRange: current.draftEndDate == null,
        displayLabel: _computeDisplayLabel(current.draftStartDate, current.draftEndDate),
        selectedStatuses: current.draftStatuses,
        selectedProviders: current.draftProviders,
        selectedMedicalAssistants: current.draftMedicalAssistants,
        selectedOfficeLocations: current.draftOfficeLocations,
        clearActiveEndDrawer: true,
      );
      emit(next);
      _syncFiltersToApi(next, emit);
    }
  }

  HomeScreenReady _asReady(HomeScreenState s) {
    return switch (s) {
      HomeScreenReady() => s,
      HomeScreenInitial() => throw StateError('HomeScreen not ready'),
    };
  }

  String _computeDisplayLabel(DateTime? start, DateTime? end) {
    return formatDisplayDate(start, end, now: () => DateTime.now(), todayLabel: AppStrings.homeScheduleDateToday, yesterdayLabel: AppStrings.homeScheduleDateYesterday, tomorrowLabel: AppStrings.homeScheduleDateTomorrow);
  }

  Future<void> _syncFiltersToApi(HomeScreenReady readyState, Emitter<HomeScreenState> emit) async {
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

  Future<void> _onCurrentVisitsRequested(HomeScreenCurrentVisitsRequested event, Emitter<HomeScreenState> emit) async {
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
      final response = await homeRepository.getCurrentVisits(filters: filters, page: targetPage);

      if (!isClosed) {
        final List<VisitModel> updatedList = event.isNextPage ? [...currentState.currentVisits, ...response.data] : response.data;

        emit(
          _asReady(
            state,
          ).copyWith(currentVisits: updatedList, pageCurrent: response.page, totalPageCurrent: response.totalPage, filteredCountCurrent: response.filteredCount, isFetchingMoreCurrent: false, isLoadingVisits: false),
        );
      }
    } catch (e) {
      if (!isClosed) {
        emit(_asReady(state).copyWith(errorMessage: e.toString(), isFetchingMoreCurrent: false, isLoadingVisits: false));
      }
    }
  }

  Future<void> _onUpcomingVisitsRequested(HomeScreenUpcomingVisitsRequested event, Emitter<HomeScreenState> emit) async {
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
      final response = await homeRepository.getUpcomingVisits(filters: filters, page: targetPage);

      if (!isClosed) {
        final List<VisitModel> updatedList = event.isNextPage ? [...currentState.upcomingVisits, ...response.data] : response.data;

        emit(
          _asReady(
            state,
          ).copyWith(upcomingVisits: updatedList, pageUpcoming: response.page, totalPageUpcoming: response.totalPage, filteredCountUpcoming: response.filteredCount, isFetchingMoreUpcoming: false, isLoadingVisits: false),
        );
      }
    } catch (e) {
      if (!isClosed) {
        emit(_asReady(state).copyWith(errorMessage: e.toString(), isFetchingMoreUpcoming: false, isLoadingVisits: false));
      }
    }
  }

  Future<void> _onRecordedVisitsRequested(HomeScreenRecordedVisitsRequested event, Emitter<HomeScreenState> emit) async {
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
      final response = await homeRepository.getRecordedVisits(filters: filters, page: targetPage);

      if (!isClosed) {
        final List<VisitModel> updatedList = event.isNextPage ? [...currentState.recordedVisits, ...response.data] : response.data;

        emit(
          _asReady(
            state,
          ).copyWith(recordedVisits: updatedList, pageRecorded: response.page, totalPageRecorded: response.totalPage, filteredCountRecorded: response.filteredCount, isFetchingMoreRecorded: false, isLoadingVisits: false),
        );
      }
    } catch (e) {
      if (!isClosed) {
        emit(_asReady(state).copyWith(errorMessage: e.toString(), isFetchingMoreRecorded: false, isLoadingVisits: false));
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

  FutureOr<void> _onScheduleVisitGender(HomeScreenScheduleVisitGender event, Emitter<HomeScreenState> emit) {
    emit(_asReady(state).copyWith(scheduleVisitGender: event.gender));
  }

  FutureOr<void> _onScheduleVisitDateOfBirthChanged(HomeScreenScheduleVisitDateOfBirthChanged event, Emitter<HomeScreenState> emit) {
    emit(_asReady(state).copyWith(dateOfBirth: event.date));
  }
}
