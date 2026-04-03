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
  const HomeScreenReady({
    required this.startDate,
    this.endDate,
    required this.displayLabel,
    this.activeEndDrawer,
    this.signalOpenEndDrawer = false,
    this.searchQuery = '',
  });

  final DateTime? startDate;
  final DateTime? endDate;
  final String displayLabel;
  final HomeScreenEndDrawerKind? activeEndDrawer;
  final bool signalOpenEndDrawer;
  final String searchQuery;

  HomeScreenReady copyWith({
    DateTime? startDate,
    DateTime? endDate,
    String? displayLabel,
    HomeScreenEndDrawerKind? activeEndDrawer,
    bool? signalOpenEndDrawer,
    String? searchQuery,
    bool clearRange = false,
    bool clearActiveEndDrawer = false,
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
    );
  }
}
