part of 'patients_screen_bloc.dart';

sealed class PatientsScreenState {
  const PatientsScreenState();
}

final class PatientsScreenInitial extends PatientsScreenState {
  const PatientsScreenInitial();
}

final class PatientsScreenLoadFailed extends PatientsScreenState {
  const PatientsScreenLoadFailed({required this.message});

  final String message;
}

final class PatientsScreenReady extends PatientsScreenState {
  const PatientsScreenReady({
    required this.rows,
    required this.page,
    required this.totalPage,
    required this.totalCount,
    required this.limit,
    required this.searchQuery,
    required this.activeSortColumn,
    required this.sortDescending,
    required this.isPageOneLoading,
    required this.isLoadingMore,
    required this.loadMoreErrorMessage,
  });

  /// UI shell before the first [PatientsScreenStarted] emission resolves.
  static const PatientsScreenReady initialPageOneLoading = PatientsScreenReady(
    rows: <PatientListRow>[],
    page: 1,
    totalPage: 1,
    totalCount: 0,
    limit: 80,
    searchQuery: '',
    activeSortColumn: null,
    sortDescending: false,
    isPageOneLoading: true,
    isLoadingMore: false,
    loadMoreErrorMessage: null,
  );

  final List<PatientListRow> rows;
  final int page;
  final int totalPage;
  final int totalCount;
  final int limit;
  final String searchQuery;
  final PatientSortColumn? activeSortColumn;
  final bool sortDescending;
  final bool isPageOneLoading;
  final bool isLoadingMore;
  final String? loadMoreErrorMessage;

  bool get hasMore => page < totalPage;

  List<Map<String, dynamic>> get sortingPayload =>
      sortingPayloadFor(activeSortColumn, sortDescending);

  /// API `sorting` query body for [patient/getAllPatients].
  static List<Map<String, dynamic>> sortingPayloadFor(
    PatientSortColumn? column,
    bool descending,
  ) {
    if (column == null) {
      return <Map<String, dynamic>>[];
    }
    return <Map<String, dynamic>>[
      <String, dynamic>{'id': column.apiSortId, 'desc': descending},
    ];
  }

  PatientsScreenReady copyWith({
    List<PatientListRow>? rows,
    int? page,
    int? totalPage,
    int? totalCount,
    int? limit,
    String? searchQuery,
    PatientSortColumn? activeSortColumn,
    bool? sortDescending,
    bool? isPageOneLoading,
    bool? isLoadingMore,
    String? loadMoreErrorMessage,
    bool clearLoadMoreError = false,
  }) {
    return PatientsScreenReady(
      rows: rows ?? this.rows,
      page: page ?? this.page,
      totalPage: totalPage ?? this.totalPage,
      totalCount: totalCount ?? this.totalCount,
      limit: limit ?? this.limit,
      searchQuery: searchQuery ?? this.searchQuery,
      activeSortColumn: activeSortColumn ?? this.activeSortColumn,
      sortDescending: sortDescending ?? this.sortDescending,
      isPageOneLoading: isPageOneLoading ?? this.isPageOneLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      loadMoreErrorMessage: clearLoadMoreError
          ? null
          : (loadMoreErrorMessage ?? this.loadMoreErrorMessage),
    );
  }
}
