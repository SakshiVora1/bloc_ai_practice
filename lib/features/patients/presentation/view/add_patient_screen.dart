import 'dart:async';
import 'dart:io';

import 'package:cupertino_calendar_picker/cupertino_calendar_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:subqdocs_bloc/core/constants/app_colors.dart';
import 'package:subqdocs_bloc/core/constants/app_fonts.dart';
import 'package:subqdocs_bloc/core/constants/app_strings.dart';
import 'package:subqdocs_bloc/core/enums/app_drawer_item.dart';
import 'package:subqdocs_bloc/core/models/country_option.dart';
import 'package:subqdocs_bloc/core/routing/app_router.dart';
import 'package:subqdocs_bloc/core/services/app_toast.dart';
import 'package:subqdocs_bloc/core/utils/date_formatters.dart';
import 'package:subqdocs_bloc/data/models/office_location_model.dart';
import 'package:subqdocs_bloc/data/models/staff_model.dart';
import 'package:subqdocs_bloc/data/models/visit_type_model.dart';
import 'package:subqdocs_bloc/features/patients/data/patient_list_row.dart';
import 'package:subqdocs_bloc/features/patients/presentation/bloc/add_patient_bloc.dart';
import 'package:subqdocs_bloc/features/patients/presentation/widgets/patient_avatar_palette.dart';
import 'package:subqdocs_bloc/widgets/common_app_drawer.dart';
import 'package:subqdocs_bloc/widgets/common_button.dart';
import 'package:subqdocs_bloc/widgets/common_text_form_field.dart';
import 'package:subqdocs_bloc/widgets/common_user_app_bar.dart';
import 'package:subqdocs_bloc/core/widgets/common_typeahead_dropdown.dart';
import 'package:subqdocs_bloc/features/home/domain/models/schedule_visit_address_suggestion.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:subqdocs_bloc/features/patients/domain/patient_attachment.dart';
import 'package:subqdocs_bloc/features/patients/presentation/widgets/add_attachments_dialog.dart';

class AddPatientScreen extends StatefulWidget {
  const AddPatientScreen({super.key});

  @override
  State<AddPatientScreen> createState() => _AddPatientScreenState();
}

class _AddPatientScreenState extends State<AddPatientScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _searchController;
  late final TextEditingController _firstNameController;
  late final TextEditingController _middleNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _countryController;
  late final TextEditingController _streetAddressController;
  late final TextEditingController _cityController;
  late final TextEditingController _stateController;
  late final TextEditingController _zipCodeController;
  late final TextEditingController _visitDateController;
  late final TextEditingController _visitTimeController;
  late final TextEditingController _visitTypeController;
  late final TextEditingController _providerController;
  late final TextEditingController _officeLocationController;
  late final TextEditingController _noteController;
  late final SuggestionsController<PatientListRow> _searchSuggestionsController;

  late final SuggestionsController<CountryOption> _countrySuggestionsController;
  late final SuggestionsController<VisitTypeModel> _visitTypeSuggestionsController;
  late final SuggestionsController<StaffModel> _providerSuggestionsController;
  late final SuggestionsController<OfficeLocationModel>
      _officeLocationSuggestionsController;
  late final SuggestionsController<ScheduleVisitAddressSuggestion>
      _streetAddressSuggestionsController;
  late final ScrollController _streetAddressSuggestionsScrollController;
  late final FocusNode _streetAddressFocusNode;
  late final FocusNode _countryFocusNode;
  late final FocusNode _phoneCountryFocusNode;

  final ValueNotifier<bool> _showPhoneCountryDropdown = ValueNotifier<bool>(false);
  final TextEditingController _phoneCountrySearchController = TextEditingController();
  final LayerLink _timeLayerLink = LayerLink();
  final LayerLink _phoneLayerLink = LayerLink();

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _firstNameController = TextEditingController();
    _middleNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _countryController = TextEditingController();
    _streetAddressController = TextEditingController();
    _cityController = TextEditingController();
    _stateController = TextEditingController();
    _zipCodeController = TextEditingController();
    _visitDateController = TextEditingController();
    _visitTimeController = TextEditingController();
    _visitTypeController = TextEditingController();
    _providerController = TextEditingController();
    _officeLocationController = TextEditingController();
    _noteController = TextEditingController();

    _searchSuggestionsController = SuggestionsController<PatientListRow>();
    _countrySuggestionsController = SuggestionsController<CountryOption>();
    _visitTypeSuggestionsController = SuggestionsController<VisitTypeModel>();
    _providerSuggestionsController = SuggestionsController<StaffModel>();
    _officeLocationSuggestionsController =
        SuggestionsController<OfficeLocationModel>();
    _streetAddressSuggestionsController =
        SuggestionsController<ScheduleVisitAddressSuggestion>();
    _streetAddressSuggestionsScrollController = ScrollController();
    _streetAddressFocusNode = FocusNode();
    _countryFocusNode = FocusNode();
    _phoneCountryFocusNode = FocusNode();

    context.read<AddPatientBloc>().add(const AddPatientStarted());
  }

  @override
  void dispose() {
    _searchController.dispose();
    _firstNameController.dispose();
    _middleNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _countryController.dispose();
    _streetAddressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipCodeController.dispose();
    _visitDateController.dispose();
    _visitTimeController.dispose();
    _visitTypeController.dispose();
    _providerController.dispose();
    _officeLocationController.dispose();
    _noteController.dispose();

    _countrySuggestionsController.dispose();
    _visitTypeSuggestionsController.dispose();
    _providerSuggestionsController.dispose();
    _officeLocationSuggestionsController.dispose();
    _searchSuggestionsController.dispose();
    _countrySuggestionsController.dispose();
    _visitTypeSuggestionsController.dispose();
    _providerSuggestionsController.dispose();
    _officeLocationSuggestionsController.dispose();
    _streetAddressSuggestionsController.dispose();
    _streetAddressSuggestionsScrollController.dispose();
    _streetAddressFocusNode.dispose();
    _countryFocusNode.dispose();
    _phoneCountryFocusNode.dispose();
    super.dispose();
  }

  void _closeAllSuggestions() {
    _searchSuggestionsController.close(retainFocus: false);
    _countrySuggestionsController.close(retainFocus: false);
    _streetAddressSuggestionsController.close(retainFocus: false);
    _visitTypeSuggestionsController.close(retainFocus: false);
    _providerSuggestionsController.close(retainFocus: false);
    _officeLocationSuggestionsController.close(retainFocus: false);
    _showPhoneCountryDropdown.value = false;
  }

  void _syncController(TextEditingController controller, String value) {
    if (controller.text == value) {
      return;
    }
    controller.value = controller.value.copyWith(
      text: value,
      selection: const TextSelection.collapsed(offset: 0),
      composing: TextRange.empty,
    );
  }

  void _syncControllers(AddPatientState state) {
    _syncController(_firstNameController, state.firstName);
    _syncController(_middleNameController, state.middleName);
    _syncController(_lastNameController, state.lastName);
    _syncController(_emailController, state.email);
    _syncController(_phoneController, state.phone);
    _syncController(_countryController, state.country.displayLabel);
    _syncController(_streetAddressController, state.streetAddress);
    _syncController(_cityController, state.city);
    _syncController(_stateController, state.state);
    _syncController(_zipCodeController, state.zipCode);
    _syncController(_visitDateController, state.visitDate != null ? formatDateMmDdYyyy(state.visitDate!) : '');
    _syncController(_visitTypeController, state.visitType?.name ?? '');
    _syncController(
      _providerController,
      state.provider != null
          ? '${AppStrings.scheduleVisitProviderPrefix} ${state.provider!.name}'
          : '',
    );
    _syncController(
        _officeLocationController, state.officeLocation?.name ?? '');
    _syncController(_noteController, state.note);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddPatientBloc, AddPatientState>(
      listener: (context, state) {
        if (state.saveSuccess) {
          AppToast.showSuccess(context, 'Patient saved successfully');
          AppRouter.pop(context);
        }
        if (state.successMessage != null) {
          AppToast.showSuccess(context, state.successMessage!);
        }
        if (state.errorMessage != null) {
          AppToast.showError(context, state.errorMessage!);
        }
      },
      child: BlocBuilder<AddPatientBloc, AddPatientState>(
        builder: (context, state) {
          _syncControllers(state);
          return Scaffold(
            backgroundColor: AppColors.addPatientBackground,
            appBar: const CommonUserAppBar(),
            onDrawerChanged: (isOpened) {
              if (isOpened) {
                FocusScope.of(context).unfocus();
                _closeAllSuggestions();
              }
            },
            drawer: const CommonAppDrawer(
              selectedItem: AppDrawerItem.patients,
            ),
            body: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
                _closeAllSuggestions();
              },
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Container(
                        margin: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.black.withValues(alpha: 0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildHeader(),
                              Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildSearchBar(state),
                                    const SizedBox(height: 20),
                                    _buildAvatar(state),
                                    const SizedBox(height: 20),
                                    _buildBasicDetails(state),
                                    const Divider(height: 40, thickness: 1, color: Color(0xFFF0F0F0)),
                                    _buildPersonalInformation(state),
                                    const Divider(height: 40, thickness: 1, color: Color(0xFFF0F0F0)),
                                    _buildAddressInformation(state),
                                    const Divider(height: 40, thickness: 1, color: Color(0xFFF0F0F0)),
                                    _buildAppointmentDetails(state),
                                    const SizedBox(height: 20),
                                    _buildAttachments(state),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  _buildBottomButtons(state),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => AppRouter.pop(context),
          ),
          const SizedBox(width: 8),
          Text(
            'Add Patient Details',
            style: AppFonts.medium(18, AppColors.primaryText),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(AddPatientState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VisibilityDetector(
          key: const Key('patient_search_dropdown'),
          onVisibilityChanged: (info) {
            if (info.visibleFraction == 0) {
              _searchSuggestionsController.close(retainFocus: false);
            }
          },
          child: CommonTypeAheadDropdown<PatientListRow>(
            controller: _searchController,
            suggestionsController: _searchSuggestionsController,
            hintText: 'Select...',
            prefixIcon: const Icon(Icons.search, color: AppColors.blueGray),
            onSelected: (patient) {
              context
                  .read<AddPatientBloc>()
                  .add(AddPatientSelectedFromSearch(patient));
            },
            suggestionsCallback: (pattern) async {
              final completer = Completer<List<PatientListRow>>();
              context.read<AddPatientBloc>().add(
                    AddPatientSearchSuggestionsRequested(
                      query: pattern,
                      completer: completer,
                    ),
                  );
              return completer.future;
            },
            itemBuilder: (context, patient) {
              return _PatientDropdownRow(
                patient: patient,
                showDivider: true,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAvatar(AddPatientState state) {
    final bool hasLocalImage = state.profileImagePath != null;
    return GestureDetector(
      onTap: () {
        // Implement image picker dialog similar to EditPanelAvatar but without add icon
        _showImagePickerDialog(context);
      },
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.textFieldBorder.withValues(alpha: 0.35),
            border: Border.all(color: AppColors.fieldBorder.withValues(alpha: 0.5)),
            image: hasLocalImage
                ? DecorationImage(
                    image: FileImage(File(state.profileImagePath!)),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          child: !hasLocalImage
              ? const Icon(Icons.person, size: 40, color: AppColors.blueGray)
              : null,
        ),
      ),
    );
  }

  void _showImagePickerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          AppStrings.settingsProfilePhotoSheetTitle,
          style: AppFonts.medium(16, AppColors.primaryText),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: const Text('Camera'),
              onTap: () {
                AppRouter.pop(dialogContext);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Gallery'),
              onTap: () {
                AppRouter.pop(dialogContext);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? file = await picker.pickImage(source: source);
      if (file != null) {
        if (mounted) {
          context
              .read<AddPatientBloc>()
              .add(AddPatientImageChanged(file.path, false));
        }
      }
    } catch (e) {
      if (mounted) {
        AppToast.showError(context, 'Failed to pick image');
      }
    }
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: AppFonts.medium(16, const Color(0xFF5B5BE1)),
      ),
    );
  }

  Widget _buildRow(List<Widget> fields, {int maxColumns = 3}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < maxColumns; i++) ...[
            Expanded(
              child: i < fields.length ? fields[i] : const SizedBox.shrink(),
            ),
            if (i < maxColumns - 1) const SizedBox(width: 16),
          ],
        ],
      ),
    );
  }

  Widget _buildFieldLayout(String label, Widget field, {bool isRequired = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: AppFonts.regular(14, AppColors.black),
            ),
            if (isRequired)
              Text(
                ' *',
                style: AppFonts.regular(14, AppColors.red),
              ),
          ],
        ),
        const SizedBox(height: 8),
        field,
      ],
    );
  }

  Widget _buildBasicDetails(AddPatientState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Basic Detail'),
        _buildRow([
          _buildFieldLayout(
            'Patient Id',
            CommonTextFormField(
              controller: TextEditingController(text: state.patientId),
              readOnly: true,
              fillColor: AppColors.homeTimeColumnBackground,
            ),
          ),
          _buildFieldLayout(
            'Patient Type',
            _buildDropdown(
              value: state.patientType,
              items: ['New Patient', 'Existing Patient'],
              onChanged: (v) {
                if (v != null) {
                  context.read<AddPatientBloc>().add(AddPatientTypeChanged(v));
                }
              },
            ),
          ),
        ]),
        _buildRow([
          _buildFieldLayout(
            'First Name',
            CommonTextFormField(
              controller: _firstNameController,
              hintText: 'First Name',
              onChanged: (v) => context
                  .read<AddPatientBloc>()
                  .add(AddPatientFirstNameChanged(v)),
              validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
            ),
            isRequired: true,
          ),
          _buildFieldLayout(
            'Middle Name',
            CommonTextFormField(
              controller: _middleNameController,
              hintText: 'Middle Name',
              onChanged: (v) => context
                  .read<AddPatientBloc>()
                  .add(AddPatientMiddleNameChanged(v)),
            ),
          ),
          _buildFieldLayout(
            'Last Name',
            CommonTextFormField(
              controller: _lastNameController,
              hintText: 'Last Name',
              onChanged: (v) => context
                  .read<AddPatientBloc>()
                  .add(AddPatientLastNameChanged(v)),
              validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
            ),
            isRequired: true,
          ),
        ]),
      ],
    );
  }

  Widget _buildPersonalInformation(AddPatientState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Personal Information'),
        _buildRow([
          _buildFieldLayout(
            'Date Of Birth',
            _DatePickerButton(
              date: state.dateOfBirth,
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
              onChanged: (date) => context
                  .read<AddPatientBloc>()
                  .add(AddPatientDateOfBirthChanged(date)),
            ),
          ),
          _buildFieldLayout(
            'Gender At Birth',
            _buildDropdown(
              value: state.gender,
              items: ['Undeclared', 'Male', 'Female'],
              onChanged: (v) {
                if (v != null) {
                  context.read<AddPatientBloc>().add(AddPatientGenderChanged(v));
                }
              },
            ),
          ),
        ]),
        _buildRow([
          _buildFieldLayout(
            'Contact Number',
            VisibilityDetector(
              key: const Key('add_patient_phone_dropdown'),
              onVisibilityChanged: (info) {
                if (info.visibleFraction == 0) {
                  _showPhoneCountryDropdown.value = false;
                }
              },
              child: _PhoneNumberField(
                selectedCountry: state.phoneCountry,
                phoneNumberController: _phoneController,
                countrySearchController: _phoneCountrySearchController,
                showDropdownListenable: _showPhoneCountryDropdown,
                link: _phoneLayerLink,
                focusNode: _phoneCountryFocusNode,
                onPhoneNumberChanged: (v) => context
                    .read<AddPatientBloc>()
                    .add(AddPatientPhoneChanged(v)),
                onCountrySelected: (country) {
                  context
                      .read<AddPatientBloc>()
                      .add(AddPatientPhoneCountryChanged(country));
                },
              ),
            ),
          ),
          _buildFieldLayout(
            'Email Address',
            CommonTextFormField(
              controller: _emailController,
              hintText: 'Email Address',
              onChanged: (v) =>
                  context.read<AddPatientBloc>().add(AddPatientEmailChanged(v)),
            ),
          ),
        ]),
      ],
    );
  }

  Widget _buildAddressInformation(AddPatientState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Address Information'),
        _buildRow([
          _buildFieldLayout(
            'Country',
            VisibilityDetector(
              key: const Key('country_dropdown'),
              onVisibilityChanged: (info) {
                if (info.visibleFraction == 0) {
                  _countrySuggestionsController.close(retainFocus: false);
                }
              },
              child: CommonTypeAheadDropdown<CountryOption>(
                controller: _countryController,
                suggestionsController: _countrySuggestionsController,
                focusNode: _countryFocusNode,
                hintText: 'Select country',
                suffixIcon: const Icon(
                  CupertinoIcons.chevron_down,
                  size: 18,
                  color: AppColors.blueGray,
                ),
                suggestionsCallback: (pattern) {
                  final String normalized = pattern.trim();
                  if (normalized.isEmpty ||
                      normalized == state.country.displayLabel ||
                      normalized == state.country.name ||
                      normalized.toLowerCase() ==
                          state.country.isoCode.toLowerCase()) {
                    return _countrySuggestions('');
                  }
                  return _countrySuggestions(pattern);
                },
                itemBuilder: (context, country) => _CountryDropdownRow(
                  country: country,
                  isSelected: country.isoCode == state.country.isoCode,
                  showDivider: _countryController.text.trim().isEmpty &&
                      country.isoCode == CountryOption.zimbabwe.isoCode,
                  onTap: () {
                    _countrySuggestionsController.close(retainFocus: false);
                    _countryFocusNode.unfocus();
                    context
                        .read<AddPatientBloc>()
                        .add(AddPatientCountryChanged(country));
                  },
                ),
                onSelected: (country) => context
                    .read<AddPatientBloc>()
                    .add(AddPatientCountryChanged(country)),
              ),
            ),
          ),
          _buildFieldLayout(
            'Street Address',
            VisibilityDetector(
              key: const Key('street_address_dropdown'),
              onVisibilityChanged: (info) {
                if (info.visibleFraction == 0) {
                  _streetAddressSuggestionsController.close(retainFocus: false);
                }
              },
              child: CommonTypeAheadDropdown<ScheduleVisitAddressSuggestion>(
                controller: _streetAddressController,
                focusNode: _streetAddressFocusNode,
                suggestionsController: _streetAddressSuggestionsController,
                scrollController: _streetAddressSuggestionsScrollController,
                hintText: 'Street Address',
                onChanged: (String value) {
                  context
                      .read<AddPatientBloc>()
                      .add(AddPatientStreetAddressChanged(value));
                },
                onClear: () {
                  _streetAddressSuggestionsController.close(retainFocus: false);
                  _streetAddressFocusNode.unfocus();
                  context
                      .read<AddPatientBloc>()
                      .add(const AddPatientStreetAddressChanged(''));
                },
                suggestionsCallback: (String pattern) async {
                  final completer =
                      Completer<List<ScheduleVisitAddressSuggestion>>();
                  context.read<AddPatientBloc>().add(
                        AddPatientStreetAddressSuggestionsRequested(
                          query: pattern,
                          country: state.country,
                          completer: completer,
                        ),
                      );
                  return completer.future;
                },
                emptyBuilder: (BuildContext context) => const SizedBox.shrink(),
                itemBuilder: (BuildContext context,
                    ScheduleVisitAddressSuggestion suggestion) {
                  return _StreetAddressDropdownRow(suggestion: suggestion);
                },
                onSelected: (ScheduleVisitAddressSuggestion suggestion) {
                  _streetAddressSuggestionsController.close(retainFocus: false);
                  _streetAddressFocusNode.unfocus();
                  context
                      .read<AddPatientBloc>()
                      .add(AddPatientStreetAddressSelected(suggestion));
                },
              ),
            ),
          ),
          _buildFieldLayout(
            'City',
            CommonTextFormField(
              controller: _cityController,
              hintText: 'City',
              onChanged: (v) =>
                  context.read<AddPatientBloc>().add(AddPatientCityChanged(v)),
            ),
          ),
        ]),
        _buildRow([
          _buildFieldLayout(
            'State',
            CommonTextFormField(
              controller: _stateController,
              hintText: 'State',
              onChanged: (v) =>
                  context.read<AddPatientBloc>().add(AddPatientStateChanged(v)),
            ),
          ),
          _buildFieldLayout(
            'Zip Code',
            CommonTextFormField(
              controller: _zipCodeController,
              hintText: 'Zip Code',
              onChanged: (v) => context
                  .read<AddPatientBloc>()
                  .add(AddPatientZipCodeChanged(v)),
            ),
          ),
        ]),
      ],
    );
  }

  Widget _buildAppointmentDetails(AddPatientState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Appointment Details'),
        _buildRow([
          _buildFieldLayout(
            'Visit Date',
            _DatePickerButton(
              date: state.visitDate,
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 365 * 10)),
              onChanged: (date) => context
                  .read<AddPatientBloc>()
                  .add(AddPatientVisitDateChanged(date)),
            ),
          ),
          _buildFieldLayout(
            'Visit Time',
            CompositedTransformTarget(
              link: _timeLayerLink,
              child: _TimePickerButton(
                time: state.visitTime == null
                    ? null
                    : DateTime(0, 0, 0, state.visitTime!.hour, state.visitTime!.minute),
                link: _timeLayerLink,
                onChanged: (time) => context
                    .read<AddPatientBloc>()
                    .add(AddPatientVisitTimeChanged(TimeOfDay.fromDateTime(time))),
              ),
            ),
          ),
          _buildFieldLayout(
            'Visit Type',
            VisibilityDetector(
              key: const Key('visit_type_dropdown'),
              onVisibilityChanged: (info) {
                if (info.visibleFraction == 0) {
                  _visitTypeSuggestionsController.close(retainFocus: false);
                }
              },
              child: CommonTypeAheadDropdown<VisitTypeModel>(
                controller: _visitTypeController,
                suggestionsController: _visitTypeSuggestionsController,
                hintText: 'Select visit type',
                suffixIcon: const Icon(
                  CupertinoIcons.chevron_down,
                  size: 18,
                  color: AppColors.blueGray,
                ),
                suggestionsCallback: (pattern) {
                  final list = state.allVisitTypes;
                  if (pattern.isEmpty || state.visitType?.name == pattern) {
                    return list;
                  }
                  return list
                      .where((t) =>
                          t.name.toLowerCase().contains(pattern.toLowerCase()))
                      .toList();
                },
                itemBuilder: (context, type) => ListTile(
                  dense: true,
                  title: Text(
                    type.name,
                    style: AppFonts.regular(14, AppColors.primaryText),
                  ),
                ),
                onSelected: (type) => context
                    .read<AddPatientBloc>()
                    .add(AddPatientVisitTypeChanged(type)),
              ),
            ),
          ),
        ]),
        _buildRow([
          _buildFieldLayout(
            'Provider',
            VisibilityDetector(
              key: const Key('provider_dropdown'),
              onVisibilityChanged: (info) {
                if (info.visibleFraction == 0) {
                  _providerSuggestionsController.close(retainFocus: false);
                }
              },
              child: CommonTypeAheadDropdown<StaffModel>(
                controller: _providerController,
                suggestionsController: _providerSuggestionsController,
                hintText: 'Select provider',
                suffixIcon: const Icon(
                  CupertinoIcons.chevron_down,
                  size: 18,
                  color: AppColors.blueGray,
                ),
                suggestionsCallback: (pattern) {
                  final list = state.allProviders;
                  final currentName = state.provider != null
                      ? '${AppStrings.scheduleVisitProviderPrefix} ${state.provider!.name}'
                      : '';
                  if (pattern.isEmpty || currentName == pattern) {
                    return list;
                  }
                  return list
                      .where((p) =>
                          p.name.toLowerCase().contains(pattern.toLowerCase()))
                      .toList();
                },
                itemBuilder: (context, provider) => ListTile(
                  dense: true,
                  title: Text(
                    provider.name,
                    style: AppFonts.regular(14, AppColors.primaryText),
                  ),
                ),
                onSelected: (provider) => context
                    .read<AddPatientBloc>()
                    .add(AddPatientProviderChanged(provider)),
              ),
            ),
          ),
          _buildFieldLayout(
            'Office Location',
            VisibilityDetector(
              key: const Key('office_location_dropdown'),
              onVisibilityChanged: (info) {
                if (info.visibleFraction == 0) {
                  _officeLocationSuggestionsController.close(retainFocus: false);
                }
              },
              child: CommonTypeAheadDropdown<OfficeLocationModel>(
                controller: _officeLocationController,
                suggestionsController: _officeLocationSuggestionsController,
                hintText: 'Select office',
                suffixIcon: const Icon(
                  CupertinoIcons.chevron_down,
                  size: 18,
                  color: AppColors.blueGray,
                ),
                suggestionsCallback: (pattern) {
                  final list = state.allOfficeLocations;
                  if (pattern.isEmpty || state.officeLocation?.name == pattern) {
                    return list;
                  }
                  return list
                      .where((l) =>
                          l.name.toLowerCase().contains(pattern.toLowerCase()))
                      .toList();
                },
                itemBuilder: (context, location) => ListTile(
                  dense: true,
                  title: Text(
                    location.name,
                    style: AppFonts.regular(14, AppColors.primaryText),
                  ),
                ),
                onSelected: (location) => context
                    .read<AddPatientBloc>()
                    .add(AddPatientOfficeLocationChanged(location)),
              ),
            ),
          ),
          const SizedBox.shrink(),
        ]),
        _buildFieldLayout(
          'Appointment Note',
          CommonTextFormField(
            controller: _noteController,
            hintText: 'Appointment Note',
            maxLines: 3,
            onChanged: (v) =>
                context.read<AddPatientBloc>().add(AddPatientNoteChanged(v)),
          ),
        ),
      ],
    );
  }

  Widget _buildAttachments(AddPatientState state) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.textFieldBorder),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: AppColors.attachmentHeaderBackground,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Attachments',
                  style: AppFonts.medium(16, AppColors.primaryText),
                ),
                const Icon(Icons.keyboard_arrow_up, color: Color(0xFF5B5BE1)),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: AppColors.textFieldBorder)),
            ),
            child: state.attachments.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: Text(
                        'Attachments Not available',
                        style: AppFonts.regular(16, AppColors.blueGray),
                      ),
                    ),
                  )
                : Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: state.attachments.asMap().entries.map((entry) {
                      final int index = entry.key;
                      final PatientAttachment attachment = entry.value;
                      return _buildAttachmentItem(attachment, index);
                    }).toList(),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttachmentItem(PatientAttachment attachment, int index) {
    return SizedBox(
      width: 140,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                height: 100,
                width: 140,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: attachment.isImage
                      ? Image.file(
                          File(attachment.path),
                          fit: BoxFit.cover,
                        )
                      : Container(
                          color: AppColors.chipSelectedBackground,
                          child: Icon(
                            _getIconForExtension(attachment.extension),
                            color: AppColors.primaryAction,
                            size: 40,
                          ),
                        ),
                ),
              ),
              Positioned(
                top: -10,
                right: -10,
                child: GestureDetector(
                  onTap: () {
                    context
                        .read<AddPatientBloc>()
                        .add(AddPatientAttachmentRemoved(index));
                  },
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: AppColors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x26000000),
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.delete_outline,
                      color: AppColors.red,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            attachment.name,
            style: AppFonts.medium(14, AppColors.blueGray),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            attachment.date,
            style: AppFonts.regular(12, AppColors.blueGray),
          ),
        ],
      ),
    );
  }

  IconData _getIconForExtension(String extension) {
    switch (extension.toLowerCase()) {
      case 'pdf':
        return Icons.picture_as_pdf_outlined;
      case 'doc':
      case 'docx':
        return Icons.description_outlined;
      case 'mp3':
      case 'wav':
        return Icons.audiotrack_outlined;
      case 'mp4':
        return Icons.videocam_outlined;
      default:
        return Icons.insert_drive_file_outlined;
    }
  }

  Widget _buildBottomButtons(AddPatientState state) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: AppColors.white,
      child: Row(
        children: [
          CommonButton(
            label: 'Add Attachments',
            fontWeight: FontWeight.w500,
            fontSize: 14,
            onPressed: _showAddAttachmentDialog,
            backgroundColor: AppColors.white,
            textColor: AppColors.drawerItemSelected,
            borderColor: AppColors.drawerItemSelected,
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 16),
          ),
          const Spacer(),
          InkWell(
            onTap: () {
              context
                  .read<AddPatientBloc>()
                  .add(const AddPatientClearFormRequested());
            },
            child: Text(
              'Clear Form',
              style: AppFonts.regular(14, AppColors.blueGray),
            ),
          ),
          const SizedBox(width: 8),
          CommonButton(
            label: 'Cancel',
            onPressed: () => AppRouter.pop(context),
            backgroundColor: AppColors.white,
            textColor: AppColors.drawerItemSelected,
            borderColor: AppColors.drawerItemSelected,
            height: 40,
            fontWeight: FontWeight.w500,
            fontSize: 14,
            padding: const EdgeInsets.symmetric(horizontal: 16),
          ),
          const SizedBox(width: 8),
          CommonButton(
            label: 'Save and Add Another',
            onPressed: () {
              if (_formKey.currentState?.validate() ?? false) {
                context
                    .read<AddPatientBloc>()
                    .add(const AddPatientSaveRequested(addAnother: true));
              }
            },
            backgroundColor: AppColors.drawerItemSelected,
            textColor: AppColors.white,
            borderColor: AppColors.drawerItemSelected,
            fontWeight: FontWeight.w500,
            fontSize: 14,
            height: 40,
            isLoading: state.status == AddPatientStatus.saving,
          ),
          const SizedBox(width: 8),
          CommonButton(
            label: 'Save',
            onPressed: () {
              if (_formKey.currentState?.validate() ?? false) {
                context
                    .read<AddPatientBloc>()
                    .add(const AddPatientSaveRequested());
              }
            },
            backgroundColor: AppColors.drawerItemSelected,
            textColor: AppColors.white,
            borderColor: AppColors.drawerItemSelected,
            fontWeight: FontWeight.w500,
            fontSize: 14,
            height: 40,
            isLoading: state.status == AddPatientStatus.saving,
          ),
        ],
      ),
    );
  }

  void _showAddAttachmentDialog() async {
    final List<PatientAttachment>? result = await showDialog<List<PatientAttachment>>(
      context: context,
      builder: (BuildContext dialogContext) => const AddAttachmentsDialog(),
    );

    if (result != null && mounted) {
      for (final attachment in result) {
        context.read<AddPatientBloc>().add(AddPatientAttachmentAdded(attachment));
      }
    }
  }

  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: AppColors.fieldBorder),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          onChanged: onChanged,
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item, style: AppFonts.regular(14, AppColors.black)),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _DatePickerButton extends StatefulWidget {
  const _DatePickerButton({
    required this.date,
    required this.onChanged,
    required this.firstDate,
    required this.lastDate,
    this.initialDate,
    this.placeholder = 'Select date',
  });

  final DateTime? date;
  final ValueChanged<DateTime> onChanged;
  final DateTime firstDate;
  final DateTime lastDate;
  final DateTime? initialDate;
  final String placeholder;

  @override
  State<_DatePickerButton> createState() => _DatePickerButtonState();
}

class _DatePickerButtonState extends State<_DatePickerButton> {
  DateTime _clampDate(DateTime value) {
    final DateTime normalizedValue = _dateOnly(value);
    final DateTime min = _dateOnly(widget.firstDate);
    final DateTime max = _dateOnly(widget.lastDate);

    if (normalizedValue.isBefore(min)) return min;
    if (normalizedValue.isAfter(max)) return max;
    return normalizedValue;
  }

  DateTime _dateOnly(DateTime value) =>
      DateTime(value.year, value.month, value.day);

  Future<void> _showPicker() async {
    final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    final DateTime initialDate =
        _clampDate(widget.date ?? widget.initialDate ?? widget.lastDate);

    final DateTime? pickedDate = await showCupertinoCalendarPicker(
      context,
      widgetRenderBox: renderBox,
      minimumDateTime: _dateOnly(widget.firstDate),
      maximumDateTime: _dateOnly(widget.lastDate),
      initialDateTime: initialDate,
      currentDateTime: _dateOnly(DateTime.now()),
      mainColor: const Color(0xFF5B5BE1),
      mode: CupertinoCalendarMode.date,
      onDateTimeChanged: (DateTime dateTime) {
        widget.onChanged(_dateOnly(dateTime));
      },
    );

    if (pickedDate != null) {
      widget.onChanged(_dateOnly(pickedDate));
    }
  }

  @override
  Widget build(BuildContext context) {
    final String formatted = widget.date == null
        ? widget.placeholder
        : formatDateMmDdYyyy(widget.date!);
    return InkWell(
      onTap: _showPicker,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.textFieldBorder),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(formatted, style: AppFonts.regular(14, AppColors.primaryText)),
            const Icon(Icons.calendar_today,
                size: 18, color: AppColors.blueGray),
          ],
        ),
      ),
    );
  }
}

class _TimePickerButton extends StatefulWidget {
  const _TimePickerButton({
    required this.time,
    required this.onChanged,
    required this.link,
  });

  final DateTime? time;
  final ValueChanged<DateTime> onChanged;
  final LayerLink link;

  @override
  State<_TimePickerButton> createState() => _TimePickerButtonState();
}

class _TimePickerButtonState extends State<_TimePickerButton> {
  OverlayEntry? _overlayEntry;

  void _toggleOverlay() {
    if (_overlayEntry == null) {
      _overlayEntry = _createOverlayEntry();
      Overlay.of(context).insert(_overlayEntry!);
    } else {
      _overlayEntry!.remove();
      _overlayEntry = null;
    }
  }

  OverlayEntry _createOverlayEntry() {
    const double h = 250;
    return OverlayEntry(
      builder: (context) => Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: _toggleOverlay,
              behavior: HitTestBehavior.opaque,
              child: Container(color: Colors.transparent),
            ),
          ),
          _buildSmartOverlay(
            context: this.context,
            link: widget.link,
            overlayHeight: h,
            child: Container(
              height: h,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.fieldBorder),
              ),
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.time,
                initialDateTime: widget.time ?? DateTime.now(),
                minuteInterval: 1,
                use24hFormat: false,
                onDateTimeChanged: (DateTime d) {
                  widget.onChanged(d);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String formatted = 'Select time';
    if (widget.time != null) {
      final hour = widget.time!.hour > 12
          ? widget.time!.hour - 12
          : (widget.time!.hour == 0 ? 12 : widget.time!.hour);
      final String amPm = widget.time!.hour >= 12 ? 'PM' : 'AM';
      final min = widget.time!.minute.toString().padLeft(2, '0');
      formatted = '$hour:$min $amPm';
    }

    return InkWell(
      onTap: _toggleOverlay,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.textFieldBorder),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(formatted, style: AppFonts.regular(14, AppColors.primaryText)),
            const Icon(Icons.access_time, size: 18, color: AppColors.blueGray),
          ],
        ),
      ),
    );
  }
}

Positioned _buildSmartOverlay({
  required BuildContext context,
  required LayerLink link,
  required Widget child,
  required double overlayHeight,
}) {
  final RenderBox renderBox = context.findRenderObject() as RenderBox;
  final size = renderBox.size;
  final offset = renderBox.localToGlobal(Offset.zero);
  final screenHeight = MediaQuery.of(context).size.height;
  final bool showAbove =
      (offset.dy + size.height + overlayHeight + 20) > screenHeight;

  return Positioned(
    width: size.width,
    child: CompositedTransformFollower(
      link: link,
      showWhenUnlinked: false,
      offset: Offset(0, showAbove ? -overlayHeight - 5 : size.height + 5),
      child: Material(
        elevation: 8,
        shadowColor: AppColors.black.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        child: child,
      ),
    ),
  );
}

class _PhoneNumberField extends StatefulWidget {
  const _PhoneNumberField({
    required this.selectedCountry,
    required this.phoneNumberController,
    required this.countrySearchController,
    required this.showDropdownListenable,
    required this.onPhoneNumberChanged,
    required this.onCountrySelected,
    required this.link,
    required this.focusNode,
  });

  final CountryOption selectedCountry;
  final TextEditingController phoneNumberController;
  final TextEditingController countrySearchController;
  final ValueNotifier<bool> showDropdownListenable;
  final ValueChanged<String> onPhoneNumberChanged;
  final ValueChanged<CountryOption> onCountrySelected;
  final LayerLink link;
  final FocusNode focusNode;

  @override
  State<_PhoneNumberField> createState() => _PhoneNumberFieldState();
}

class _PhoneNumberFieldState extends State<_PhoneNumberField> {
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    widget.showDropdownListenable.addListener(_handleDropdownToggle);
  }

  @override
  void dispose() {
    widget.showDropdownListenable.removeListener(_handleDropdownToggle);
    _overlayEntry?.remove();
    super.dispose();
  }

  void _handleDropdownToggle() {
    if (widget.showDropdownListenable.value) {
      if (_overlayEntry == null) {
        _overlayEntry = _createOverlayEntry();
        Overlay.of(context).insert(_overlayEntry!);
      }
    } else {
      _overlayEntry?.remove();
      _overlayEntry = null;
    }
  }

  void _toggleOverlay() {
    widget.showDropdownListenable.value = !widget.showDropdownListenable.value;
  }

  OverlayEntry _createOverlayEntry() {
    const double h = 250;
    return OverlayEntry(
      builder: (context) => Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: _toggleOverlay,
              behavior: HitTestBehavior.opaque,
              child: Container(color: Colors.transparent),
            ),
          ),
          _buildSmartOverlay(
            context: this.context,
            link: widget.link,
            overlayHeight: h,
            child: Container(
              height: h,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.fieldBorder),
              ),
              child: ValueListenableBuilder<TextEditingValue>(
                valueListenable: widget.countrySearchController,
                builder: (context, searchValue, child) {
                  final List<CountryOption> filteredCountries =
                      _countrySuggestions(searchValue.text);
                  final bool showFavoritesDivider =
                      searchValue.text.trim().isEmpty;

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: TextField(
                          controller: widget.countrySearchController,
                          focusNode: widget.focusNode,
                          onChanged: (_) {},
                          style: AppFonts.regular(14, AppColors.primaryText),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: AppColors.white,
                            hintText: 'Search country',
                            hintStyle: AppFonts.regular(14, AppColors.blueGray),
                            prefixIcon: const Icon(
                              Icons.search,
                              size: 18,
                              color: AppColors.blueGray,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide: const BorderSide(
                                color: AppColors.fieldBorder,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide: const BorderSide(
                                color: AppColors.fieldBorder,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide: const BorderSide(
                                color: AppColors.scheduleVisitAccent,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxHeight: 260),
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            itemCount: filteredCountries.length,
                            itemBuilder: (BuildContext context, int index) {
                              final CountryOption country =
                                  filteredCountries[index];
                              final bool showDivider = showFavoritesDivider &&
                                  country.isoCode ==
                                      CountryOption.zimbabwe.isoCode;

                              return _CountryDropdownRow(
                                country: country,
                                isSelected: country.isoCode ==
                                    widget.selectedCountry.isoCode,
                                showDivider: showDivider,
                                onTap: () {
                                  widget.onCountrySelected(country);
                                  _toggleOverlay();
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.textFieldBorder),
      ),
      child: CompositedTransformTarget(
        link: widget.link,
        child: Row(
          children: <Widget>[
            InkWell(
              onTap: _toggleOverlay,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 14,
                ),
                decoration: const BoxDecoration(
                  border: Border(
                    right: BorderSide(color: AppColors.fieldBorder),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      widget.selectedCountry.flagEmoji,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      widget.selectedCountry.dialCode,
                      style: AppFonts.regular(14, AppColors.primaryText),
                    ),
                    const SizedBox(width: 6),
                    const Icon(
                      CupertinoIcons.chevron_down,
                      size: 14,
                      color: AppColors.blueGray,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: TextField(
                controller: widget.phoneNumberController,
                onChanged: widget.onPhoneNumberChanged,
                style: AppFonts.regular(14, AppColors.primaryText),
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Phone Number',
                  hintStyle: AppFonts.regular(14, AppColors.blueGray),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CountryDropdownRow extends StatelessWidget {
  const _CountryDropdownRow({
    required this.country,
    required this.showDivider,
    required this.isSelected,
    required this.onTap,
  });

  final CountryOption country;
  final bool showDivider;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            color: isSelected ? const Color(0xFFF4F2FF) : AppColors.white,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                Text(country.flagEmoji, style: const TextStyle(fontSize: 18)),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    country.name,
                    style: AppFonts.regular(14, AppColors.primaryText),
                  ),
                ),
                if (isSelected)
                  const Icon(
                    Icons.check,
                    size: 18,
                    color: AppColors.scheduleVisitAccent,
                  ),
              ],
            ),
          ),
          if (showDivider)
            const Divider(height: 1, thickness: 1, color: AppColors.fieldBorder),
        ],
      ),
    );
  }
}

List<CountryOption> _countrySuggestions(String pattern) {
  final String normalized = pattern.trim().toLowerCase();
  final Iterable<CountryOption> filtered = CountryOption.all.where((c) {
    if (normalized.isEmpty) return true;
    return c.name.toLowerCase().contains(normalized) ||
        c.isoCode.toLowerCase().contains(normalized) ||
        c.dialCode.toLowerCase().contains(normalized);
  });

  final List<CountryOption> favorites = [
    CountryOption.unitedStates,
    CountryOption.zimbabwe,
  ];

  final List<CountryOption> favoriteMatches = favorites
      .where((f) => filtered.any((o) => o.isoCode == f.isoCode))
      .toList();

  final List<CountryOption> others = filtered
      .where((c) => !favorites.any((f) => f.isoCode == c.isoCode))
      .toList()
    ..sort((a, b) => a.name.compareTo(b.name));

  return [...favoriteMatches, ...others];
}

class _PatientDropdownRow extends StatelessWidget {
  const _PatientDropdownRow({required this.patient, required this.showDivider});

  final PatientListRow patient;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: <Widget>[
              _PatientAvatar(patient: patient),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  patient.fullName,
                  style: AppFonts.regular(14, AppColors.primaryText),
                ),
              ),
            ],
          ),
        ),
        if (showDivider)
          const Divider(height: 1, thickness: 1, color: AppColors.fieldBorder),
      ],
    );
  }
}

class _PatientAvatar extends StatelessWidget {
  const _PatientAvatar({required this.patient});

  final PatientListRow patient;

  @override
  Widget build(BuildContext context) {
    final Color background = PatientAvatarPalette.backgroundForPatientId(
      patient.id,
    );
    return Container(
      width: 32,
      height: 32,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: background, shape: BoxShape.circle),
      child: Text(
        patient.initials,
        style: AppFonts.medium(11, AppColors.white),
      ),
    );
  }
}

class _StreetAddressDropdownRow extends StatelessWidget {
  const _StreetAddressDropdownRow({required this.suggestion});

  final ScheduleVisitAddressSuggestion suggestion;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              const Icon(
                Icons.location_on_outlined,
                size: 20,
                color: AppColors.blueGray,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  suggestion.description,
                  style: AppFonts.regular(14, AppColors.primaryText),
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1, thickness: 1, color: AppColors.fieldBorder),
      ],
    );
  }
}


