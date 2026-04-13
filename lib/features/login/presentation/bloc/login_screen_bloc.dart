import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:subqdocs_bloc/core/constants/app_preferences_keys.dart';
import 'package:subqdocs_bloc/core/services/app_preferences.dart';
import 'package:subqdocs_bloc/data/models/login_model.dart';
import 'package:subqdocs_bloc/features/login/domain/repositories/login_repository.dart';

part 'login_screen_event.dart';

part 'login_screen_state.dart';

class LoginScreenBloc extends Bloc<LoginScreenEvent, LoginScreenState> {
  LoginScreenBloc({
    required LoginRepository loginRepository,
    AppPreferences? preferences,
  }) : _loginRepository = loginRepository,
       _preferences = preferences ?? AppPreferences.instance,
       super(const LoginScreenState()) {
    on<LoginSubmitted>(_onSubmitted);
    on<LoginPasswordVisibilityToggled>(_onPasswordVisibilityToggled);
    on<LoginRememberMeChanged>(_onRememberMeChanged);
  }

  final LoginRepository _loginRepository;
  final AppPreferences _preferences;

  Future<void> _onSubmitted(
    LoginSubmitted event,
    Emitter<LoginScreenState> emit,
  ) async {
    emit(state.copyWith(isSubmitting: true, errorMessage: null));
    try {
      final LoginModel model = await _loginRepository.login(
        email: event.email.trim(),
        password: event.password,
      );
      if (isClosed) {
        return;
      }
      final String? type = model.responseType?.toLowerCase();
      if (type == 'success') {
        await _preferences.setString(
          AppPreferencesKeys.loginResponse,
          loginModelToJson(model),
        );
        final String? token = model.responseData?.token?.trim();
        if (token != null && token.isNotEmpty) {
          await _preferences.setString(AppPreferencesKeys.bearerToken, token);
        }
        emit(
          state.copyWith(
            isSubmitting: false,
            didSucceed: true,
            errorMessage: null,
          ),
        );
      } else {
        emit(
          state.copyWith(
            isSubmitting: false,
            errorMessage: _nonEmptyTrimmedMessage(model),
          ),
        );
      }
    } on Exception catch (_) {
      if (isClosed) {
        return;
      }
      emit(
        state.copyWith(
          isSubmitting: false,
          errorMessage: 'Unable to log in. Please try again.',
        ),
      );
    }
  }

  void _onPasswordVisibilityToggled(
    LoginPasswordVisibilityToggled event,
    Emitter<LoginScreenState> emit,
  ) {
    emit(state.copyWith(obscurePassword: !state.obscurePassword));
  }

  void _onRememberMeChanged(
    LoginRememberMeChanged event,
    Emitter<LoginScreenState> emit,
  ) {
    emit(state.copyWith(rememberMe: event.value));
  }

  static String? _nonEmptyTrimmedMessage(LoginModel model) {
    final String? trimmed = model.message?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      return null;
    }
    return trimmed;
  }
}
