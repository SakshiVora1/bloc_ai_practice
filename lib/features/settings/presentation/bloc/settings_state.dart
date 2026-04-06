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
  const SettingsReady({
    required this.user,
    this.shouldOpenEditPanel = false,
    this.isEditPanelOpen = false,
    this.isOfficeLocationsLoading = false,
    this.officeLocationsErrorMessage,
    this.officeLocations = const <SettingsOfficeLocation>[],
    this.selectedOfficeLocationIds = const <int>[],
    this.isOfficeLocationDropdownOpen = false,
  });

  final User user;
  final bool shouldOpenEditPanel;
  final bool isEditPanelOpen;
  final bool isOfficeLocationsLoading;
  final String? officeLocationsErrorMessage;
  final List<SettingsOfficeLocation> officeLocations;
  final List<int> selectedOfficeLocationIds;
  final bool isOfficeLocationDropdownOpen;

  SettingsReady copyWith({
    User? user,
    bool? shouldOpenEditPanel,
    bool? isEditPanelOpen,
    bool? isOfficeLocationsLoading,
    String? officeLocationsErrorMessage,
    bool clearOfficeLocationsError = false,
    List<SettingsOfficeLocation>? officeLocations,
    List<int>? selectedOfficeLocationIds,
    bool? isOfficeLocationDropdownOpen,
  }) {
    return SettingsReady(
      user: user ?? this.user,
      shouldOpenEditPanel: shouldOpenEditPanel ?? this.shouldOpenEditPanel,
      isEditPanelOpen: isEditPanelOpen ?? this.isEditPanelOpen,
      isOfficeLocationsLoading:
          isOfficeLocationsLoading ?? this.isOfficeLocationsLoading,
      officeLocationsErrorMessage: clearOfficeLocationsError
          ? null
          : (officeLocationsErrorMessage ?? this.officeLocationsErrorMessage),
      officeLocations: officeLocations ?? this.officeLocations,
      selectedOfficeLocationIds:
          selectedOfficeLocationIds ?? this.selectedOfficeLocationIds,
      isOfficeLocationDropdownOpen:
          isOfficeLocationDropdownOpen ?? this.isOfficeLocationDropdownOpen,
    );
  }
}

final class SettingsLoadFailed extends SettingsState {
  const SettingsLoadFailed({required this.message});

  final String message;
}

final class SettingsProfileSaveFailed extends SettingsState {
  const SettingsProfileSaveFailed({required this.user, required this.message});

  final User user;
  final String message;
}

final class SettingsLoggingOut extends SettingsState {
  const SettingsLoggingOut({this.user});

  final User? user;
}

final class SettingsDeletingAccount extends SettingsState {
  const SettingsDeletingAccount({required this.user});

  final User user;
}

final class SettingsDeleteAccountFailed extends SettingsState {
  const SettingsDeleteAccountFailed({
    required this.user,
    required this.message,
  });

  final User user;
  final String message;
}

final class SettingsLoggedOut extends SettingsState {
  const SettingsLoggedOut({this.user});

  final User? user;
}
