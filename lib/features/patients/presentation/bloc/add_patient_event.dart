part of 'add_patient_bloc.dart';

sealed class AddPatientEvent {
  const AddPatientEvent();
}

class AddPatientStarted extends AddPatientEvent {
  const AddPatientStarted();
}

class AddPatientTypeChanged extends AddPatientEvent {
  final String patientType;
  const AddPatientTypeChanged(this.patientType);
}

class AddPatientFirstNameChanged extends AddPatientEvent {
  final String firstName;
  const AddPatientFirstNameChanged(this.firstName);
}

class AddPatientMiddleNameChanged extends AddPatientEvent {
  final String middleName;
  const AddPatientMiddleNameChanged(this.middleName);
}

class AddPatientLastNameChanged extends AddPatientEvent {
  final String lastName;
  const AddPatientLastNameChanged(this.lastName);
}

class AddPatientDateOfBirthChanged extends AddPatientEvent {
  final DateTime dateOfBirth;
  const AddPatientDateOfBirthChanged(this.dateOfBirth);
}

class AddPatientGenderChanged extends AddPatientEvent {
  final String gender;
  const AddPatientGenderChanged(this.gender);
}

class AddPatientEmailChanged extends AddPatientEvent {
  final String email;
  const AddPatientEmailChanged(this.email);
}

class AddPatientPhoneChanged extends AddPatientEvent {
  final String phone;
  const AddPatientPhoneChanged(this.phone);
}

class AddPatientPhoneCountryChanged extends AddPatientEvent {
  final CountryOption country;
  const AddPatientPhoneCountryChanged(this.country);
}

class AddPatientCountryChanged extends AddPatientEvent {
  final CountryOption country;
  const AddPatientCountryChanged(this.country);
}

class AddPatientStreetAddressChanged extends AddPatientEvent {
  final String streetAddress;
  const AddPatientStreetAddressChanged(this.streetAddress);
}

class AddPatientCityChanged extends AddPatientEvent {
  final String city;
  const AddPatientCityChanged(this.city);
}

class AddPatientStateChanged extends AddPatientEvent {
  final String state;
  const AddPatientStateChanged(this.state);
}

class AddPatientZipCodeChanged extends AddPatientEvent {
  final String zipCode;
  const AddPatientZipCodeChanged(this.zipCode);
}

class AddPatientVisitDateChanged extends AddPatientEvent {
  final DateTime visitDate;
  const AddPatientVisitDateChanged(this.visitDate);
}

class AddPatientVisitTimeChanged extends AddPatientEvent {
  final TimeOfDay visitTime;
  const AddPatientVisitTimeChanged(this.visitTime);
}

class AddPatientVisitTypeChanged extends AddPatientEvent {
  final VisitTypeModel visitType;
  const AddPatientVisitTypeChanged(this.visitType);
}

class AddPatientProviderChanged extends AddPatientEvent {
  final StaffModel provider;
  const AddPatientProviderChanged(this.provider);
}

class AddPatientOfficeLocationChanged extends AddPatientEvent {
  final OfficeLocationModel officeLocation;
  const AddPatientOfficeLocationChanged(this.officeLocation);
}

class AddPatientNoteChanged extends AddPatientEvent {
  final String note;
  const AddPatientNoteChanged(this.note);
}

class AddPatientImageChanged extends AddPatientEvent {
  final String? imagePath;
  final bool isRemoved;
  const AddPatientImageChanged(this.imagePath, this.isRemoved);
}

class AddPatientAttachmentAdded extends AddPatientEvent {
  final PatientAttachment attachment;
  const AddPatientAttachmentAdded(this.attachment);
}

class AddPatientAttachmentRemoved extends AddPatientEvent {
  final int index;
  const AddPatientAttachmentRemoved(this.index);
}

class AddPatientClearFormRequested extends AddPatientEvent {
  const AddPatientClearFormRequested();
}

class AddPatientSaveRequested extends AddPatientEvent {
  final bool addAnother;
  const AddPatientSaveRequested({this.addAnother = false});
}

class AddPatientSearchSuggestionsRequested extends AddPatientEvent {
  final String query;
  final Completer<List<PatientListRow>> completer;
  const AddPatientSearchSuggestionsRequested({
    required this.query,
    required this.completer,
  });
}

class AddPatientSelectedFromSearch extends AddPatientEvent {
  final PatientListRow patient;
  const AddPatientSelectedFromSearch(this.patient);
}

class AddPatientStreetAddressSuggestionsRequested extends AddPatientEvent {
  final String query;
  final CountryOption country;
  final Completer<List<ScheduleVisitAddressSuggestion>> completer;
  const AddPatientStreetAddressSuggestionsRequested({
    required this.query,
    required this.country,
    required this.completer,
  });
}

class AddPatientStreetAddressSelected extends AddPatientEvent {
  final ScheduleVisitAddressSuggestion suggestion;
  const AddPatientStreetAddressSelected(this.suggestion);
}
