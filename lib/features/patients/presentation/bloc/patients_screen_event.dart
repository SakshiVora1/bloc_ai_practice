part of 'patients_screen_bloc.dart';

@immutable
sealed class PatientsScreenEvent {
  const PatientsScreenEvent();
}

final class PatientsScreenStarted extends PatientsScreenEvent {
  const PatientsScreenStarted();
}

final class PatientsSearchInputChanged extends PatientsScreenEvent {
  const PatientsSearchInputChanged(this.text);

  final String text;
}

final class PatientsSearchDebouncedFetch extends PatientsScreenEvent {
  const PatientsSearchDebouncedFetch();
}

final class PatientsSearchClearRequested extends PatientsScreenEvent {
  const PatientsSearchClearRequested();
}

final class PatientsSortColumnTapped extends PatientsScreenEvent {
  const PatientsSortColumnTapped(this.column);

  final PatientSortColumn column;
}

final class PatientsPreviousPageTapped extends PatientsScreenEvent {
  const PatientsPreviousPageTapped();
}

final class PatientsNextPageTapped extends PatientsScreenEvent {
  const PatientsNextPageTapped();
}

final class PatientsApiErrorToastConsumed extends PatientsScreenEvent {
  const PatientsApiErrorToastConsumed();
}
