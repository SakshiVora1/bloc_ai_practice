part of 'login_screen_bloc.dart';

@immutable
sealed class LoginScreenEvent {
  const LoginScreenEvent();
}

final class LoginSubmitted extends LoginScreenEvent {
  const LoginSubmitted({required this.email, required this.password});

  final String email;
  final String password;
}

final class LoginPasswordVisibilityToggled extends LoginScreenEvent {
  const LoginPasswordVisibilityToggled();
}

final class LoginRememberMeChanged extends LoginScreenEvent {
  const LoginRememberMeChanged(this.value);

  final bool value;
}
