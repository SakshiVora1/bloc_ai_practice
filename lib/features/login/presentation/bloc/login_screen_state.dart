part of 'login_screen_bloc.dart';

@immutable
class LoginScreenState {
  const LoginScreenState({
    this.isSubmitting = false,
    this.obscurePassword = true,
    this.rememberMe = false,
    this.errorMessage,
    this.didSucceed = false,
  });

  final bool isSubmitting;
  final bool obscurePassword;
  final bool rememberMe;
  final String? errorMessage;
  final bool didSucceed;

  LoginScreenState copyWith({
    bool? isSubmitting,
    bool? obscurePassword,
    bool? rememberMe,
    String? errorMessage,
    bool clearErrorMessage = false,
    bool? didSucceed,
  }) {
    return LoginScreenState(
      isSubmitting: isSubmitting ?? this.isSubmitting,
      obscurePassword: obscurePassword ?? this.obscurePassword,
      rememberMe: rememberMe ?? this.rememberMe,
      errorMessage: clearErrorMessage
          ? null
          : (errorMessage ?? this.errorMessage),
      didSucceed: didSucceed ?? this.didSucceed,
    );
  }
}
