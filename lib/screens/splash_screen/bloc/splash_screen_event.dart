part of 'splash_screen_bloc.dart';

@immutable
sealed class SplashScreenEvent {
  const SplashScreenEvent();
}

final class SplashScreenStarted extends SplashScreenEvent {
  const SplashScreenStarted();
}

final class SplashScreenTimerFinished extends SplashScreenEvent {
  const SplashScreenTimerFinished();
}
