class VisitModel {
  final String patientId;
  final String? dateOfBirth;
  final int visitId;
  final String? deviceId;
  final String? visitDate;
  final String? visitTime;
  final String visitStatus;
  final String firstName;
  final String lastName;
  final String gender;
  final String? profileImage;
  final String? appointmentTime;
  final int? previousVisitCount;
  final int? transcriptFileCount;
  final String? doctorName;
  final String? visitTypeName;
  final String? visitTypeDescription;
  final String? medicalAssistantName;
  final String? officeLocationName;
  final int? age;

  VisitModel({
    required this.patientId,
    this.dateOfBirth,
    required this.visitId,
    this.deviceId,
    this.visitDate,
    this.visitTime,
    required this.visitStatus,
    required this.firstName,
    required this.lastName,
    required this.gender,
    this.profileImage,
    this.appointmentTime,
    this.previousVisitCount,
    this.transcriptFileCount,
    this.doctorName,
    this.visitTypeName,
    this.visitTypeDescription,
    this.medicalAssistantName,
    this.officeLocationName,
    this.age,
  });

  factory VisitModel.fromJson(Map<String, dynamic> json) {
    return VisitModel(
      patientId: json['patient_id']?.toString() ?? '',
      dateOfBirth: json['date_of_birth']?.toString(),
      visitId: json['visit_id'] is int ? json['visit_id'] : int.tryParse(json['visit_id']?.toString() ?? '0') ?? 0,
      deviceId: json['device_id']?.toString(),
      visitDate: json['visit_date']?.toString(),
      visitTime: json['visit_time']?.toString(),
      visitStatus: json['visit_status']?.toString() ?? '',
      firstName: json['first_name']?.toString() ?? '',
      lastName: json['last_name']?.toString() ?? '',
      gender: json['gender']?.toString() ?? '',
      profileImage: json['profile_image']?.toString(),
      appointmentTime: json['appointmentTime']?.toString(),
      previousVisitCount: json['previousVisitCount'] as int?,
      transcriptFileCount: json['transcriptFileCount'] as int?,
      doctorName: json['doctorName']?.toString(),
      visitTypeName: json['visitTypeName']?.toString(),
      visitTypeDescription: json['visit_type_description']?.toString(),
      medicalAssistantName: json['medicalAssistantName']?.toString(),
      officeLocationName: json['officeLocationName']?.toString(),
      age: json['age'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'patient_id': patientId,
      'date_of_birth': dateOfBirth,
      'visit_id': visitId,
      'device_id': deviceId,
      'visit_date': visitDate,
      'visit_time': visitTime,
      'visit_status': visitStatus,
      'first_name': firstName,
      'last_name': lastName,
      'gender': gender,
      'profile_image': profileImage,
      'appointmentTime': appointmentTime,
      'previousVisitCount': previousVisitCount,
      'transcriptFileCount': transcriptFileCount,
      'doctorName': doctorName,
      'visitTypeName': visitTypeName,
      'visit_type_description': visitTypeDescription,
      'medicalAssistantName': medicalAssistantName,
      'officeLocationName': officeLocationName,
      'age': age,
    };
  }

  String get fullName => '$firstName $lastName'.trim();
}

class VisitListResponse {
  final List<VisitModel> data;
  final int filteredCount;
  final int page;
  final int limit;
  final int totalPage;

  VisitListResponse({
    required this.data,
    required this.filteredCount,
    required this.page,
    required this.limit,
    required this.totalPage,
  });

  factory VisitListResponse.fromJson(Map<String, dynamic> json) {
    final responseData = json['responseData'] as Map<String, dynamic>;
    final dataList = responseData['data'] as List<dynamic>;
    
    return VisitListResponse(
      data: dataList.map((e) => VisitModel.fromJson(e as Map<String, dynamic>)).toList(),
      filteredCount: responseData['filteredCount'] as int? ?? 0,
      page: responseData['page'] as int? ?? 1,
      limit: responseData['limit'] as int? ?? 100,
      totalPage: responseData['totalPage'] as int? ?? 1,
    );
  }
}
