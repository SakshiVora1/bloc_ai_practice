/// Row model for the Patients table (mapped from API in the repository).
final class PatientListRow {
  const PatientListRow({
    required this.id,
    required this.fullName,
    required this.profileImageUrl,
    required this.initials,
    required this.ageDisplay,
    required this.genderInitial,
    required this.lastVisitDisplay,
    required this.previousVisitsCount,
    required this.visitId,
  });

  final int id;
  final String fullName;
  final String? profileImageUrl;
  final String initials;
  final String ageDisplay;
  final String genderInitial;
  final String lastVisitDisplay;
  final int previousVisitsCount;
  final int? visitId;
}
