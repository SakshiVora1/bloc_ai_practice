part of 'settings_bloc.dart';

@immutable
sealed class SettingsState {
  const SettingsState();
}

final class SettingsInitial extends SettingsState {
  const SettingsInitial();
}

final class SettingsLoading extends SettingsState {
  const SettingsLoading();
}

final class SettingsReady extends SettingsState {
  const SettingsReady({required this.user});

  final User user;
}

final class SettingsLoadFailed extends SettingsState {
  const SettingsLoadFailed({required this.message});

  final String message;
}

final class SettingsLoggingOut extends SettingsState {
  const SettingsLoggingOut({this.user});

  final User? user;
}

final class SettingsLoggedOut extends SettingsState {
  const SettingsLoggedOut({this.user});

  final User? user;
}
