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

final class SettingsDeleteAccountPressed extends SettingsEvent {
  const SettingsDeleteAccountPressed({required this.userId});

  final int userId;
}

final class SettingsProfileSaveRequested extends SettingsEvent {
  const SettingsProfileSaveRequested({required this.user});

  final User user;
}

final class SettingsEditPanelOpened extends SettingsEvent {
  const SettingsEditPanelOpened();
}

final class SettingsEditPanelOpenConsumed extends SettingsEvent {
  const SettingsEditPanelOpenConsumed();
}

final class SettingsEditPanelClosed extends SettingsEvent {
  const SettingsEditPanelClosed();
}

final class SettingsOfficeLocationSelectionToggled extends SettingsEvent {
  const SettingsOfficeLocationSelectionToggled({
    required this.officeLocationId,
  });

  final int officeLocationId;
}

final class SettingsOfficeLocationSelectionCleared extends SettingsEvent {
  const SettingsOfficeLocationSelectionCleared();
}

final class SettingsOfficeLocationDropdownToggled extends SettingsEvent {
  const SettingsOfficeLocationDropdownToggled({required this.isOpen});

  final bool isOpen;
}
