/// Sortable columns for [patient/getAllPatients] `sorting` query (maps to API `id`).
enum PatientSortColumn {
  patientName('first_name'),
  age('age'),
  gender('gender'),
  lastVisitDate('lastVisitDate'),
  previousVisits('previousVisitCount');

  const PatientSortColumn(this.apiSortId);

  final String apiSortId;
}
