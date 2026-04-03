/// Sortable columns for [patient/getAllPatients] `sorting` query (`id` values).
enum PatientSortColumn {
  patientName('first_name'),
  age('age'),
  gender('gender'),
  lastVisitDate('lastVisitDate'),
  previousVisits('previousVisitCount');

  const PatientSortColumn(this.apiSortId);

  final String apiSortId;
}
