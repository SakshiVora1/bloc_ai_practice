part of 'patients_screen_bloc.dart';

@immutable
sealed class PatientsScreenState {
  const PatientsScreenState();
}

final class PatientsScreenInitial extends PatientsScreenState {
  const PatientsScreenInitial();
}

final class PatientsScreenFailure extends PatientsScreenState {
  const PatientsScreenFailure({required this.message});

  final String message;
}

final class PatientsScreenReady extends PatientsScreenState {
  const PatientsScreenReady({
    required this.rows,
    required this.page,
    required this.limit,
    required this.totalCount,
    required this.totalPage,
    required this.searchQuery,
    required this.activeSortColumn,
    required this.sortDescending,
    required this.isListLoading,
    this.lastApiError,
  });

  static const int defaultLimit = 80;

  final List<PatientListRow> rows;
  final int page;
  final int limit;
  final int totalCount;
  final int totalPage;
  final String searchQuery;
  final PatientSortColumn? activeSortColumn;
  final bool sortDescending;
  final bool isListLoading;
  final String? lastApiError;

  PatientsScreenReady copyWith({
    List<PatientListRow>? rows,
    int? page,
    int? limit,
    int? totalCount,
    int? totalPage,
    String? searchQuery,
    PatientSortColumn? activeSortColumn,
    bool clearActiveSortColumn = false,
    bool? sortDescending,
    bool? isListLoading,
    String? lastApiError,
    bool clearLastApiError = false,
  }) {
    return PatientsScreenReady(
      rows: rows ?? this.rows,
      page: page ?? this.page,
      limit: limit ?? this.limit,
      totalCount: totalCount ?? this.totalCount,
      totalPage: totalPage ?? this.totalPage,
      searchQuery: searchQuery ?? this.searchQuery,
      activeSortColumn: clearActiveSortColumn
          ? null
          : (activeSortColumn ?? this.activeSortColumn),
      sortDescending: sortDescending ?? this.sortDescending,
      isListLoading: isListLoading ?? this.isListLoading,
      lastApiError: clearLastApiError
          ? null
          : (lastApiError ?? this.lastApiError),
    );
  }
}
