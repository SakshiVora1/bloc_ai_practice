import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:subqdocs_bloc/core/constants/app_strings.dart';
import 'package:subqdocs_bloc/core/models/session_user_info.dart';
import 'package:subqdocs_bloc/core/services/api_exceptions.dart';
import 'package:subqdocs_bloc/core/services/unauthorized_session_handler.dart';
import 'package:subqdocs_bloc/data/models/current_user_response.dart';
import 'package:subqdocs_bloc/data/models/login_model.dart';
import 'package:subqdocs_bloc/features/settings/data/models/settings_office_location_response.dart';
import 'package:subqdocs_bloc/features/settings/domain/repositories/settings_repository.dart';
import 'package:subqdocs_bloc/features/settings/presentation/utils/settings_profile_merge.dart';

part 'settings_event.dart';
part 'settings_state.dart';

final class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc({required SettingsRepository settingsRepository})
    : _settingsRepository = settingsRepository,
      super(const SettingsInitial()) {
    on<SettingsStarted>(_onStarted);
    on<SettingsLogoutPressed>(_onLogoutPressed);
    on<SettingsDeleteAccountPressed>(_onDeleteAccountPressed);
    on<SettingsProfileSaveRequested>(_onProfileSaveRequested);
    on<SettingsEditPanelOpened>(_onEditPanelOpened);
    on<SettingsEditPanelOpenConsumed>(_onEditPanelOpenConsumed);
    on<SettingsEditPanelClosed>(_onEditPanelClosed);
    on<SettingsOfficeLocationSelectionToggled>(
      _onOfficeLocationSelectionToggled,
    );
    on<SettingsOfficeLocationSelectionCleared>(
      _onOfficeLocationSelectionCleared,
    );
    on<SettingsOfficeLocationDropdownToggled>(_onOfficeLocationDropdownToggled);
  }

  final SettingsRepository _settingsRepository;

  bool _isSuccessResponse(String? responseType) {
    final String? type = responseType?.toLowerCase().trim();
    return type == 'success';
  }

  String _fallbackLoadFailure(String? message) {
    final String trimmed = message?.trim() ?? '';
    return trimmed.isNotEmpty ? trimmed : AppStrings.settingsLoadUserFailure;
  }

  List<int> _seedOfficeLocationIds(User user) {
    final List<int> fromLocations = user.officeLocations
        .map((OfficeLocation office) => office.id)
        .whereType<int>()
        .toList();
    if (fromLocations.isNotEmpty) {
      return fromLocations;
    }
    return user.officeLocationIds.toList();
  }

  List<int> _reconcileOfficeLocationIds({
    required List<int> selectedIds,
    required List<SettingsOfficeLocation> options,
  }) {
    final Set<int> validOptionIds = options
        .map((SettingsOfficeLocation office) => office.id)
        .whereType<int>()
        .toSet();
    return selectedIds.where(validOptionIds.contains).toList();
  }

  Future<void> _handleError(
    Object error,
    Emitter<SettingsState> emit,
    SettingsState Function(String? message) onFailure,
  ) async {
    if (error is UnauthorizedApiException) {
      await UnauthorizedSessionHandler.handleHttpUnauthorized();
      if (!isClosed) {
        emit(const SettingsLoggedOut());
      }
      return;
    }
    if (isClosed) {
      return;
    }
    emit(onFailure(error is ApiException ? error.message : null));
  }

  Future<void> _onStarted(
    SettingsStarted event,
    Emitter<SettingsState> emit,
  ) async {
    emit(const SettingsLoading());
    try {
      final CurrentUserResponse result = await _settingsRepository
          .fetchCurrentUser();
      if (isClosed) {
        return;
      }
      if (_isSuccessResponse(result.responseType) &&
          result.responseData != null) {
        await _settingsRepository.persistSessionUser(result.responseData!);
        await SessionUserInfo.hydrate();
        if (isClosed) {
          return;
        }
        emit(
          SettingsReady(
            user: result.responseData!,
            selectedOfficeLocationIds: _seedOfficeLocationIds(
              result.responseData!,
            ),
          ),
        );
        return;
      }
      emit(SettingsLoadFailed(message: _fallbackLoadFailure(result.message)));
    } catch (e) {
      await _handleError(
        e,
        emit,
        (String? msg) => SettingsLoadFailed(message: _fallbackLoadFailure(msg)),
      );
    }
  }

  Future<void> _onProfileSaveRequested(
    SettingsProfileSaveRequested event,
    Emitter<SettingsState> emit,
  ) async {
    final User fallbackUser = switch (state) {
      SettingsReady(:final user) => user,
      SettingsProfileSaveFailed(:final user) => user,
      _ => event.user,
    };
    final SettingsReady? readySnapshot = switch (state) {
      SettingsReady r => r,
      _ => null,
    };
    try {
      final CurrentUserResponse result = await _settingsRepository
          .updateCurrentUser(
            event.user,
            profileImageFilePath: event.profileImageFilePath,
            deleteProfileImage: event.deleteProfileImage,
          );
      if (isClosed) {
        return;
      }
      if (_isSuccessResponse(result.responseType)) {
        final User persisted = mergeUserAfterProfileSave(
          event.user,
          result.responseData,
        );
        final String? responseToken = result.responseData?.token?.trim();
        await _settingsRepository.persistSessionUser(
          persisted,
          token: (responseToken != null && responseToken.isNotEmpty)
              ? responseToken
              : null,
        );
        await SessionUserInfo.hydrate();
        if (isClosed) {
          return;
        }
        if (readySnapshot != null) {
          emit(readySnapshot.copyWith(user: persisted));
        } else {
          emit(SettingsReady(user: persisted));
        }
        return;
      }
      emit(
        SettingsProfileSaveFailed(
          user: fallbackUser,
          message: _fallbackLoadFailure(result.message),
        ),
      );
    } catch (e) {
      await _handleError(
        e,
        emit,
        (String? msg) => SettingsProfileSaveFailed(
          user: fallbackUser,
          message: _fallbackLoadFailure(msg),
        ),
      );
    }
  }

  Future<void> _onEditPanelOpened(
    SettingsEditPanelOpened event,
    Emitter<SettingsState> emit,
  ) async {
    final SettingsState current = state;
    if (current is! SettingsReady) {
      return;
    }
    final List<int> seededIds = current.selectedOfficeLocationIds.isNotEmpty
        ? current.selectedOfficeLocationIds
        : _seedOfficeLocationIds(current.user);
    emit(
      current.copyWith(
        shouldOpenEditPanel: true,
        isEditPanelOpen: true,
        isOfficeLocationsLoading: true,
        selectedOfficeLocationIds: seededIds,
        isOfficeLocationDropdownOpen: false,
        clearOfficeLocationsError: true,
      ),
    );

    try {
      final SettingsOfficeLocationResponse response = await _settingsRepository
          .fetchOfficeLocations();
      if (isClosed) {
        return;
      }
      final SettingsState maybeLatest = state;
      if (maybeLatest is! SettingsReady) {
        return;
      }
      if (_isSuccessResponse(response.responseType)) {
        emit(
          maybeLatest.copyWith(
            isOfficeLocationsLoading: false,
            officeLocations: response.responseData,
            selectedOfficeLocationIds: _reconcileOfficeLocationIds(
              selectedIds: maybeLatest.selectedOfficeLocationIds,
              options: response.responseData,
            ),
            clearOfficeLocationsError: true,
          ),
        );
        return;
      }
      final String trimmed = response.message?.trim() ?? '';
      emit(
        maybeLatest.copyWith(
          isOfficeLocationsLoading: false,
          officeLocationsErrorMessage: trimmed.isNotEmpty
              ? trimmed
              : AppStrings.settingsOfficeLocationsLoadFailure,
        ),
      );
    } catch (e) {
      final SettingsState maybeLatest = state;
      if (maybeLatest is! SettingsReady) {
        return;
      }
      await _handleError(e, emit, (String? msg) {
        final String trimmed = msg?.trim() ?? '';
        return maybeLatest.copyWith(
          isOfficeLocationsLoading: false,
          officeLocationsErrorMessage: trimmed.isNotEmpty
              ? trimmed
              : AppStrings.settingsOfficeLocationsLoadFailure,
        );
      });
    }
  }

  void _onEditPanelOpenConsumed(
    SettingsEditPanelOpenConsumed event,
    Emitter<SettingsState> emit,
  ) {
    final SettingsState current = state;
    if (current is! SettingsReady || !current.shouldOpenEditPanel) {
      return;
    }
    emit(current.copyWith(shouldOpenEditPanel: false));
  }

  void _onEditPanelClosed(
    SettingsEditPanelClosed event,
    Emitter<SettingsState> emit,
  ) {
    final SettingsState current = state;
    if (current is! SettingsReady) {
      return;
    }
    emit(
      current.copyWith(
        isEditPanelOpen: false,
        isOfficeLocationDropdownOpen: false,
      ),
    );
  }

  void _onOfficeLocationSelectionToggled(
    SettingsOfficeLocationSelectionToggled event,
    Emitter<SettingsState> emit,
  ) {
    final SettingsState current = state;
    if (current is! SettingsReady) {
      return;
    }
    final List<int> next = current.selectedOfficeLocationIds.toList();
    if (next.contains(event.officeLocationId)) {
      next.remove(event.officeLocationId);
    } else {
      next.add(event.officeLocationId);
    }
    emit(current.copyWith(selectedOfficeLocationIds: next));
  }

  void _onOfficeLocationSelectionCleared(
    SettingsOfficeLocationSelectionCleared event,
    Emitter<SettingsState> emit,
  ) {
    final SettingsState current = state;
    if (current is! SettingsReady) {
      return;
    }
    if (current.selectedOfficeLocationIds.isEmpty) {
      return;
    }
    emit(current.copyWith(selectedOfficeLocationIds: const <int>[]));
  }

  void _onOfficeLocationDropdownToggled(
    SettingsOfficeLocationDropdownToggled event,
    Emitter<SettingsState> emit,
  ) {
    final SettingsState current = state;
    if (current is! SettingsReady) {
      return;
    }
    emit(current.copyWith(isOfficeLocationDropdownOpen: event.isOpen));
  }

  Future<void> _onLogoutPressed(
    SettingsLogoutPressed event,
    Emitter<SettingsState> emit,
  ) async {
    final User? user = switch (state) {
      SettingsReady(:final user) => user,
      SettingsLoggingOut(:final user) => user,
      SettingsLoggedOut(:final user) => user,
      _ => null,
    };
    emit(SettingsLoggingOut(user: user));
    await _settingsRepository.logout();
    if (isClosed) {
      return;
    }
    emit(SettingsLoggedOut(user: user));
  }

  Future<void> _onDeleteAccountPressed(
    SettingsDeleteAccountPressed event,
    Emitter<SettingsState> emit,
  ) async {
    final User user = switch (state) {
      SettingsReady(:final user) => user,
      SettingsDeletingAccount(:final user) => user,
      SettingsDeleteAccountFailed(:final user) => user,
      SettingsProfileSaveFailed(:final user) => user,
      _ => User(id: event.userId),
    };

    emit(SettingsDeletingAccount(user: user));
    try {
      final CurrentUserResponse result = await _settingsRepository
          .deleteCurrentUser(event.userId);
      if (isClosed) {
        return;
      }
      if (_isSuccessResponse(result.responseType)) {
        await _settingsRepository.logout();
        if (isClosed) {
          return;
        }
        emit(SettingsLoggedOut(user: user));
        return;
      }
      emit(
        SettingsDeleteAccountFailed(
          user: user,
          message: _fallbackLoadFailure(result.message),
        ),
      );
    } catch (e) {
      await _handleError(
        e,
        emit,
        (String? msg) => SettingsDeleteAccountFailed(
          user: user,
          message: _fallbackLoadFailure(msg),
        ),
      );
    }
  }
}
