part of 'home_screen_bloc.dart';

@immutable
sealed class HomeScreenEvent {
  const HomeScreenEvent();
}

final class HomeScreenStarted extends HomeScreenEvent {
  const HomeScreenStarted();
}

final class HomeScreenDateForward extends HomeScreenEvent {
  const HomeScreenDateForward();
}

final class HomeScreenDateBackward extends HomeScreenEvent {
  const HomeScreenDateBackward();
}

final class HomeScreenDateSelected extends HomeScreenEvent {
  const HomeScreenDateSelected({required this.start, this.end});

  final DateTime start;
  final DateTime? end;
}

final class HomeScreenFilterPanelOpened extends HomeScreenEvent {
  const HomeScreenFilterPanelOpened();
}

final class HomeScreenScheduleVisitOpened extends HomeScreenEvent {
  const HomeScreenScheduleVisitOpened();
}

/// Clears the one-shot flag after [ScaffoldState.openEndDrawer].
final class HomeScreenEndDrawerOpenConsumed extends HomeScreenEvent {
  const HomeScreenEndDrawerOpenConsumed();
}

final class HomeScreenSearchQueryChanged extends HomeScreenEvent {
  const HomeScreenSearchQueryChanged(this.query);

  final String query;
}

final class HomeScreenErrorMessageConsumed extends HomeScreenEvent {
  const HomeScreenErrorMessageConsumed();
}

final class HomeScreenFilterStatusChanged extends HomeScreenEvent {
  const HomeScreenFilterStatusChanged(this.statuses);
  final List<String> statuses;
}

final class HomeScreenFilterProviderChanged extends HomeScreenEvent {
  const HomeScreenFilterProviderChanged(this.providers);
  final List<StaffModel> providers;
}

final class HomeScreenFilterMedicalAssistantChanged extends HomeScreenEvent {
  const HomeScreenFilterMedicalAssistantChanged(this.medicalAssistants);
  final List<StaffModel> medicalAssistants;
}

final class HomeScreenFilterOfficeLocationChanged extends HomeScreenEvent {
  const HomeScreenFilterOfficeLocationChanged(this.locations);
  final List<OfficeLocationModel> locations;
}

final class HomeScreenFilterClearAll extends HomeScreenEvent {
  const HomeScreenFilterClearAll();
}

final class HomeScreenFilterCalendarVisibilityToggled extends HomeScreenEvent {
  const HomeScreenFilterCalendarVisibilityToggled();
}

final class HomeScreenFilterPanelClosed extends HomeScreenEvent {
  const HomeScreenFilterPanelClosed();
}

final class HomeScreenSuccessMessageConsumed extends HomeScreenEvent {
  const HomeScreenSuccessMessageConsumed();
}

final class HomeScreenCurrentVisitsRequested extends HomeScreenEvent {
  const HomeScreenCurrentVisitsRequested({this.isNextPage = false});
  final bool isNextPage;
}

final class HomeScreenUpcomingVisitsRequested extends HomeScreenEvent {
  const HomeScreenUpcomingVisitsRequested({this.isNextPage = false});
  final bool isNextPage;
}

final class HomeScreenRecordedVisitsRequested extends HomeScreenEvent {
  const HomeScreenRecordedVisitsRequested({this.isNextPage = false});
  final bool isNextPage;
}

final class HomeScreenScheduleVisitPatientDropdownOpened
    extends HomeScreenEvent {
  const HomeScreenScheduleVisitPatientDropdownOpened();
}

final class HomeScreenScheduleVisitPatientDropdownClosed
    extends HomeScreenEvent {
  const HomeScreenScheduleVisitPatientDropdownClosed();
}

final class HomeScreenScheduleVisitPatientSearchChanged
    extends HomeScreenEvent {
  const HomeScreenScheduleVisitPatientSearchChanged(this.query);

  final String query;
}

final class HomeScreenScheduleVisitPatientSearchDebounced
    extends HomeScreenEvent {
  const HomeScreenScheduleVisitPatientSearchDebounced(this.query);

  final String query;
}

final class HomeScreenScheduleVisitPatientSuggestionsRequested
    extends HomeScreenEvent {
  const HomeScreenScheduleVisitPatientSuggestionsRequested({
    required this.query,
    required this.completer,
  });

  final String query;
  final Completer<List<PatientListRow>> completer;
}

final class HomeScreenScheduleVisitAddPatientSelected extends HomeScreenEvent {
  const HomeScreenScheduleVisitAddPatientSelected();
}

final class HomeScreenScheduleVisitSearchExistingPatientSelected
    extends HomeScreenEvent {
  const HomeScreenScheduleVisitSearchExistingPatientSelected();
}

final class HomeScreenScheduleVisitPatientSelected extends HomeScreenEvent {
  const HomeScreenScheduleVisitPatientSelected(this.patient);

  final PatientListRow patient;
}

final class HomeScreenScheduleVisitFirstNameChanged extends HomeScreenEvent {
  const HomeScreenScheduleVisitFirstNameChanged(this.value);

  final String value;
}

final class HomeScreenScheduleVisitLastNameChanged extends HomeScreenEvent {
  const HomeScreenScheduleVisitLastNameChanged(this.value);

  final String value;
}

final class HomeScreenScheduleVisitOfficeLocationChanged
    extends HomeScreenEvent {
  const HomeScreenScheduleVisitOfficeLocationChanged(this.location);
  final OfficeLocationModel? location;
}

final class HomeScreenScheduleVisitProviderChanged extends HomeScreenEvent {
  const HomeScreenScheduleVisitProviderChanged(this.provider);
  final StaffModel? provider;
}

final class HomeScreenScheduleVisitDateChanged extends HomeScreenEvent {
  const HomeScreenScheduleVisitDateChanged(this.date);
  final DateTime? date;
}

final class HomeScreenScheduleVisitTimeChanged extends HomeScreenEvent {
  const HomeScreenScheduleVisitTimeChanged(this.time);
  final DateTime? time;
}

final class HomeScreenScheduleVisitTypeChanged extends HomeScreenEvent {
  const HomeScreenScheduleVisitTypeChanged(this.visitType);
  final VisitTypeModel? visitType;
}

final class HomeScreenScheduleVisitNoteChanged extends HomeScreenEvent {
  const HomeScreenScheduleVisitNoteChanged(this.note);
  final String note;
}

final class HomeScreenScheduleVisitPaymentMethodChanged
    extends HomeScreenEvent {
  const HomeScreenScheduleVisitPaymentMethodChanged(this.method);
  final String? method;
}

final class HomeScreenScheduleVisitReasonChanged extends HomeScreenEvent {
  const HomeScreenScheduleVisitReasonChanged(this.reason);
  final String? reason;
}
