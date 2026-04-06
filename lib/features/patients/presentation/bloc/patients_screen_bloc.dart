import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subqdocs_bloc/core/constants/app_strings.dart';
import 'package:subqdocs_bloc/core/services/api_exceptions.dart';
import 'package:subqdocs_bloc/features/patients/data/patient_list_row.dart';
import 'package:subqdocs_bloc/features/patients/data/patients_list_api_envelope.dart';
import 'package:subqdocs_bloc/features/patients/domain/patient_sort_column.dart';
import 'package:subqdocs_bloc/features/patients/domain/repositories/patients_repository.dart';

part 'patients_screen_event.dart';
part 'patients_screen_state.dart';

final class PatientsScreenBloc
    extends Bloc<PatientsScreenEvent, PatientsScreenState> {
  PatientsScreenBloc({required PatientsRepository patientsRepository})
    : _patientsRepository = patientsRepository,
      super(const PatientsScreenInitial()) {
    on<PatientsScreenStarted>(_onStarted);
    on<PatientsSearchQueryChanged>(_onSearchQueryChanged);
    on<PatientsSearchDebounced>(_onSearchDebounced);
    on<PatientsSearchCleared>(_onSearchCleared);
    on<PatientsSortColumnPressed>(_onSortColumnPressed);
    on<PatientsLoadMoreRequested>(_onLoadMoreRequested);
    on<PatientsRetryRequested>(_onRetryRequested);
    on<PatientsLoadMoreErrorConsumed>(_onLoadMoreErrorConsumed);
  }

  static const int _defaultLimit = 80;
  static const Duration _searchDebounce = Duration(milliseconds: 400);

  final PatientsRepository _patientsRepository;
  Timer? _searchDebounceTimer;

  @override
  Future<void> close() {
    _searchDebounceTimer?.cancel();
    return super.close();
  }

  bool _isSuccessResponse(String? responseType) {
    final String? type = responseType?.toLowerCase().trim();
    return type == 'success';
  }

  /// Non-null [PatientsListPageData] only when the envelope is a list success.
  PatientsListPageData? _pageDataIfListSuccess(
    PatientsListApiEnvelope envelope,
  ) {
    if (!_isSuccessResponse(envelope.responseType) ||
        envelope.responseData == null) {
      return null;
    }
    return envelope.responseData;
  }

  String _userVisibleFailureMessage(String? primary) {
    final String t = primary?.trim() ?? '';
    return t.isNotEmpty ? t : AppStrings.patientsListGenericFailure;
  }

  PatientsScreenReady? _readyOrNull(PatientsScreenState s) {
    return s is PatientsScreenReady ? s : null;
  }

  Future<void> _onStarted(
    PatientsScreenStarted event,
    Emitter<PatientsScreenState> emit,
  ) async {
    await _fetchPageOne(
      emit,
      searchQuery: '',
      sortColumn: null,
      sortDescending: false,
    );
  }

  void _onSearchQueryChanged(
    PatientsSearchQueryChanged event,
    Emitter<PatientsScreenState> emit,
  ) {
    _searchDebounceTimer?.cancel();
    _searchDebounceTimer = Timer(_searchDebounce, () {
      if (isClosed) {
        return;
      }
      add(PatientsSearchDebounced(event.query));
    });
  }

  Future<void> _onSearchDebounced(
    PatientsSearchDebounced event,
    Emitter<PatientsScreenState> emit,
  ) async {
    final PatientsScreenReady? cur = _readyOrNull(state);
    await _fetchPageOne(
      emit,
      searchQuery: event.query,
      sortColumn: cur?.activeSortColumn,
      sortDescending: cur?.sortDescending ?? false,
    );
  }

  Future<void> _onSearchCleared(
    PatientsSearchCleared event,
    Emitter<PatientsScreenState> emit,
  ) async {
    _searchDebounceTimer?.cancel();
    final PatientsScreenReady? cur = _readyOrNull(state);
    await _fetchPageOne(
      emit,
      searchQuery: '',
      sortColumn: cur?.activeSortColumn,
      sortDescending: cur?.sortDescending ?? false,
    );
  }

  Future<void> _onSortColumnPressed(
    PatientsSortColumnPressed event,
    Emitter<PatientsScreenState> emit,
  ) async {
    final PatientsScreenReady? cur = _readyOrNull(state);
    final PatientSortColumn? prevCol = cur?.activeSortColumn;
    final bool prevDesc = cur?.sortDescending ?? false;
    final PatientSortColumn column = event.column;
    final bool nextDesc = prevCol == column ? !prevDesc : false;

    await _fetchPageOne(
      emit,
      searchQuery: cur?.searchQuery ?? '',
      sortColumn: column,
      sortDescending: nextDesc,
    );
  }

  Future<void> _onRetryRequested(
    PatientsRetryRequested event,
    Emitter<PatientsScreenState> emit,
  ) async {
    final PatientsScreenReady? cur = _readyOrNull(state);
    await _fetchPageOne(
      emit,
      searchQuery: cur?.searchQuery ?? '',
      sortColumn: cur?.activeSortColumn,
      sortDescending: cur?.sortDescending ?? false,
    );
  }

  Future<void> _fetchPageOne(
    Emitter<PatientsScreenState> emit, {
    required String searchQuery,
    required PatientSortColumn? sortColumn,
    required bool sortDescending,
  }) async {
    final PatientsScreenReady? cur = _readyOrNull(state);
    final List<PatientListRow> existingRows =
        cur?.rows ?? const <PatientListRow>[];

    emit(
      PatientsScreenReady(
        rows: existingRows,
        page: cur?.page ?? 1,
        totalPage: cur?.totalPage ?? 1,
        totalCount: cur?.totalCount ?? 0,
        limit: cur?.limit ?? _defaultLimit,
        searchQuery: searchQuery,
        activeSortColumn: sortColumn,
        sortDescending: sortDescending,
        isPageOneLoading: true,
        isLoadingMore: false,
        loadMoreErrorMessage: null,
      ),
    );

    final List<Map<String, dynamic>> sorting =
        PatientsScreenReady.sortingPayloadFor(sortColumn, sortDescending);

    try {
      final PatientsListApiEnvelope envelope = await _patientsRepository
          .fetchPatients(
            page: 1,
            limit: _defaultLimit,
            search: searchQuery,
            sorting: sorting,
          );
      if (isClosed) {
        return;
      }
      final PatientsListPageData? d = _pageDataIfListSuccess(envelope);
      if (d != null) {
        emit(
          PatientsScreenReady(
            rows: d.rows,
            page: d.page,
            totalPage: d.totalPage,
            totalCount: d.totalCount,
            limit: d.limit,
            searchQuery: searchQuery,
            activeSortColumn: sortColumn,
            sortDescending: sortDescending,
            isPageOneLoading: false,
            isLoadingMore: false,
            loadMoreErrorMessage: null,
          ),
        );
        return;
      }
      emit(
        PatientsScreenLoadFailed(
          message: _userVisibleFailureMessage(envelope.message),
        ),
      );
    } on ApiException catch (e) {
      if (isClosed) {
        return;
      }
      emit(
        PatientsScreenLoadFailed(
          message: _userVisibleFailureMessage(e.message),
        ),
      );
    } catch (_) {
      if (isClosed) {
        return;
      }
      emit(PatientsScreenLoadFailed(message: _userVisibleFailureMessage(null)));
    }
  }

  Future<void> _onLoadMoreRequested(
    PatientsLoadMoreRequested event,
    Emitter<PatientsScreenState> emit,
  ) async {
    final PatientsScreenReady? cur = _readyOrNull(state);
    if (cur == null ||
        cur.isPageOneLoading ||
        cur.isLoadingMore ||
        !cur.hasMore) {
      return;
    }

    emit(cur.copyWith(isLoadingMore: true, clearLoadMoreError: true));

    final int nextPage = cur.page + 1;

    try {
      final PatientsListApiEnvelope envelope = await _patientsRepository
          .fetchPatients(
            page: nextPage,
            limit: cur.limit,
            search: cur.searchQuery,
            sorting: cur.sortingPayload,
          );
      if (isClosed) {
        return;
      }
      final PatientsListPageData? d = _pageDataIfListSuccess(envelope);
      if (d != null) {
        emit(
          cur.copyWith(
            rows: <PatientListRow>[...cur.rows, ...d.rows],
            page: d.page,
            totalPage: d.totalPage,
            totalCount: d.totalCount,
            limit: d.limit,
            isLoadingMore: false,
            clearLoadMoreError: true,
          ),
        );
        return;
      }
      emit(
        cur.copyWith(
          isLoadingMore: false,
          loadMoreErrorMessage: _userVisibleFailureMessage(envelope.message),
        ),
      );
    } on ApiException catch (e) {
      if (isClosed) {
        return;
      }
      emit(
        cur.copyWith(
          isLoadingMore: false,
          loadMoreErrorMessage: _userVisibleFailureMessage(e.message),
        ),
      );
    } catch (_) {
      if (isClosed) {
        return;
      }
      emit(
        cur.copyWith(
          isLoadingMore: false,
          loadMoreErrorMessage: _userVisibleFailureMessage(null),
        ),
      );
    }
  }

  void _onLoadMoreErrorConsumed(
    PatientsLoadMoreErrorConsumed event,
    Emitter<PatientsScreenState> emit,
  ) {
    final PatientsScreenReady? cur = _readyOrNull(state);
    if (cur == null) {
      return;
    }
    emit(cur.copyWith(clearLoadMoreError: true));
  }
}
