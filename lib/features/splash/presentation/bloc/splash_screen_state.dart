part of 'splash_screen_bloc.dart';

@immutable
sealed class SplashScreenState {
  const SplashScreenState();
}

final class SplashScreenInitial extends SplashScreenState {
  const SplashScreenInitial();
}

final class SplashComplete extends SplashScreenState {
  const SplashComplete({required this.hasSession});

  final bool hasSession;
}
