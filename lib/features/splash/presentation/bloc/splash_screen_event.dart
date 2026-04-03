part of 'splash_screen_bloc.dart';

@immutable
sealed class SplashScreenEvent {
  const SplashScreenEvent();
}

final class SplashStarted extends SplashScreenEvent {
  const SplashStarted();
}
