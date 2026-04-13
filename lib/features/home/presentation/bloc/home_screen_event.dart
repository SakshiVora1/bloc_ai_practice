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
