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
