class OrganizationRoom {
  OrganizationRoom({
    required this.id,
    this.roomNo,
  });

  factory OrganizationRoom.fromJson(Map<String, dynamic> json) {
    return OrganizationRoom(
      id: json['id'] as int? ?? 0,
      roomNo: json['room_no'] as String?,
    );
  }

  final int id;
  final String? roomNo;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'room_no': roomNo,
    };
  }
}

class OfficeLocationModel {
  OfficeLocationModel({
    required this.id,
    required this.name,
    this.organizationId,
    this.primaryOffice,
    this.timezone,
    this.externalId,
    this.streetName,
    this.city,
    this.state,
    this.stateCode,
    this.postalCode,
    this.country,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.createdBy,
    this.updatedBy,
    this.deletedBy,
    this.organizationRooms,
  });

  factory OfficeLocationModel.fromJson(Map<String, dynamic> json) {
    return OfficeLocationModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      organizationId: json['organization_id'] as int?,
      primaryOffice: json['primary_office'] as bool?,
      timezone: json['timezone'] as String?,
      externalId: json['external_id'] as String?,
      streetName: json['street_name'] as String?,
      city: json['city'] as String?,
      state: json['state'] as String?,
      stateCode: json['state_code'] as String?,
      postalCode: json['postal_code'] as String?,
      country: json['country'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      deletedAt: json['deleted_at'] as String?,
      createdBy: json['created_by'] as int?,
      updatedBy: json['updated_by'] as int?,
      deletedBy: json['deleted_by'] as int?,
      organizationRooms: (json['organization_rooms'] as List<dynamic>?)
          ?.map((e) => OrganizationRoom.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  final int id;
  final String name;
  final int? organizationId;
  final bool? primaryOffice;
  final String? timezone;
  final String? externalId;
  final String? streetName;
  final String? city;
  final String? state;
  final String? stateCode;
  final String? postalCode;
  final String? country;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;
  final int? createdBy;
  final int? updatedBy;
  final int? deletedBy;
  final List<OrganizationRoom>? organizationRooms;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'organization_id': organizationId,
      'primary_office': primaryOffice,
      'timezone': timezone,
      'external_id': externalId,
      'street_name': streetName,
      'city': city,
      'state': state,
      'state_code': stateCode,
      'postal_code': postalCode,
      'country': country,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
      'created_by': createdBy,
      'updated_by': updatedBy,
      'deleted_by': deletedBy,
      if (organizationRooms != null)
        'organization_rooms': organizationRooms!.map((e) => e.toJson()).toList(),
    };
  }
}
