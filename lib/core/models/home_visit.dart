/// Visit row parsed from [HomeModels] static JSON.
final class HomeVisit {
  const HomeVisit({
    required this.visitId,
    required this.visitDateUtc,
    required this.visitTimeUtc,
    required this.visitStatus,
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.age,
    required this.profileImageUrl,
    required this.visitTypeName,
    required this.visitTypeDescription,
  });

  final int visitId;
  final DateTime visitDateUtc;
  final DateTime visitTimeUtc;
  final String visitStatus;
  final String firstName;
  final String lastName;
  final String? gender;
  final int? age;
  final String? profileImageUrl;
  final String? visitTypeName;
  final String? visitTypeDescription;

  factory HomeVisit.fromJson(Map<String, dynamic> json) {
    final Object? visitDateRaw = json['visit_date'];
    final Object? visitTimeRaw = json['visit_time'];
    return HomeVisit(
      visitId: json['visit_id'] as int,
      visitDateUtc: visitDateRaw != null
          ? DateTime.parse(visitDateRaw as String)
          : DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
      visitTimeUtc: visitTimeRaw != null
          ? DateTime.parse(visitTimeRaw as String)
          : DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
      visitStatus: (json['visit_status'] as String?)?.trim() ?? '',
      firstName: (json['first_name'] as String?)?.trim() ?? '',
      lastName: (json['last_name'] as String?)?.trim() ?? '',
      gender: (json['gender'] as String?)?.trim(),
      age: json['age'] as int?,
      profileImageUrl: (json['profile_image'] as String?)?.trim(),
      visitTypeName: (json['visitTypeName'] as String?)?.trim(),
      visitTypeDescription: (json['visit_type_description'] as String?)?.trim(),
    );
  }
}
