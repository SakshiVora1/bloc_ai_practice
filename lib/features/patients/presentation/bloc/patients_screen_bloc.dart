import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subqdocs_bloc/core/constants/app_strings.dart';
import 'package:subqdocs_bloc/core/services/api_exceptions.dart';
import 'package:subqdocs_bloc/features/patients/data/patient_list_row.dart';
import 'package:subqdocs_bloc/features/patients/domain/patient_sort_column.dart';
import 'package:subqdocs_bloc/features/patients/domain/repositories/patients_repository.dart';

part 'patients_screen_event.dart';

part 'patients_screen_state.dart';

class PatientsScreenBloc
    extends Bloc<PatientsScreenEvent, PatientsScreenState> {
  PatientsScreenBloc({required PatientsRepository patientsRepository})
    : _patientsRepository = patientsRepository,
      super(const PatientsScreenInitial()) {
    on<PatientsScreenStarted>(_onStarted);
    on<PatientsSearchInputChanged>(_onSearchInputChanged);
    on<PatientsSearchDebouncedFetch>(_onSearchDebouncedFetch);
    on<PatientsSearchClearRequested>(_onSearchClearRequested);
    on<PatientsSortColumnTapped>(_onSortColumnTapped);
    on<PatientsPreviousPageTapped>(_onPreviousPage);
    on<PatientsNextPageTapped>(_onNextPage);
    on<PatientsApiErrorToastConsumed>(_onApiErrorConsumed);
  }

  static const Duration _searchDebounceDuration = Duration(milliseconds: 450);

  final PatientsRepository _patientsRepository;
  Timer? _searchDebounce;

  @override
  Future<void> close() {
    _searchDebounce?.cancel();
    return super.close();
  }

  Future<void> _onStarted(
    PatientsScreenStarted event,
    Emitter<PatientsScreenState> emit,
  ) async {
    const PatientsScreenReady loading = PatientsScreenReady(
      rows: <PatientListRow>[],
      page: 1,
      limit: PatientsScreenReady.defaultLimit,
      totalCount: 0,
      totalPage: 1,
      searchQuery: '',
      activeSortColumn: null,
      sortDescending: false,
      isListLoading: true,
    );
    emit(loading);
    await _reload(emit, loading);
  }

  void _onSearchInputChanged(
    PatientsSearchInputChanged event,
    Emitter<PatientsScreenState> emit,
  ) {
    final PatientsScreenState current = state;
    if (current is! PatientsScreenReady) {
      return;
    }
    emit(current.copyWith(searchQuery: event.text));
    _searchDebounce?.cancel();
    _searchDebounce = Timer(_searchDebounceDuration, () {
      if (!isClosed) {
        add(const PatientsSearchDebouncedFetch());
      }
    });
  }

  Future<void> _onSearchDebouncedFetch(
    PatientsSearchDebouncedFetch event,
    Emitter<PatientsScreenState> emit,
  ) async {
    final PatientsScreenState current = state;
    if (current is! PatientsScreenReady) {
      return;
    }
    final PatientsScreenReady loading = current.copyWith(
      page: 1,
      isListLoading: true,
    );
    emit(loading);
    await _reload(emit, loading);
  }

  Future<void> _onSearchClearRequested(
    PatientsSearchClearRequested event,
    Emitter<PatientsScreenState> emit,
  ) async {
    _searchDebounce?.cancel();
    final PatientsScreenState current = state;
    if (current is! PatientsScreenReady) {
      return;
    }
    final PatientsScreenReady loading = current.copyWith(
      searchQuery: '',
      page: 1,
      isListLoading: true,
      clearLastApiError: true,
    );
    emit(loading);
    await _reload(emit, loading);
  }

  Future<void> _onSortColumnTapped(
    PatientsSortColumnTapped event,
    Emitter<PatientsScreenState> emit,
  ) async {
    final PatientsScreenState current = state;
    if (current is! PatientsScreenReady) {
      return;
    }
    final PatientSortColumn column = event.column;
    final PatientSortColumn? prev = current.activeSortColumn;
    final bool nextDesc;
    final PatientSortColumn nextCol;
    if (prev == column) {
      nextCol = column;
      nextDesc = !current.sortDescending;
    } else {
      nextCol = column;
      nextDesc = false;
    }
    final PatientsScreenReady loading = current.copyWith(
      activeSortColumn: nextCol,
      sortDescending: nextDesc,
      page: 1,
      isListLoading: true,
      clearLastApiError: true,
    );
    emit(loading);
    await _reload(emit, loading);
  }

  Future<void> _onPreviousPage(
    PatientsPreviousPageTapped event,
    Emitter<PatientsScreenState> emit,
  ) async {
    final PatientsScreenState current = state;
    if (current is! PatientsScreenReady) {
      return;
    }
    if (current.page <= 1) {
      return;
    }
    final PatientsScreenReady loading = current.copyWith(
      page: current.page - 1,
      isListLoading: true,
      clearLastApiError: true,
    );
    emit(loading);
    await _reload(emit, loading);
  }

  Future<void> _onNextPage(
    PatientsNextPageTapped event,
    Emitter<PatientsScreenState> emit,
  ) async {
    final PatientsScreenState current = state;
    if (current is! PatientsScreenReady) {
      return;
    }
    if (current.page >= current.totalPage) {
      return;
    }
    final PatientsScreenReady loading = current.copyWith(
      page: current.page + 1,
      isListLoading: true,
      clearLastApiError: true,
    );
    emit(loading);
    await _reload(emit, loading);
  }

  void _onApiErrorConsumed(
    PatientsApiErrorToastConsumed event,
    Emitter<PatientsScreenState> emit,
  ) {
    final PatientsScreenState current = state;
    if (current is! PatientsScreenReady) {
      return;
    }
    if (current.lastApiError == null) {
      return;
    }
    emit(current.copyWith(clearLastApiError: true));
  }

  List<Map<String, dynamic>> _sortingPayload(PatientsScreenReady s) {
    final PatientSortColumn? col = s.activeSortColumn;
    if (col == null) {
      return <Map<String, dynamic>>[];
    }
    return <Map<String, dynamic>>[
      <String, dynamic>{'id': col.apiSortId, 'desc': s.sortDescending},
    ];
  }

  Future<void> _reload(
    Emitter<PatientsScreenState> emit,
    PatientsScreenReady snapshot,
  ) async {
    try {
      final PatientsListPageResult result = await _patientsRepository
          .fetchPatientsPage(
            page: snapshot.page,
            limit: snapshot.limit,
            search: snapshot.searchQuery.trim().isEmpty
                ? null
                : snapshot.searchQuery.trim(),
            sorting: _sortingPayload(snapshot),
          );
      if (isClosed) {
        return;
      }
      final bool ok = (result.responseType ?? '').toLowerCase() == 'success';
      if (!ok) {
        emit(
          snapshot.copyWith(
            isListLoading: false,
            lastApiError:
                (result.message != null && result.message!.trim().isNotEmpty)
                ? result.message!.trim()
                : AppStrings.patientsListGenericFailure,
          ),
        );
        return;
      }

      emit(
        snapshot.copyWith(
          rows: result.rows,
          page: result.page,
          limit: result.limit,
          totalCount: result.totalCount,
          totalPage: result.totalPage <= 0 ? 1 : result.totalPage,
          isListLoading: false,
          clearLastApiError: true,
        ),
      );
    } on ApiException catch (e) {
      if (isClosed) {
        return;
      }
      final bool hadRows = snapshot.rows.isNotEmpty;
      if (!hadRows && snapshot.page == 1) {
        emit(PatientsScreenFailure(message: e.message));
        return;
      }
      emit(snapshot.copyWith(isListLoading: false, lastApiError: e.message));
    } catch (e) {
      if (isClosed) {
        return;
      }
      emit(
        snapshot.copyWith(
          isListLoading: false,
          lastApiError: AppStrings.patientsListGenericFailure,
        ),
      );
    }
  }
}
