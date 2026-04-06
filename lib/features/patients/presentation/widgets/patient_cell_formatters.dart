import 'package:subqdocs_bloc/core/constants/app_strings.dart';

abstract final class PatientCellFormatters {
  PatientCellFormatters._();

  static final RegExp _genderOtherWord = RegExp(r'^other\b');

  static String ageOrNa(int? age) {
    if (age == null) {
      return AppStrings.patientsNotAvailable;
    }
    return '$age';
  }

  static String lastVisitOrNa(String? raw) {
    if (raw == null || raw.trim().isEmpty) {
      return AppStrings.patientsNotAvailable;
    }
    return raw.trim();
  }

  static String genderInitial(String? gender) {
    if (gender == null || gender.trim().isEmpty) {
      return AppStrings.patientsNotAvailable;
    }
    final String t = gender.trim();
    if (t.isEmpty) {
      return AppStrings.patientsNotAvailable;
    }
    final String lower = t.toLowerCase();
    if (lower == 'o' || _genderOtherWord.hasMatch(lower)) {
      return 'U';
    }
    return String.fromCharCode(t.runes.first).toUpperCase();
  }
}
