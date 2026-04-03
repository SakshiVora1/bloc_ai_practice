import 'package:subqdocs_bloc/core/utils/date_formatters.dart';
import 'package:subqdocs_bloc/data/models/login_model.dart';

String? _licenseExpiryForUpdateApi(dynamic value) {
  if (value == null) {
    return null;
  }
  if (value is DateTime) {
    return formatYyyyMmDd(value.toLocal());
  }
  final DateTime? parsed = tryParseDate(value);
  if (parsed != null) {
    return formatYyyyMmDd(parsed.toLocal());
  }
  final String raw = value.toString().trim();
  return raw.isEmpty ? null : raw;
}

/// JSON body for `PUT user` (snake_case keys expected by the API).
Map<String, dynamic> settingsUserUpdateRequestBody(User user) {
  return <String, dynamic>{
    'first_name': user.firstName,
    'last_name': user.lastName,
    'email': user.email,
    'organization_name': user.organizationName,
    'contact_no': user.contactNo,
    'country': user.country,
    'state': user.state,
    'city': user.city,
    'street_name': user.streetName,
    'postal_code': user.postalCode,
    'title': user.title,
    'medical_license_number': user.medicalLicenseNumber,
    'specialization': user.specialization,
    'taxonomy_code': user.taxonomyCode,
    'national_provider_identifier': user.nationalProviderIdentifier,
    'license_expiry_date': _licenseExpiryForUpdateApi(user.licenseExpiryDate),
    'degree': user.degree,
    'pin': user.pin,
    'office_location_ids': _officeLocationIdsList(user),
  };
}

List<int> _officeLocationIdsList(User user) {
  final Object? raw = user.officeLocationIds;
  if (raw is List<int>) {
    return raw;
  }
  if (raw is List<dynamic>) {
    return raw
        .map((dynamic e) {
          if (e is int) {
            return e;
          }
          if (e is String) {
            return int.tryParse(e) ?? 0;
          }
          return 0;
        })
        .where((int id) => id != 0)
        .toList();
  }
  return <int>[];
}
