part of 'settings_bloc.dart';

@immutable
sealed class SettingsEvent {
  const SettingsEvent();
}

final class SettingsStarted extends SettingsEvent {
  const SettingsStarted();
}

final class SettingsLogoutPressed extends SettingsEvent {
  const SettingsLogoutPressed();
}

final class SettingsProfileSaveRequested extends SettingsEvent {
  const SettingsProfileSaveRequested({required this.user});

  final User user;
}
