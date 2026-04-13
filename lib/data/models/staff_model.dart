class StaffOfficeLocation {
  StaffOfficeLocation({
    required this.id,
    required this.name,
  });

  factory StaffOfficeLocation.fromJson(Map<String, dynamic> json) {
    return StaffOfficeLocation(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
    );
  }

  final int id;
  final String name;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class StaffModel {
  StaffModel({
    required this.id,
    required this.name,
    this.profileImage,
    this.dataSource,
    this.optumNpi,
    this.deletedAt,
    this.canSendPrescriptionOnBehalf,
    this.role,
    this.isAdmin,
    this.delegatedDoctors,
    this.officeLocations,
    this.officeLocationId,
  });

  factory StaffModel.fromJson(Map<String, dynamic> json) {
    return StaffModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      profileImage: json['profile_image'] as String?,
      dataSource: json['data_source'] as String?,
      optumNpi: json['optum_NPI'] as String?,
      deletedAt: json['deleted_at'] as String?,
      canSendPrescriptionOnBehalf: json['can_send_prescription_on_behalf'] as bool?,
      role: json['role'] as String?,
      isAdmin: json['is_admin'] as bool?,
      delegatedDoctors: json['delegatedDoctors'] as List<dynamic>?,
      officeLocations: (json['office_locations'] as List<dynamic>?)
          ?.map((e) => StaffOfficeLocation.fromJson(e as Map<String, dynamic>))
          .toList(),
      officeLocationId: json['office_location_id'] as int?,
    );
  }

  final int id;
  final String name;
  final String? profileImage;
  final String? dataSource;
  final String? optumNpi;
  final String? deletedAt;
  final bool? canSendPrescriptionOnBehalf;
  final String? role;
  final bool? isAdmin;
  final List<dynamic>? delegatedDoctors;
  final List<StaffOfficeLocation>? officeLocations;
  final int? officeLocationId;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'profile_image': profileImage,
      'data_source': dataSource,
      'optum_NPI': optumNpi,
      'deleted_at': deletedAt,
      'can_send_prescription_on_behalf': canSendPrescriptionOnBehalf,
      'role': role,
      'is_admin': isAdmin,
      'delegatedDoctors': delegatedDoctors,
      if (officeLocations != null)
        'office_locations': officeLocations!.map((e) => e.toJson()).toList(),
      'office_location_id': officeLocationId,
    };
  }
}
