import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:subqdocs_bloc/core/constants/app_strings.dart';
import 'package:subqdocs_bloc/features/home/domain/home_date_display.dart';

part 'home_screen_event.dart';

part 'home_screen_state.dart';

class HomeScreenBloc extends Bloc<HomeScreenEvent, HomeScreenState> {
  HomeScreenBloc() : super(const HomeScreenInitial()) {
    on<HomeScreenStarted>(_onStarted);
    on<HomeScreenDateForward>(_onDateForward);
    on<HomeScreenDateBackward>(_onDateBackward);
    on<HomeScreenDateSelected>(_onDateSelected);
    on<HomeScreenFilterPanelOpened>(_onFilterPanelOpened);
    on<HomeScreenScheduleVisitOpened>(_onScheduleVisitOpened);
    on<HomeScreenEndDrawerOpenConsumed>(_onEndDrawerOpenConsumed);
    on<HomeScreenSearchQueryChanged>(_onSearchQueryChanged);
  }

  void _onStarted(HomeScreenStarted event, Emitter<HomeScreenState> emit) {
    final DateTime today = todayDateOnly(() => DateTime.now());
    emit(
      HomeScreenReady(
        startDate: today,
        endDate: null,
        displayLabel: _computeDisplayLabel(today, null),
      ),
    );
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
    final HomeScreenReady current = _asReady(state);
    final DateTime start = DateTime(
      event.start.year,
      event.start.month,
      event.start.day,
    );
    if (event.end == null) {
      emit(
        current.copyWith(
          startDate: start,
          endDate: null,
          clearRange: true,
          displayLabel: _computeDisplayLabel(start, null),
        ),
      );
      return;
    }
    final DateTime end = DateTime(
      event.end!.year,
      event.end!.month,
      event.end!.day,
    );
    emit(
      current.copyWith(
        startDate: start,
        endDate: end,
        displayLabel: _computeDisplayLabel(start, end),
      ),
    );
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
}
