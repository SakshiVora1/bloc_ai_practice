import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:subqdocs_bloc/core/constants/app_strings.dart';
import 'package:subqdocs_bloc/core/models/session_user_info.dart';
import 'package:subqdocs_bloc/core/services/api_exceptions.dart';
import 'package:subqdocs_bloc/data/models/current_user_response.dart';
import 'package:subqdocs_bloc/data/models/login_model.dart';
import 'package:subqdocs_bloc/features/settings/domain/repositories/settings_repository.dart';

part 'settings_event.dart';
part 'settings_state.dart';

final class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc({required SettingsRepository settingsRepository})
    : _settingsRepository = settingsRepository,
      super(const SettingsInitial()) {
    on<SettingsStarted>(_onStarted);
    on<SettingsLogoutPressed>(_onLogoutPressed);
    on<SettingsProfileSaveRequested>(_onProfileSaveRequested);
  }

  final SettingsRepository _settingsRepository;

  bool _isSuccessResponse(String? responseType) {
    final String? type = responseType?.toLowerCase().trim();
    return type == 'success';
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
        emit(SettingsReady(user: result.responseData!));
        return;
      }
      final String trimmed = result.message?.trim() ?? '';
      final String msg = trimmed.isNotEmpty
          ? trimmed
          : AppStrings.settingsLoadUserFailure;
      emit(SettingsLoadFailed(message: msg));
    } on ApiException catch (e) {
      if (isClosed) {
        return;
      }
      final String msg = e.message.trim().isNotEmpty
          ? e.message.trim()
          : AppStrings.settingsLoadUserFailure;
      emit(SettingsLoadFailed(message: msg));
    } catch (_) {
      if (isClosed) {
        return;
      }
      emit(
        const SettingsLoadFailed(message: AppStrings.settingsLoadUserFailure),
      );
    }
  }

  Future<void> _onProfileSaveRequested(
    SettingsProfileSaveRequested event,
    Emitter<SettingsState> emit,
  ) async {
    await _settingsRepository.persistSessionUser(event.user);
    await SessionUserInfo.hydrate();
    if (isClosed) {
      return;
    }
    emit(SettingsReady(user: event.user));
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
}
