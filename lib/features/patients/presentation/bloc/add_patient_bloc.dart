import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subqdocs_bloc/core/models/country_option.dart';
import 'package:subqdocs_bloc/data/models/office_location_model.dart';
import 'package:subqdocs_bloc/data/models/staff_model.dart';
import 'package:subqdocs_bloc/data/models/visit_type_model.dart';
import 'package:subqdocs_bloc/features/home/domain/repositories/home_repository.dart';
import 'package:subqdocs_bloc/features/patients/data/patient_list_row.dart';
import 'package:subqdocs_bloc/features/patients/data/patients_list_api_envelope.dart';
import 'package:subqdocs_bloc/features/patients/domain/repositories/patients_repository.dart';
import 'package:subqdocs_bloc/features/home/domain/models/schedule_visit_address_suggestion.dart';
import 'package:subqdocs_bloc/features/patients/domain/patient_attachment.dart';

part 'add_patient_event.dart';
part 'add_patient_state.dart';

class AddPatientBloc extends Bloc<AddPatientEvent, AddPatientState> {
  final PatientsRepository patientsRepository;
  final HomeRepository homeRepository;

  AddPatientBloc({
    required this.patientsRepository,
    required this.homeRepository,
  }) : super(const AddPatientState()) {
    on<AddPatientStarted>(_onStarted);
    on<AddPatientTypeChanged>(_onTypeChanged);
    on<AddPatientFirstNameChanged>(_onFirstNameChanged);
    on<AddPatientMiddleNameChanged>(_onMiddleNameChanged);
    on<AddPatientLastNameChanged>(_onLastNameChanged);
    on<AddPatientDateOfBirthChanged>(_onDateOfBirthChanged);
    on<AddPatientGenderChanged>(_onGenderChanged);
    on<AddPatientEmailChanged>(_onEmailChanged);
    on<AddPatientPhoneChanged>(_onPhoneChanged);
    on<AddPatientCountryChanged>(_onCountryChanged);
    on<AddPatientStreetAddressChanged>(_onStreetAddressChanged);
    on<AddPatientCityChanged>(_onCityChanged);
    on<AddPatientStateChanged>(_onStateChanged);
    on<AddPatientZipCodeChanged>(_onZipCodeChanged);
    on<AddPatientVisitDateChanged>(_onVisitDateChanged);
    on<AddPatientVisitTimeChanged>(_onVisitTimeChanged);
    on<AddPatientPhoneCountryChanged>(_onPhoneCountryChanged);
    on<AddPatientVisitTypeChanged>(_onVisitTypeChanged);
    on<AddPatientProviderChanged>(_onProviderChanged);
    on<AddPatientOfficeLocationChanged>(_onOfficeLocationChanged);
    on<AddPatientNoteChanged>(_onNoteChanged);
    on<AddPatientImageChanged>(_onImageChanged);
    on<AddPatientAttachmentAdded>(_onAttachmentAdded);
    on<AddPatientAttachmentRemoved>(_onAttachmentRemoved);
    on<AddPatientClearFormRequested>(_onClearFormRequested);
    on<AddPatientSaveRequested>(_onSaveRequested);
    on<AddPatientSearchSuggestionsRequested>(_onSearchSuggestionsRequested);
    on<AddPatientSelectedFromSearch>(_onPatientSelectedFromSearch);
    on<AddPatientStreetAddressSuggestionsRequested>(
      _onStreetAddressSuggestionsRequested,
    );
    on<AddPatientStreetAddressSelected>(_onStreetAddressSelected);
  }

  Future<void> _onStarted(
    AddPatientStarted event,
    Emitter<AddPatientState> emit,
  ) async {
    emit(state.copyWith(status: AddPatientStatus.loading, successMessage: null));
    try {
      final String patientId = await patientsRepository.getLatestPatientId();
      final results = await Future.wait([
        homeRepository.getOfficeLocations(),
        homeRepository.getUsersByRole(role: 'Doctor'),
        homeRepository.getVisitTypes(limit: 50, isVisibleToUser: true),
      ]);
      final officeLocations = results[0] as List<OfficeLocationModel>;
      final providers = results[1] as List<StaffModel>;
      final visitTypes = results[2] as List<VisitTypeModel>;

      emit(
        state.copyWith(
          status: AddPatientStatus.initial,
          patientId: patientId,
          allOfficeLocations: officeLocations,
          allProviders: providers,
          allVisitTypes: visitTypes,
          officeLocation: officeLocations.isNotEmpty ? officeLocations.first : null,
          provider: providers.isNotEmpty ? providers.first : null,
          visitType: visitTypes.isNotEmpty ? visitTypes.first : null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: AddPatientStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void _onTypeChanged(AddPatientTypeChanged event, Emitter<AddPatientState> emit) {
    emit(state.copyWith(patientType: event.patientType));
  }

  void _onFirstNameChanged(
    AddPatientFirstNameChanged event,
    Emitter<AddPatientState> emit,
  ) {
    emit(state.copyWith(firstName: event.firstName));
  }

  void _onMiddleNameChanged(
    AddPatientMiddleNameChanged event,
    Emitter<AddPatientState> emit,
  ) {
    emit(state.copyWith(middleName: event.middleName));
  }

  void _onLastNameChanged(
    AddPatientLastNameChanged event,
    Emitter<AddPatientState> emit,
  ) {
    emit(state.copyWith(lastName: event.lastName));
  }

  void _onDateOfBirthChanged(
    AddPatientDateOfBirthChanged event,
    Emitter<AddPatientState> emit,
  ) {
    emit(state.copyWith(dateOfBirth: event.dateOfBirth));
  }

  void _onGenderChanged(
    AddPatientGenderChanged event,
    Emitter<AddPatientState> emit,
  ) {
    emit(state.copyWith(gender: event.gender));
  }

  void _onEmailChanged(
    AddPatientEmailChanged event,
    Emitter<AddPatientState> emit,
  ) {
    emit(state.copyWith(email: event.email));
  }

  void _onPhoneChanged(
    AddPatientPhoneChanged event,
    Emitter<AddPatientState> emit,
  ) {
    emit(state.copyWith(phone: event.phone));
  }

  void _onCountryChanged(
    AddPatientCountryChanged event,
    Emitter<AddPatientState> emit,
  ) {
    emit(
      state.copyWith(
        country: event.country,
        streetAddress: '',
        city: '',
        state: '',
        zipCode: '',
      ),
    );
  }

  void _onStreetAddressChanged(
    AddPatientStreetAddressChanged event,
    Emitter<AddPatientState> emit,
  ) {
    emit(state.copyWith(streetAddress: event.streetAddress));
  }

  void _onCityChanged(AddPatientCityChanged event, Emitter<AddPatientState> emit) {
    emit(state.copyWith(city: event.city));
  }

  void _onStateChanged(AddPatientStateChanged event, Emitter<AddPatientState> emit) {
    emit(state.copyWith(state: event.state));
  }

  void _onZipCodeChanged(
    AddPatientZipCodeChanged event,
    Emitter<AddPatientState> emit,
  ) {
    emit(state.copyWith(zipCode: event.zipCode));
  }

  void _onVisitDateChanged(
    AddPatientVisitDateChanged event,
    Emitter<AddPatientState> emit,
  ) {
    emit(state.copyWith(visitDate: event.visitDate));
  }

  void _onVisitTimeChanged(
    AddPatientVisitTimeChanged event,
    Emitter<AddPatientState> emit,
  ) {
    emit(state.copyWith(visitTime: event.visitTime));
  }

  void _onPhoneCountryChanged(
    AddPatientPhoneCountryChanged event,
    Emitter<AddPatientState> emit,
  ) {
    emit(state.copyWith(phoneCountry: event.country));
  }

  void _onVisitTypeChanged(
    AddPatientVisitTypeChanged event,
    Emitter<AddPatientState> emit,
  ) {
    emit(state.copyWith(visitType: event.visitType));
  }

  void _onProviderChanged(
    AddPatientProviderChanged event,
    Emitter<AddPatientState> emit,
  ) {
    emit(state.copyWith(provider: event.provider));
  }

  void _onOfficeLocationChanged(
    AddPatientOfficeLocationChanged event,
    Emitter<AddPatientState> emit,
  ) {
    emit(state.copyWith(officeLocation: event.officeLocation));
  }

  void _onNoteChanged(AddPatientNoteChanged event, Emitter<AddPatientState> emit) {
    emit(state.copyWith(note: event.note));
  }

  void _onImageChanged(
    AddPatientImageChanged event,
    Emitter<AddPatientState> emit,
  ) {
    emit(
      state.copyWith(
        profileImagePath: event.isRemoved ? null : event.imagePath,
      ),
    );
  }

  void _onAttachmentAdded(
    AddPatientAttachmentAdded event,
    Emitter<AddPatientState> emit,
  ) {
    final List<PatientAttachment> newAttachments =
        List<PatientAttachment>.from(state.attachments)..add(event.attachment);
    emit(state.copyWith(attachments: newAttachments));
  }

  void _onAttachmentRemoved(
    AddPatientAttachmentRemoved event,
    Emitter<AddPatientState> emit,
  ) {
    final List<PatientAttachment> newAttachments =
        List<PatientAttachment>.from(state.attachments)..removeAt(event.index);
    emit(state.copyWith(attachments: newAttachments));
  }

  void _onClearFormRequested(
    AddPatientClearFormRequested event,
    Emitter<AddPatientState> emit,
  ) {
    emit(
      AddPatientState(
        patientId: state.patientId,
        allOfficeLocations: state.allOfficeLocations,
        allProviders: state.allProviders,
        allVisitTypes: state.allVisitTypes,
      ),
    );
  }

  Future<void> _onSaveRequested(
    AddPatientSaveRequested event,
    Emitter<AddPatientState> emit,
  ) async {
    emit(state.copyWith(status: AddPatientStatus.saving));
    try {
      // TODO: Implement save logic using repository
      // For now, mock success
      await Future.delayed(const Duration(seconds: 1));
      if (event.addAnother) {
        add(const AddPatientClearFormRequested());
        add(const AddPatientStarted());
        emit(
          state.copyWith(
            status: AddPatientStatus.initial,
            successMessage: 'Patient saved successfully. Ready for next.',
          ),
        );
      } else {
        emit(state.copyWith(status: AddPatientStatus.success, saveSuccess: true));
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: AddPatientStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onSearchSuggestionsRequested(
    AddPatientSearchSuggestionsRequested event,
    Emitter<AddPatientState> emit,
  ) async {
    final String query = event.query.trim();
    if (query.isEmpty) {
      event.completer.complete(const <PatientListRow>[]);
      return;
    }
    try {
      final PatientsListApiEnvelope envelope = await homeRepository.fetchPatients(
        page: 1,
        limit: 15,
        search: query,
      );
      final List<PatientListRow> rows = envelope.responseData?.rows ?? [];
      event.completer.complete(rows);
    } catch (e) {
      event.completer.complete(const <PatientListRow>[]);
    }
  }

  void _onPatientSelectedFromSearch(
    AddPatientSelectedFromSearch event,
    Emitter<AddPatientState> emit,
  ) {
    final PatientListRow p = event.patient;
    emit(
      state.copyWith(
        firstName: p.firstName,
        lastName: p.lastName,
        gender: p.genderRaw ?? 'Undeclared',
        email: p.email ?? '',
        phone: p.contactNo ?? '',
        patientType: 'Existing Patient',
        streetAddress: p.address ?? '',
        city: p.city ?? '',
        state: p.state ?? '',
        zipCode: p.postalCode ?? '',
      ),
    );
  }

  Future<void> _onStreetAddressSuggestionsRequested(
    AddPatientStreetAddressSuggestionsRequested event,
    Emitter<AddPatientState> emit,
  ) async {
    final String query = event.query.trim();
    if (query.isEmpty) {
      event.completer.complete(const <ScheduleVisitAddressSuggestion>[]);
      return;
    }
    try {
      final List<ScheduleVisitAddressSuggestion> suggestions =
          await homeRepository.fetchStreetAddressSuggestions(
            search: query,
            country: event.country,
          );
      event.completer.complete(suggestions);
    } catch (e) {
      event.completer.complete(const <ScheduleVisitAddressSuggestion>[]);
    }
  }

  Future<void> _onStreetAddressSelected(
    AddPatientStreetAddressSelected event,
    Emitter<AddPatientState> emit,
  ) async {
    emit(state.copyWith(streetAddress: event.suggestion.description));
    try {
      final ScheduleVisitAddressDetails details = await homeRepository
          .fetchStreetAddressDetails(placeId: event.suggestion.placeId);
      emit(
        state.copyWith(
          streetAddress: details.streetAddress,
          city: details.city,
          state: details.state,
          zipCode: details.postalCode,
        ),
      );
    } catch (e) {
      // Keep manual address if details fetch fails
    }
  }
}
