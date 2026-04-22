part of 'add_patient_bloc.dart';

enum AddPatientStatus { initial, loading, success, failure, saving }

class AddPatientState {
  const AddPatientState({
    this.status = AddPatientStatus.initial,
    this.patientId = '',
    this.patientType = 'New Patient',
    this.firstName = '',
    this.middleName = '',
    this.lastName = '',
    this.dateOfBirth,
    this.gender = 'Undeclared',
    this.email = '',
    this.phone = '',
    this.phoneCountry = CountryOption.unitedStates,
    this.country = CountryOption.unitedStates,
    this.streetAddress = '',
    this.city = '',
    this.state = '',
    this.zipCode = '',
    this.visitDate,
    this.visitTime,
    this.visitType,
    this.provider,
    this.officeLocation,
    this.note = '',
    this.profileImagePath,
    this.attachments = const [],
    this.errorMessage,
    this.allOfficeLocations = const [],
    this.allProviders = const [],
    this.allVisitTypes = const [],
    this.saveSuccess = false,
    this.successMessage,
  });

  final AddPatientStatus status;
  final String patientId;
  final String patientType;
  final String firstName;
  final String middleName;
  final String lastName;
  final DateTime? dateOfBirth;
  final String gender;
  final String email;
  final String phone;
  final CountryOption phoneCountry;
  final CountryOption country;
  final String streetAddress;
  final String city;
  final String state;
  final String zipCode;
  final DateTime? visitDate;
  final TimeOfDay? visitTime;
  final VisitTypeModel? visitType;
  final StaffModel? provider;
  final OfficeLocationModel? officeLocation;
  final String note;
  final String? profileImagePath;
  final List<PatientAttachment> attachments;
  final String? errorMessage;
  final List<OfficeLocationModel> allOfficeLocations;
  final List<StaffModel> allProviders;
  final List<VisitTypeModel> allVisitTypes;
  final bool saveSuccess;
  final String? successMessage;

  AddPatientState copyWith({
    AddPatientStatus? status,
    String? patientId,
    String? patientType,
    String? firstName,
    String? middleName,
    String? lastName,
    DateTime? dateOfBirth,
    String? gender,
    String? email,
    String? phone,
    CountryOption? phoneCountry,
    CountryOption? country,
    String? streetAddress,
    String? city,
    String? state,
    String? zipCode,
    DateTime? visitDate,
    TimeOfDay? visitTime,
    VisitTypeModel? visitType,
    StaffModel? provider,
    OfficeLocationModel? officeLocation,
    String? note,
    String? profileImagePath,
    List<PatientAttachment>? attachments,
    String? errorMessage,
    List<OfficeLocationModel>? allOfficeLocations,
    List<StaffModel>? allProviders,
    List<VisitTypeModel>? allVisitTypes,
    bool? saveSuccess,
    String? successMessage,
  }) {
    return AddPatientState(
      status: status ?? this.status,
      patientId: patientId ?? this.patientId,
      patientType: patientType ?? this.patientType,
      firstName: firstName ?? this.firstName,
      middleName: middleName ?? this.middleName,
      lastName: lastName ?? this.lastName,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      phoneCountry: phoneCountry ?? this.phoneCountry,
      country: country ?? this.country,
      streetAddress: streetAddress ?? this.streetAddress,
      city: city ?? this.city,
      state: state ?? this.state,
      zipCode: zipCode ?? this.zipCode,
      visitDate: visitDate ?? this.visitDate,
      visitTime: visitTime ?? this.visitTime,
      visitType: visitType ?? this.visitType,
      provider: provider ?? this.provider,
      officeLocation: officeLocation ?? this.officeLocation,
      note: note ?? this.note,
      profileImagePath: profileImagePath ?? this.profileImagePath,
      attachments: attachments ?? this.attachments,
      errorMessage: errorMessage ?? this.errorMessage,
      allOfficeLocations: allOfficeLocations ?? this.allOfficeLocations,
      allProviders: allProviders ?? this.allProviders,
      allVisitTypes: allVisitTypes ?? this.allVisitTypes,
      saveSuccess: saveSuccess ?? this.saveSuccess,
      successMessage: successMessage ?? this.successMessage,
    );
  }
}
