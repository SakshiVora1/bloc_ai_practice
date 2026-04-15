part of 'home_screen_bloc.dart';

enum HomeScreenEndDrawerKind { filter, scheduleVisit }

@immutable
sealed class HomeScreenState {
  const HomeScreenState();
}

final class HomeScreenInitial extends HomeScreenState {
  const HomeScreenInitial();
}

final class HomeScreenReady extends HomeScreenState {
  final DateTime? startDate;
  final DateTime? endDate;
  final String displayLabel;
  final HomeScreenEndDrawerKind? activeEndDrawer;
  final bool signalOpenEndDrawer;
  final String searchQuery;
  final bool isLoadingOrganization;
  final bool isLoadingVisits;
  final String? errorMessage;
  final String? successMessage;
  final List<String> selectedStatuses;
  final List<StaffModel> selectedProviders;
  final List<StaffModel> selectedMedicalAssistants;
  final List<OfficeLocationModel> selectedOfficeLocations;
  final bool isCalendarVisible;

  // Visit lists
  final List<VisitModel> currentVisits;
  final List<VisitModel> upcomingVisits;
  final List<VisitModel> recordedVisits;

  // Per-section pagination
  final int pageCurrent;
  final int totalPageCurrent;
  final bool isFetchingMoreCurrent;

  final int pageUpcoming;
  final int totalPageUpcoming;
  final bool isFetchingMoreUpcoming;

  final int pageRecorded;
  final int totalPageRecorded;
  final bool isFetchingMoreRecorded;

  // Filtered counts (from API response)
  final int filteredCountCurrent;
  final int filteredCountUpcoming;
  final int filteredCountRecorded;

  // Source lists (local storage for dropdowns)
  final List<StaffModel> allProviders;
  final List<StaffModel> allMedicalAssistants;
  final List<OfficeLocationModel> allOfficeLocations;
  final List<VisitTypeModel> allVisitTypes;

  // Draft filters (staged in drawer)
  final DateTime? draftStartDate;
  final DateTime? draftEndDate;
  final List<String> draftStatuses;
  final List<StaffModel> draftProviders;
  final List<StaffModel> draftMedicalAssistants;
  final List<OfficeLocationModel> draftOfficeLocations;
  final String scheduleVisitPatientSearchQuery;
  final bool scheduleVisitIsPatientSearchLoading;
  final List<PatientListRow> scheduleVisitPatientResults;
  final bool scheduleVisitShowPatientDropdown;
  final bool scheduleVisitIsAddingPatient;
  final PatientListRow? scheduleVisitSelectedPatient;
  final String scheduleVisitFirstName;
  final String scheduleVisitLastName;
  final OfficeLocationModel? scheduleVisitOfficeLocation;
  final StaffModel? scheduleVisitProvider;
  final DateTime? scheduleVisitDate;
  final DateTime? scheduleVisitTime;
  final VisitTypeModel? scheduleVisitType;
  final String scheduleVisitNote;
  final String? scheduleVisitPaymentMethod;
  final String? scheduleVisitReason;

  const HomeScreenReady({
    required this.startDate,
    this.endDate,
    required this.displayLabel,
    this.activeEndDrawer,
    this.signalOpenEndDrawer = false,
    this.searchQuery = '',
    this.isLoadingOrganization = false,
    this.isLoadingVisits = false,
    this.errorMessage,
    this.successMessage,
    this.selectedStatuses = const [],
    this.selectedProviders = const [],
    this.selectedMedicalAssistants = const [],
    this.selectedOfficeLocations = const [],
    this.isCalendarVisible = false,
    this.currentVisits = const [],
    this.upcomingVisits = const [],
    this.recordedVisits = const [],
    this.pageCurrent = 1,
    this.totalPageCurrent = 1,
    this.isFetchingMoreCurrent = false,
    this.pageUpcoming = 1,
    this.totalPageUpcoming = 1,
    this.isFetchingMoreUpcoming = false,
    this.pageRecorded = 1,
    this.totalPageRecorded = 1,
    this.isFetchingMoreRecorded = false,
    this.filteredCountCurrent = 0,
    this.filteredCountUpcoming = 0,
    this.filteredCountRecorded = 0,
    this.allProviders = const [],
    this.allMedicalAssistants = const [],
    this.allOfficeLocations = const [],
    this.allVisitTypes = const [],
    this.draftStartDate,
    this.draftEndDate,
    this.draftStatuses = const [],
    this.draftProviders = const [],
    this.draftMedicalAssistants = const [],
    this.draftOfficeLocations = const [],
    this.scheduleVisitPatientSearchQuery = '',
    this.scheduleVisitIsPatientSearchLoading = false,
    this.scheduleVisitPatientResults = const [],
    this.scheduleVisitShowPatientDropdown = false,
    this.scheduleVisitIsAddingPatient = false,
    this.scheduleVisitSelectedPatient,
    this.scheduleVisitFirstName = '',
    this.scheduleVisitLastName = '',
    this.scheduleVisitOfficeLocation,
    this.scheduleVisitProvider,
    this.scheduleVisitDate,
    this.scheduleVisitTime,
    this.scheduleVisitType,
    this.scheduleVisitNote = '',
    this.scheduleVisitPaymentMethod,
    this.scheduleVisitReason,
  });

  HomeScreenReady copyWith({
    DateTime? startDate,
    DateTime? endDate,
    String? displayLabel,
    HomeScreenEndDrawerKind? activeEndDrawer,
    bool? signalOpenEndDrawer,
    String? searchQuery,
    bool? isLoadingOrganization,
    bool? isLoadingVisits,
    String? errorMessage,
    String? successMessage,
    bool clearRange = false,
    bool clearActiveEndDrawer = false,
    bool clearErrorMessage = false,
    bool clearSuccessMessage = false,
    List<String>? selectedStatuses,
    List<StaffModel>? selectedProviders,
    List<StaffModel>? selectedMedicalAssistants,
    List<OfficeLocationModel>? selectedOfficeLocations,
    bool? isCalendarVisible,
    List<VisitModel>? currentVisits,
    List<VisitModel>? upcomingVisits,
    List<VisitModel>? recordedVisits,
    int? pageCurrent,
    int? totalPageCurrent,
    bool? isFetchingMoreCurrent,
    int? pageUpcoming,
    int? totalPageUpcoming,
    bool? isFetchingMoreUpcoming,
    int? pageRecorded,
    int? totalPageRecorded,
    bool? isFetchingMoreRecorded,
    int? filteredCountCurrent,
    int? filteredCountUpcoming,
    int? filteredCountRecorded,
    List<StaffModel>? allProviders,
    List<StaffModel>? allMedicalAssistants,
    List<OfficeLocationModel>? allOfficeLocations,
    List<VisitTypeModel>? allVisitTypes,
    DateTime? draftStartDate,
    DateTime? draftEndDate,
    bool clearDraftRange = false,
    List<String>? draftStatuses,
    List<StaffModel>? draftProviders,
    List<StaffModel>? draftMedicalAssistants,
    List<OfficeLocationModel>? draftOfficeLocations,
    String? scheduleVisitPatientSearchQuery,
    bool? scheduleVisitIsPatientSearchLoading,
    List<PatientListRow>? scheduleVisitPatientResults,
    bool? scheduleVisitShowPatientDropdown,
    bool? scheduleVisitIsAddingPatient,
    PatientListRow? scheduleVisitSelectedPatient,
    bool clearScheduleVisitSelectedPatient = false,
    String? scheduleVisitFirstName,
    String? scheduleVisitLastName,
    OfficeLocationModel? scheduleVisitOfficeLocation,
    bool clearScheduleVisitOfficeLocation = false,
    StaffModel? scheduleVisitProvider,
    bool clearScheduleVisitProvider = false,
    DateTime? scheduleVisitDate,
    bool clearScheduleVisitDate = false,
    DateTime? scheduleVisitTime,
    bool clearScheduleVisitTime = false,
    VisitTypeModel? scheduleVisitType,
    bool clearScheduleVisitType = false,
    String? scheduleVisitNote,
    String? scheduleVisitPaymentMethod,
    bool clearScheduleVisitPaymentMethod = false,
    String? scheduleVisitReason,
    bool clearScheduleVisitReason = false,
  }) {
    return HomeScreenReady(
      startDate: startDate ?? this.startDate,
      endDate: clearRange ? null : (endDate ?? this.endDate),
      displayLabel: displayLabel ?? this.displayLabel,
      activeEndDrawer: clearActiveEndDrawer
          ? null
          : (activeEndDrawer ?? this.activeEndDrawer),
      signalOpenEndDrawer: signalOpenEndDrawer ?? this.signalOpenEndDrawer,
      searchQuery: searchQuery ?? this.searchQuery,
      isLoadingOrganization:
          isLoadingOrganization ?? this.isLoadingOrganization,
      isLoadingVisits: isLoadingVisits ?? this.isLoadingVisits,
      errorMessage: clearErrorMessage
          ? null
          : (errorMessage ?? this.errorMessage),
      successMessage: clearSuccessMessage
          ? null
          : (successMessage ?? this.successMessage),
      selectedStatuses: selectedStatuses ?? this.selectedStatuses,
      selectedProviders: selectedProviders ?? this.selectedProviders,
      selectedMedicalAssistants:
          selectedMedicalAssistants ?? this.selectedMedicalAssistants,
      selectedOfficeLocations:
          selectedOfficeLocations ?? this.selectedOfficeLocations,
      isCalendarVisible: isCalendarVisible ?? this.isCalendarVisible,
      currentVisits: currentVisits ?? this.currentVisits,
      upcomingVisits: upcomingVisits ?? this.upcomingVisits,
      recordedVisits: recordedVisits ?? this.recordedVisits,
      pageCurrent: pageCurrent ?? this.pageCurrent,
      totalPageCurrent: totalPageCurrent ?? this.totalPageCurrent,
      isFetchingMoreCurrent:
          isFetchingMoreCurrent ?? this.isFetchingMoreCurrent,
      pageUpcoming: pageUpcoming ?? this.pageUpcoming,
      totalPageUpcoming: totalPageUpcoming ?? this.totalPageUpcoming,
      isFetchingMoreUpcoming:
          isFetchingMoreUpcoming ?? this.isFetchingMoreUpcoming,
      pageRecorded: pageRecorded ?? this.pageRecorded,
      totalPageRecorded: totalPageRecorded ?? this.totalPageRecorded,
      isFetchingMoreRecorded:
          isFetchingMoreRecorded ?? this.isFetchingMoreRecorded,
      filteredCountCurrent: filteredCountCurrent ?? this.filteredCountCurrent,
      filteredCountUpcoming:
          filteredCountUpcoming ?? this.filteredCountUpcoming,
      filteredCountRecorded:
          filteredCountRecorded ?? this.filteredCountRecorded,
      allProviders: allProviders ?? this.allProviders,
      allMedicalAssistants: allMedicalAssistants ?? this.allMedicalAssistants,
      allOfficeLocations: allOfficeLocations ?? this.allOfficeLocations,
      allVisitTypes: allVisitTypes ?? this.allVisitTypes,
      draftStartDate: draftStartDate ?? this.draftStartDate,
      draftEndDate: clearDraftRange
          ? null
          : (draftEndDate ?? this.draftEndDate),
      draftStatuses: draftStatuses ?? this.draftStatuses,
      draftProviders: draftProviders ?? this.draftProviders,
      draftMedicalAssistants:
          draftMedicalAssistants ?? this.draftMedicalAssistants,
      draftOfficeLocations: draftOfficeLocations ?? this.draftOfficeLocations,
      scheduleVisitPatientSearchQuery:
          scheduleVisitPatientSearchQuery ??
          this.scheduleVisitPatientSearchQuery,
      scheduleVisitIsPatientSearchLoading:
          scheduleVisitIsPatientSearchLoading ??
          this.scheduleVisitIsPatientSearchLoading,
      scheduleVisitPatientResults:
          scheduleVisitPatientResults ?? this.scheduleVisitPatientResults,
      scheduleVisitShowPatientDropdown:
          scheduleVisitShowPatientDropdown ??
          this.scheduleVisitShowPatientDropdown,
      scheduleVisitIsAddingPatient:
          scheduleVisitIsAddingPatient ?? this.scheduleVisitIsAddingPatient,
      scheduleVisitSelectedPatient: clearScheduleVisitSelectedPatient
          ? null
          : (scheduleVisitSelectedPatient ?? this.scheduleVisitSelectedPatient),
      scheduleVisitFirstName:
          scheduleVisitFirstName ?? this.scheduleVisitFirstName,
      scheduleVisitLastName:
          scheduleVisitLastName ?? this.scheduleVisitLastName,
      scheduleVisitOfficeLocation: clearScheduleVisitOfficeLocation
          ? null
          : (scheduleVisitOfficeLocation ?? this.scheduleVisitOfficeLocation),
      scheduleVisitProvider: clearScheduleVisitProvider
          ? null
          : (scheduleVisitProvider ?? this.scheduleVisitProvider),
      scheduleVisitDate: clearScheduleVisitDate
          ? null
          : (scheduleVisitDate ?? this.scheduleVisitDate),
      scheduleVisitTime: clearScheduleVisitTime
          ? null
          : (scheduleVisitTime ?? this.scheduleVisitTime),
      scheduleVisitType: clearScheduleVisitType
          ? null
          : (scheduleVisitType ?? this.scheduleVisitType),
      scheduleVisitNote: scheduleVisitNote ?? this.scheduleVisitNote,
      scheduleVisitPaymentMethod: clearScheduleVisitPaymentMethod
          ? null
          : (scheduleVisitPaymentMethod ?? this.scheduleVisitPaymentMethod),
      scheduleVisitReason: clearScheduleVisitReason
          ? null
          : (scheduleVisitReason ?? this.scheduleVisitReason),
    );
  }
}
