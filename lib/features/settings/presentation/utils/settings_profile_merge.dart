import 'package:subqdocs_bloc/core/utils/date_formatters.dart';
import 'package:subqdocs_bloc/data/models/login_model.dart';

/// Normalizes phone to 10 digits (US) for [User.contactNo], or empty string.
String settingsNormalizeContactSave(String maskedOrRaw) {
  final String d = maskedOrRaw.replaceAll(RegExp(r'\D'), '');
  // if (d.isEmpty) {
  //   return '';
  // }
  // if (d.length == 11 && d.startsWith('1')) {
  //   return d.substring(1);
  // }
  // if (d.length == 10) {
  //   return d;
  // }
  return d;
}

/// Formats stored contact for the `+1 (###) ###-####` mask initial value.
String settingsFormatPhoneMaskInitial(String? raw) {
  if (raw == null || raw.trim().isEmpty) {
    return '';
  }
  final String d = raw.replaceAll(RegExp(r'\D'), '');
  if (d.isEmpty) {
    return '';
  }
  final String ten = d.length == 11 && d.startsWith('1')
      ? d.substring(1)
      : (d.length >= 10 ? d.substring(d.length - 10) : '');
  if (ten.length != 10) {
    return raw.trim();
  }
  return '+1 (${ten.substring(0, 3)}) ${ten.substring(3, 6)}-${ten.substring(6)}';
}

String? _emptyToNull(String? s) {
  final String t = s?.trim() ?? '';
  return t.isEmpty ? null : t;
}

/// Returns a new [User] with profile form fields applied; other fields copied
/// from [base].
User mergeUserFromProfileForm(
  User base, {
  required String firstName,
  required String lastName,
  required String email,
  required String contactNormalized,
  required bool isDoctor,
  String? title,
  String? degree,
  String? medicalLicenseNumber,
  DateTime? licenseExpiry,
  String? nationalProviderIdentifier,
  String? taxonomyCode,
  String? specialization,
  required List<int> officeLocationIds,
  required List<OfficeLocation> officeLocations,
  bool applyProfileImageOverride = false,
  String? profileImage,
}) {
  final dynamic licenseValue = !isDoctor
      ? base.licenseExpiryDate
      : (licenseExpiry == null
            ? base.licenseExpiryDate
            : formatYyyyMmDd(licenseExpiry));

  return User(
    thirdPartyId: base.thirdPartyId,
    id: base.id,
    email: email,
    firstName: firstName,
    lastName: lastName,
    token: base.token,
    organizationId: base.organizationId,
    secret2Fa: base.secret2Fa,
    profileImage: applyProfileImageOverride ? profileImage : base.profileImage,
    degree: isDoctor ? _emptyToNull(degree) : base.degree,
    otp: base.otp,
    pin: base.pin,
    otpToken: base.otpToken,
    otpGeneratedAt: base.otpGeneratedAt,
    lastLoginDate: base.lastLoginDate,
    hasAcceptedTerms: base.hasAcceptedTerms,
    updateInTerms: base.updateInTerms,
    termsUpdatedAt: base.termsUpdatedAt,
    isAdmin: base.isAdmin,
    role: base.role,
    status: base.status,
    contactNo: contactNormalized.isEmpty ? null : contactNormalized,
    country: base.country,
    state: base.state,
    stateCode: base.stateCode,
    city: base.city,
    streetName: base.streetName,
    postalCode: base.postalCode,
    title: isDoctor ? _emptyToNull(title) : base.title,
    medicalLicenseNumber: isDoctor
        ? _emptyToNull(medicalLicenseNumber)
        : base.medicalLicenseNumber,
    licenseExpiryDate: licenseValue,
    nationalProviderIdentifier: isDoctor
        ? _emptyToNull(nationalProviderIdentifier)
        : base.nationalProviderIdentifier,
    taxonomyCode: isDoctor ? _emptyToNull(taxonomyCode) : base.taxonomyCode,
    specialization: isDoctor
        ? _emptyToNull(specialization)
        : base.specialization,
    uploadedAt: base.uploadedAt,
    invitationToken: base.invitationToken,
    suspended: base.suspended,
    secondaryEmail: base.secondaryEmail,
    dataSource: base.dataSource,
    thirdPartySyncDate: base.thirdPartySyncDate,
    thirdPartyLastUpdated: base.thirdPartyLastUpdated,
    optumObjectId: base.optumObjectId,
    optumUsername: base.optumUsername,
    optumPassword: base.optumPassword,
    optumDae: base.optumDae,
    optumNpi: base.optumNpi,
    optumUpin: base.optumUpin,
    optumCanRefill: base.optumCanRefill,
    isMultiLanguagePreference: base.isMultiLanguagePreference,
    isHidden: base.isHidden,
    isUnsubscribed: base.isUnsubscribed,
    guidedTour: base.guidedTour,
    createdAt: base.createdAt,
    updatedAt: base.updatedAt,
    deletedAt: base.deletedAt,
    officeLocationIds: officeLocationIds,
    officeLocations: officeLocations,
    organizationName: base.organizationName,
    subscriptionPeriod: base.subscriptionPeriod,
  );
}

/// Prefer server-returned profile image URL and token after a successful save.
User mergeUserAfterProfileSave(User submitted, User? server) {
  if (server == null) {
    return submitted;
  }
  final String trimmedToken = server.token?.trim() ?? '';
  final String? nextToken = trimmedToken.isNotEmpty
      ? trimmedToken
      : submitted.token;
  return User(
    thirdPartyId: submitted.thirdPartyId,
    id: submitted.id,
    email: submitted.email,
    firstName: submitted.firstName,
    lastName: submitted.lastName,
    token: nextToken,
    organizationId: submitted.organizationId,
    secret2Fa: submitted.secret2Fa,
    profileImage: server.profileImage ?? submitted.profileImage,
    degree: submitted.degree,
    otp: submitted.otp,
    pin: submitted.pin,
    otpToken: submitted.otpToken,
    otpGeneratedAt: submitted.otpGeneratedAt,
    lastLoginDate: submitted.lastLoginDate,
    hasAcceptedTerms: submitted.hasAcceptedTerms,
    updateInTerms: submitted.updateInTerms,
    termsUpdatedAt: submitted.termsUpdatedAt,
    isAdmin: submitted.isAdmin,
    role: submitted.role,
    status: submitted.status,
    contactNo: submitted.contactNo,
    country: submitted.country,
    state: submitted.state,
    stateCode: submitted.stateCode,
    city: submitted.city,
    streetName: submitted.streetName,
    postalCode: submitted.postalCode,
    title: submitted.title,
    medicalLicenseNumber: submitted.medicalLicenseNumber,
    licenseExpiryDate: submitted.licenseExpiryDate,
    nationalProviderIdentifier: submitted.nationalProviderIdentifier,
    taxonomyCode: submitted.taxonomyCode,
    specialization: submitted.specialization,
    uploadedAt: submitted.uploadedAt,
    invitationToken: submitted.invitationToken,
    suspended: submitted.suspended,
    secondaryEmail: submitted.secondaryEmail,
    dataSource: submitted.dataSource,
    thirdPartySyncDate: submitted.thirdPartySyncDate,
    thirdPartyLastUpdated: submitted.thirdPartyLastUpdated,
    optumObjectId: submitted.optumObjectId,
    optumUsername: submitted.optumUsername,
    optumPassword: submitted.optumPassword,
    optumDae: submitted.optumDae,
    optumNpi: submitted.optumNpi,
    optumUpin: submitted.optumUpin,
    optumCanRefill: submitted.optumCanRefill,
    isMultiLanguagePreference: submitted.isMultiLanguagePreference,
    isHidden: submitted.isHidden,
    isUnsubscribed: submitted.isUnsubscribed,
    guidedTour: submitted.guidedTour,
    createdAt: submitted.createdAt,
    updatedAt: submitted.updatedAt,
    deletedAt: submitted.deletedAt,
    officeLocationIds: submitted.officeLocationIds,
    officeLocations: submitted.officeLocations,
    organizationName: submitted.organizationName,
    subscriptionPeriod: submitted.subscriptionPeriod,
  );
}
