part of 'patients_screen_bloc.dart';

sealed class PatientsScreenEvent {
  const PatientsScreenEvent();
}

final class PatientsScreenStarted extends PatientsScreenEvent {
  const PatientsScreenStarted();
}

final class PatientsSearchQueryChanged extends PatientsScreenEvent {
  const PatientsSearchQueryChanged(this.query);

  final String query;
}

final class PatientsSearchDebounced extends PatientsScreenEvent {
  const PatientsSearchDebounced(this.query);

  final String query;
}

final class PatientsSearchCleared extends PatientsScreenEvent {
  const PatientsSearchCleared();
}

final class PatientsSortColumnPressed extends PatientsScreenEvent {
  const PatientsSortColumnPressed(this.column);

  final PatientSortColumn column;
}

final class PatientsLoadMoreRequested extends PatientsScreenEvent {
  const PatientsLoadMoreRequested();
}

final class PatientsRetryRequested extends PatientsScreenEvent {
  const PatientsRetryRequested();
}

final class PatientsLoadMoreErrorConsumed extends PatientsScreenEvent {
  const PatientsLoadMoreErrorConsumed();
}
