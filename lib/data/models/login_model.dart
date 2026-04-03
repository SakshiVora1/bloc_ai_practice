import 'dart:convert';

LoginModel loginModelFromJson(String str) =>
    LoginModel.fromJson(json.decode(str) as Map<String, dynamic>);

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

/// API envelope for `auth/login`.
class LoginModel {
  LoginModel({this.responseData, this.message, this.toast, this.responseType});

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
    responseData: json['responseData'] == null
        ? null
        : ResponseData.fromJson(
            Map<String, dynamic>.from(json['responseData'] as Map),
          ),
    message: json['message'] as String?,
    toast: json['toast'] as bool?,
    responseType: json['response_type'] as String?,
  );

  ResponseData? responseData;
  String? message;
  bool? toast;
  String? responseType;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'responseData': responseData?.toJson(),
    'message': message,
    'toast': toast,
    'response_type': responseType,
  };
}

class ResponseData {
  ResponseData({this.user, this.token});

  factory ResponseData.fromJson(Map<String, dynamic> json) => ResponseData(
    user: json['user'] == null
        ? null
        : User.fromJson(Map<String, dynamic>.from(json['user'] as Map)),
    token: json['token'] as String?,
  );

  User? user;
  String? token;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'user': user?.toJson(),
    'token': token,
  };
}

/// Session user returned by login / `user` APIs. Fields mirror server JSON
/// (snake_case in [toJson]); [fromJson] accepts common key spellings.
class User {
  User({
    this.thirdPartyId,
    this.id,
    this.email,
    this.firstName,
    this.lastName,
    this.token,
    this.organizationId,
    this.secret2Fa,
    this.profileImage,
    this.degree,
    this.otp,
    this.pin,
    this.otpToken,
    this.otpGeneratedAt,
    this.lastLoginDate,
    this.hasAcceptedTerms,
    this.updateInTerms,
    this.termsUpdatedAt,
    this.isAdmin,
    this.role,
    this.status,
    this.contactNo,
    this.country,
    this.state,
    this.stateCode,
    this.city,
    this.streetName,
    this.postalCode,
    this.title,
    this.medicalLicenseNumber,
    this.licenseExpiryDate,
    this.nationalProviderIdentifier,
    this.taxonomyCode,
    this.specialization,
    this.uploadedAt,
    this.invitationToken,
    this.suspended,
    this.secondaryEmail,
    this.dataSource,
    this.thirdPartySyncDate,
    this.thirdPartyLastUpdated,
    this.optumObjectId,
    this.optumUsername,
    this.optumPassword,
    this.optumDae,
    this.optumNpi,
    this.optumUpin,
    this.optumCanRefill,
    this.isMultiLanguagePreference,
    this.isHidden,
    this.isUnsubscribed,
    this.guidedTour,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.officeLocationIds,
    this.officeLocations,
    this.organizationName,
    this.subscriptionPeriod,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    int? readInt(Object? v) {
      if (v == null) {
        return null;
      }
      if (v is int) {
        return v;
      }
      if (v is String) {
        return int.tryParse(v);
      }
      return null;
    }

    bool? readBool(Object? v) {
      if (v == null) {
        return null;
      }
      if (v is bool) {
        return v;
      }
      if (v is String) {
        if (v == 'true') {
          return true;
        }
        if (v == 'false') {
          return false;
        }
      }
      if (v is num) {
        return v != 0;
      }
      return null;
    }

    return User(
      thirdPartyId: readInt(json['third_party_id'] ?? json['thirdPartyId']),
      id: readInt(json['id']),
      email: json['email'] as String?,
      firstName: json['first_name'] as String? ?? json['firstName'] as String?,
      lastName: json['last_name'] as String? ?? json['lastName'] as String?,
      token: json['token'] as String?,
      organizationId: readInt(
        json['organization_id'] ?? json['organizationId'],
      ),
      secret2Fa: json['secret_2fa'] as String? ?? json['secret2Fa'] as String?,
      profileImage:
          json['profile_image'] as String? ?? json['profileImage'] as String?,
      degree: json['degree'] as String?,
      otp: json['otp'] as String?,
      pin: json['pin'] as String?,
      otpToken: json['otp_token'] as String? ?? json['otpToken'] as String?,
      otpGeneratedAt:
          json['otp_generated_at'] as String? ??
          json['otpGeneratedAt'] as String?,
      lastLoginDate:
          json['last_login_date'] as String? ??
          json['lastLoginDate'] as String?,
      hasAcceptedTerms: readBool(
        json['has_accepted_terms'] ?? json['hasAcceptedTerms'],
      ),
      updateInTerms: readBool(json['update_in_terms'] ?? json['updateInTerms']),
      termsUpdatedAt:
          json['terms_updated_at'] as String? ??
          json['termsUpdatedAt'] as String?,
      isAdmin: readBool(json['is_admin'] ?? json['isAdmin']),
      role: json['role'] as String?,
      status: json['status'] as String?,
      contactNo: json['contact_no'] as String? ?? json['contactNo'] as String?,
      country: json['country'] as String?,
      state: json['state'] as String?,
      stateCode: json['state_code'] as String? ?? json['stateCode'] as String?,
      city: json['city'] as String?,
      streetName:
          json['street_name'] as String? ?? json['streetName'] as String?,
      postalCode:
          json['postal_code'] as String? ?? json['postalCode'] as String?,
      title: json['title'] as String?,
      medicalLicenseNumber:
          json['medical_license_number'] as String? ??
          json['medicalLicenseNumber'] as String?,
      licenseExpiryDate:
          json['license_expiry_date'] as String? ??
          json['licenseExpiryDate'] as String?,
      nationalProviderIdentifier:
          json['national_provider_identifier'] as String? ??
          json['nationalProviderIdentifier'] as String?,
      taxonomyCode:
          json['taxonomy_code'] as String? ?? json['taxonomyCode'] as String?,
      specialization: json['specialization'] as String?,
      uploadedAt:
          json['uploaded_at'] as String? ?? json['uploadedAt'] as String?,
      invitationToken:
          json['invitation_token'] as String? ??
          json['invitationToken'] as String?,
      suspended: readBool(json['suspended']),
      secondaryEmail:
          json['secondary_email'] as String? ??
          json['secondaryEmail'] as String?,
      dataSource:
          json['data_source'] as String? ?? json['dataSource'] as String?,
      thirdPartySyncDate:
          json['third_party_sync_date'] as String? ??
          json['thirdPartySyncDate'] as String?,
      thirdPartyLastUpdated:
          json['third_party_last_updated'] as String? ??
          json['thirdPartyLastUpdated'] as String?,
      optumObjectId:
          json['optum_object_id'] as String? ??
          json['optumObjectId'] as String?,
      optumUsername:
          json['optum_username'] as String? ?? json['optumUsername'] as String?,
      optumPassword:
          json['optum_password'] as String? ?? json['optumPassword'] as String?,
      optumDae: json['optum_dae'] as String? ?? json['optumDae'] as String?,
      optumNpi: json['optum_npi'] as String? ?? json['optumNpi'] as String?,
      optumUpin: json['optum_upin'] as String? ?? json['optumUpin'] as String?,
      optumCanRefill: readBool(
        json['optum_can_refill'] ?? json['optumCanRefill'],
      ),
      isMultiLanguagePreference: readBool(
        json['is_multi_language_preference'] ??
            json['isMultiLanguagePreference'],
      ),
      isHidden: readBool(json['is_hidden'] ?? json['isHidden']),
      isUnsubscribed: readBool(
        json['is_unsubscribed'] ?? json['isUnsubscribed'],
      ),
      guidedTour: readBool(json['guided_tour'] ?? json['guidedTour']),
      createdAt: json['created_at'] as String? ?? json['createdAt'] as String?,
      updatedAt: json['updated_at'] as String? ?? json['updatedAt'] as String?,
      deletedAt: json['deleted_at'] as String? ?? json['deletedAt'] as String?,
      officeLocationIds:
          json['office_location_ids'] ?? json['officeLocationIds'],
      officeLocations: json['office_locations'] ?? json['officeLocations'],
      organizationName:
          json['organization_name'] as String? ??
          json['organizationName'] as String?,
      subscriptionPeriod:
          json['subscription_period'] as String? ??
          json['subscriptionPeriod'] as String?,
    );
  }

  final int? thirdPartyId;
  int? id;
  String? email;
  String? firstName;
  String? lastName;
  String? token;
  final int? organizationId;
  final String? secret2Fa;
  final String? profileImage;
  final String? degree;
  final String? otp;
  final String? pin;
  final String? otpToken;
  final String? otpGeneratedAt;
  final String? lastLoginDate;
  final bool? hasAcceptedTerms;
  final bool? updateInTerms;
  final String? termsUpdatedAt;
  final bool? isAdmin;
  final String? role;
  final String? status;
  String? contactNo;
  final String? country;
  final String? state;
  final String? stateCode;
  final String? city;
  final String? streetName;
  final String? postalCode;
  String? title;
  String? medicalLicenseNumber;
  Object? licenseExpiryDate;
  String? nationalProviderIdentifier;
  String? taxonomyCode;
  String? specialization;
  final String? uploadedAt;
  final String? invitationToken;
  final bool? suspended;
  final String? secondaryEmail;
  final String? dataSource;
  final String? thirdPartySyncDate;
  final String? thirdPartyLastUpdated;
  final String? optumObjectId;
  final String? optumUsername;
  final String? optumPassword;
  final String? optumDae;
  final String? optumNpi;
  final String? optumUpin;
  final bool? optumCanRefill;
  final bool? isMultiLanguagePreference;
  final bool? isHidden;
  final bool? isUnsubscribed;
  final bool? guidedTour;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;
  final Object? officeLocationIds;
  final Object? officeLocations;
  final String? organizationName;
  final String? subscriptionPeriod;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'third_party_id': thirdPartyId,
    'id': id,
    'email': email,
    'first_name': firstName,
    'last_name': lastName,
    'token': token,
    'organization_id': organizationId,
    'secret_2fa': secret2Fa,
    'profile_image': profileImage,
    'degree': degree,
    'otp': otp,
    'pin': pin,
    'otp_token': otpToken,
    'otp_generated_at': otpGeneratedAt,
    'last_login_date': lastLoginDate,
    'has_accepted_terms': hasAcceptedTerms,
    'update_in_terms': updateInTerms,
    'terms_updated_at': termsUpdatedAt,
    'is_admin': isAdmin,
    'role': role,
    'status': status,
    'contact_no': contactNo,
    'country': country,
    'state': state,
    'state_code': stateCode,
    'city': city,
    'street_name': streetName,
    'postal_code': postalCode,
    'title': title,
    'medical_license_number': medicalLicenseNumber,
    'license_expiry_date': licenseExpiryDate,
    'national_provider_identifier': nationalProviderIdentifier,
    'taxonomy_code': taxonomyCode,
    'specialization': specialization,
    'uploaded_at': uploadedAt,
    'invitation_token': invitationToken,
    'suspended': suspended,
    'secondary_email': secondaryEmail,
    'data_source': dataSource,
    'third_party_sync_date': thirdPartySyncDate,
    'third_party_last_updated': thirdPartyLastUpdated,
    'optum_object_id': optumObjectId,
    'optum_username': optumUsername,
    'optum_password': optumPassword,
    'optum_dae': optumDae,
    'optum_npi': optumNpi,
    'optum_upin': optumUpin,
    'optum_can_refill': optumCanRefill,
    'is_multi_language_preference': isMultiLanguagePreference,
    'is_hidden': isHidden,
    'is_unsubscribed': isUnsubscribed,
    'guided_tour': guidedTour,
    'created_at': createdAt,
    'updated_at': updatedAt,
    'deleted_at': deletedAt,
    'office_location_ids': officeLocationIds,
    'office_locations': officeLocations,
    'organization_name': organizationName,
    'subscription_period': subscriptionPeriod,
  };
}
