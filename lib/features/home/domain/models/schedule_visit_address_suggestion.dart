import 'package:meta/meta.dart';

@immutable
final class ScheduleVisitAddressSuggestion {
  const ScheduleVisitAddressSuggestion({
    required this.placeId,
    required this.description,
    this.primaryText,
    this.secondaryText,
  });

  final String placeId;
  final String description;
  final String? primaryText;
  final String? secondaryText;
}

@immutable
final class ScheduleVisitAddressDetails {
  const ScheduleVisitAddressDetails({
    required this.streetAddress,
    required this.city,
    required this.state,
    required this.postalCode,
  });

  final String streetAddress;
  final String city;
  final String state;
  final String postalCode;
}
