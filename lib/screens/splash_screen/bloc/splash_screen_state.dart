part of 'splash_screen_bloc.dart';

@immutable
sealed class SplashScreenState {
  const SplashScreenState();
}

final class SplashScreenInitial extends SplashScreenState {
  const SplashScreenInitial();
}

final class SplashScreenReadyForLogin extends SplashScreenState {
  const SplashScreenReadyForLogin();
}
