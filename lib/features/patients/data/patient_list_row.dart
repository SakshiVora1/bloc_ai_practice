import 'package:meta/meta.dart';

@immutable
final class PatientListRow {
  const PatientListRow({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.fullName,
    required this.profileImageUrl,
    required this.initials,
    required this.age,
    required this.genderRaw,
    required this.lastVisitDate,
    required this.previousVisitCount,
    this.officeLocationId,
    this.email,
    this.contactNo,
    this.dateOfBirth,
    this.address,
    this.city,
    this.state,
    this.postalCode,
  });

  /// Placeholder row for [Skeletonizer] loading layout.
  factory PatientListRow.skeleton() {
    return const PatientListRow(
      id: -1,
      firstName: '',
      lastName: '',
      fullName: 'Patient name placeholder',
      profileImageUrl: null,
      initials: 'P',
      age: 0,
      genderRaw: 'X',
      lastVisitDate: '—',
      previousVisitCount: 0,
    );
  }

  final int id;
  final String firstName;
  final String lastName;
  final String fullName;
  final String? profileImageUrl;
  final String initials;
  final int? age;
  final String? genderRaw;
  final String? lastVisitDate;
  final int previousVisitCount;
  final int? officeLocationId;
  final String? email;
  final String? contactNo;
  final String? dateOfBirth;
  final String? address;
  final String? city;
  final String? state;
  final String? postalCode;

  factory PatientListRow.fromApiJson(Map<String, dynamic> json) {
    final String first = (json['first_name'] as String?)?.trim() ?? '';
    final String last = (json['last_name'] as String?)?.trim() ?? '';
    final String combined = '$first $last'.trim();
    final String displayName = combined.isNotEmpty ? combined : '—';
    final String initials = _initialsFrom(
      first: first,
      last: last,
      fallback: displayName,
    );

    final dynamic ageRaw = json['age'];
    final int? age = ageRaw is int
        ? ageRaw
        : ageRaw is num
        ? ageRaw.toInt()
        : int.tryParse(ageRaw?.toString() ?? '');

    final dynamic prevRaw = json['previousVisitCount'];
    final int previousVisitCount = prevRaw is int
        ? prevRaw
        : prevRaw is num
        ? prevRaw.toInt()
        : int.tryParse(prevRaw?.toString() ?? '') ?? 0;

    final dynamic idRaw = json['id'];
    final int id = idRaw is int
        ? idRaw
        : idRaw is num
        ? idRaw.toInt()
        : int.tryParse(idRaw?.toString() ?? '') ?? 0;

    final dynamic offIdRaw = json['office_location_id'];
    final int? officeLocationId = offIdRaw is int
        ? offIdRaw
        : offIdRaw is num
        ? offIdRaw.toInt()
        : int.tryParse(offIdRaw?.toString() ?? '');

    return PatientListRow(
      id: id,
      firstName: first,
      lastName: last,
      fullName: displayName,
      profileImageUrl:
          (json['profile_image'] as String?)?.trim().isEmpty ?? true
          ? null
          : (json['profile_image'] as String?)?.trim(),
      initials: initials,
      age: age,
      genderRaw: (json['gender'] as String?)?.trim(),
      lastVisitDate: (json['lastVisitDate'] as String?)?.trim().isEmpty ?? true
          ? null
          : (json['lastVisitDate'] as String?)?.trim(),
      previousVisitCount: previousVisitCount,
      officeLocationId: officeLocationId,
      email: (json['email'] as String?)?.trim(),
      contactNo: (json['contact_no'] as String?)?.trim(),
      dateOfBirth: (json['dob'] as String?)?.trim(),
      address: (json['street_address'] as String?)?.trim(),
      city: (json['city'] as String?)?.trim(),
      state: (json['state'] as String?)?.trim(),
      postalCode: (json['zipcode'] as String?)?.trim(),
    );
  }

  static String _initialsFrom({
    required String first,
    required String last,
    required String fallback,
  }) {
    if (first.isNotEmpty && last.isNotEmpty) {
      return '${_firstRuneUpper(first)}${_firstRuneUpper(last)}';
    }
    if (first.isNotEmpty) {
      return _firstRuneUpper(first);
    }
    if (last.isNotEmpty) {
      return _firstRuneUpper(last);
    }
    final String t = fallback.trim();
    if (t.isEmpty) {
      return '?';
    }
    return _firstRuneUpper(t);
  }

  static String _firstRuneUpper(String s) {
    if (s.isEmpty) {
      return '';
    }
    return String.fromCharCode(s.runes.first).toUpperCase();
  }
}
