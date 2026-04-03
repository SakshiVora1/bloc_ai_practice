import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:subqdocs_bloc/core/constants/app_preferences_keys.dart';
import 'package:subqdocs_bloc/core/services/app_preferences.dart';
import 'package:subqdocs_bloc/data/models/login_model.dart';

part 'splash_screen_event.dart';

part 'splash_screen_state.dart';

class SplashScreenBloc extends Bloc<SplashScreenEvent, SplashScreenState> {
  SplashScreenBloc({AppPreferences? preferences})
    : _preferences = preferences ?? AppPreferences.instance,
      super(const SplashScreenInitial()) {
    on<SplashStarted>(_onStarted);
  }

  final AppPreferences _preferences;

  Future<void> _onStarted(
    SplashStarted event,
    Emitter<SplashScreenState> emit,
  ) async {
    await _preferences.initialize();
    final String? raw = await _preferences.getString(
      AppPreferencesKeys.loginResponse,
    );
    if (isClosed) {
      return;
    }
    emit(SplashComplete(hasSession: _hasBearerToken(raw)));
  }

  static bool _hasBearerToken(String? raw) {
    if (raw == null || raw.trim().isEmpty) {
      return false;
    }
    try {
      final LoginModel model = loginModelFromJson(raw);
      final String? t = model.responseData?.token?.trim();
      return t != null && t.isNotEmpty;
    } catch (_) {
      return false;
    }
  }
}
