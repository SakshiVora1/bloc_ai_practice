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
  final String? errorMessage;
  final String? successMessage;
  final List<String> selectedStatuses;
  final List<StaffModel> selectedProviders;
  final List<StaffModel> selectedMedicalAssistants;
  final List<OfficeLocationModel> selectedOfficeLocations;
  final bool isCalendarVisible;

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

  HomeScreenReady({
    required this.startDate,
    this.endDate,
    required this.displayLabel,
    this.activeEndDrawer,
    this.signalOpenEndDrawer = false,
    this.searchQuery = '',
    this.isLoadingOrganization = false,
    this.errorMessage,
    this.successMessage,
    this.selectedStatuses = const [],
    this.selectedProviders = const [],
    this.selectedMedicalAssistants = const [],
    this.selectedOfficeLocations = const [],
    this.isCalendarVisible = false,
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
  });

  HomeScreenReady copyWith({
    DateTime? startDate,
    DateTime? endDate,
    String? displayLabel,
    HomeScreenEndDrawerKind? activeEndDrawer,
    bool? signalOpenEndDrawer,
    String? searchQuery,
    bool? isLoadingOrganization,
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
      isLoadingOrganization: isLoadingOrganization ?? this.isLoadingOrganization,
      errorMessage:
          clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
      successMessage:
          clearSuccessMessage ? null : (successMessage ?? this.successMessage),
      selectedStatuses: selectedStatuses ?? this.selectedStatuses,
      selectedProviders: selectedProviders ?? this.selectedProviders,
      selectedMedicalAssistants:
          selectedMedicalAssistants ?? this.selectedMedicalAssistants,
      selectedOfficeLocations:
          selectedOfficeLocations ?? this.selectedOfficeLocations,
      isCalendarVisible: isCalendarVisible ?? this.isCalendarVisible,
      allProviders: allProviders ?? this.allProviders,
      allMedicalAssistants: allMedicalAssistants ?? this.allMedicalAssistants,
      allOfficeLocations: allOfficeLocations ?? this.allOfficeLocations,
      allVisitTypes: allVisitTypes ?? this.allVisitTypes,
      draftStartDate: draftStartDate ?? this.draftStartDate,
      draftEndDate: clearDraftRange ? null : (draftEndDate ?? this.draftEndDate),
      draftStatuses: draftStatuses ?? this.draftStatuses,
      draftProviders: draftProviders ?? this.draftProviders,
      draftMedicalAssistants:
          draftMedicalAssistants ?? this.draftMedicalAssistants,
      draftOfficeLocations: draftOfficeLocations ?? this.draftOfficeLocations,
    );
  }
}
