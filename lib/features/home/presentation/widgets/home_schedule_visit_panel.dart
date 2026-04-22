import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cupertino_calendar_picker/cupertino_calendar_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:subqdocs_bloc/core/constants/app_colors.dart';
import 'package:subqdocs_bloc/core/constants/app_fonts.dart';
import 'package:subqdocs_bloc/core/constants/app_strings.dart';
import 'package:subqdocs_bloc/core/models/country_option.dart';
import 'package:subqdocs_bloc/core/utils/date_formatters.dart';
import 'package:subqdocs_bloc/core/widgets/common_typeahead_dropdown.dart';
import 'package:subqdocs_bloc/data/models/office_location_model.dart';
import 'package:subqdocs_bloc/data/models/staff_model.dart';
import 'package:subqdocs_bloc/data/models/visit_type_model.dart';
import 'package:subqdocs_bloc/features/home/domain/models/schedule_visit_address_suggestion.dart';
import 'package:subqdocs_bloc/features/home/presentation/bloc/home_screen_bloc.dart';
import 'package:subqdocs_bloc/features/patients/data/patient_list_row.dart';
import 'package:subqdocs_bloc/features/patients/presentation/widgets/patient_avatar_palette.dart';
import 'package:subqdocs_bloc/widgets/common_button.dart';
import 'package:subqdocs_bloc/widgets/common_text_form_field.dart';
import 'package:subqdocs_bloc/core/models/organization_singleton.dart';

class HomeScheduleVisitPanel extends StatefulWidget {
  const HomeScheduleVisitPanel({super.key});

  @override
  State<HomeScheduleVisitPanel> createState() => _HomeScheduleVisitPanelState();
}

class _HomeScheduleVisitPanelState extends State<HomeScheduleVisitPanel> {
  late final TextEditingController _searchController;
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final ScrollController _patientSuggestionsScrollController;
  late final FocusNode _patientSearchFocusNode;
  late final SuggestionsController<PatientListRow>
  _patientSuggestionsController;
  late final TextEditingController _officeController;
  late final TextEditingController _providerController;
  late final TextEditingController _visitTypeController;
  late final TextEditingController _noteController;
  late final TextEditingController _emailAddressController;
  late final TextEditingController _countryController;
  late final TextEditingController _streetAddressController;
  late final TextEditingController _cityController;
  late final TextEditingController _stateProvinceController;
  late final TextEditingController _postalCodeController;
  late final TextEditingController _phoneNumberController;
  late final TextEditingController _phoneCountrySearchController;
  late final FocusNode _countryFocusNode;
  late final FocusNode _streetAddressFocusNode;
  late final ValueNotifier<bool> _showPhoneCountryDropdown;
  late final SuggestionsController<CountryOption> _countrySuggestionsController;
  late final SuggestionsController<ScheduleVisitAddressSuggestion>
  _streetAddressSuggestionsController;
  late final ScrollController _countrySuggestionsScrollController;
  late final ScrollController _streetAddressSuggestionsScrollController;

  final ScrollController _mainScrollController = ScrollController();
  final GlobalKey _patientSelectionKey = GlobalKey();
  final GlobalKey _firstNameKey = GlobalKey();
  final GlobalKey _lastNameKey = GlobalKey();
  final GlobalKey _phoneNumberKey = GlobalKey();
  final GlobalKey _officeLocationKey = GlobalKey();
  final GlobalKey _providerKey = GlobalKey();
  final GlobalKey _visitDateKey = GlobalKey();
  final GlobalKey _visitTimeKey = GlobalKey();
  final GlobalKey _visitTypeKey = GlobalKey();
  final GlobalKey _paymentMethodKey = GlobalKey();
  final GlobalKey _reasonKey = GlobalKey();
  final GlobalKey _dateOfBirthKey = GlobalKey();

  final Map<String, String> _errors = {};

  final LayerLink _timeLayerLink = LayerLink();

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _patientSuggestionsScrollController = ScrollController();
    _patientSearchFocusNode = FocusNode();
    _patientSuggestionsController = SuggestionsController<PatientListRow>();
    _officeController = TextEditingController();
    _providerController = TextEditingController();
    _visitTypeController = TextEditingController();
    _noteController = TextEditingController();
    _emailAddressController = TextEditingController();
    _countryController = TextEditingController();
    _streetAddressController = TextEditingController();
    _cityController = TextEditingController();
    _stateProvinceController = TextEditingController();
    _postalCodeController = TextEditingController();
    _phoneNumberController = TextEditingController();
    _phoneCountrySearchController = TextEditingController();
    _countryFocusNode = FocusNode();
    _streetAddressFocusNode = FocusNode();
    _showPhoneCountryDropdown = ValueNotifier<bool>(false);
    _countrySuggestionsController = SuggestionsController<CountryOption>();
    _streetAddressSuggestionsController =
        SuggestionsController<ScheduleVisitAddressSuggestion>();
    _countrySuggestionsScrollController = ScrollController();
    _streetAddressSuggestionsScrollController = ScrollController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _patientSuggestionsScrollController.dispose();
    _patientSearchFocusNode.dispose();
    _patientSuggestionsController.dispose();
    _officeController.dispose();
    _providerController.dispose();
    _visitTypeController.dispose();
    _noteController.dispose();
    _emailAddressController.dispose();
    _countryController.dispose();
    _streetAddressController.dispose();
    _cityController.dispose();
    _stateProvinceController.dispose();
    _postalCodeController.dispose();
    _phoneNumberController.dispose();
    _phoneCountrySearchController.dispose();
    _countryFocusNode.dispose();
    _streetAddressFocusNode.dispose();
    _showPhoneCountryDropdown.dispose();
    _countrySuggestionsController.dispose();
    _streetAddressSuggestionsController.dispose();
    _countrySuggestionsScrollController.dispose();
    _streetAddressSuggestionsScrollController.dispose();
    _mainScrollController.dispose();
    super.dispose();
  }

  void _closeAllSuggestions() {
    _patientSuggestionsController.close(retainFocus: false);
    _countrySuggestionsController.close(retainFocus: false);
    _streetAddressSuggestionsController.close(retainFocus: false);
    _showPhoneCountryDropdown.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeScreenBloc, HomeScreenState>(
      listenWhen: (previous, current) =>
          current is HomeScreenReady &&
          (current.scheduleVisitSuccessSignal == true),
      listener: (context, state) {
        if (state is HomeScreenReady && state.scheduleVisitSuccessSignal) {
          Scaffold.of(context).closeEndDrawer();
        }
      },
      child: BlocBuilder<HomeScreenBloc, HomeScreenState>(
      builder: (BuildContext context, HomeScreenState state) {
        if (state is! HomeScreenReady) {
          return const SizedBox.shrink();
        }
        final DateTime today = DateTime.now();
        final DateTime todayDateOnly = DateTime(
          today.year,
          today.month,
          today.day,
        );

        _syncController(
          _searchController,
          state.scheduleVisitPatientSearchQuery,
        );
        _syncController(_firstNameController, state.scheduleVisitFirstName);
        _syncController(_lastNameController, state.scheduleVisitLastName);
        _syncController(
          _officeController,
          state.scheduleVisitOfficeLocation?.name ?? '',
        );
        _syncController(
          _providerController,
          state.scheduleVisitProvider != null
              ? '${AppStrings.scheduleVisitProviderPrefix} ${state.scheduleVisitProvider!.name}'
              : '',
        );
        _syncController(
          _visitTypeController,
          state.scheduleVisitType?.name ?? '',
        );
        _syncController(_noteController, state.scheduleVisitNote);
        _syncController(
          _countryController,
          state.scheduleVisitCountry.displayLabel,
        );
        _syncController(
          _streetAddressController,
          state.scheduleVisitStreetAddress,
        );
        _syncController(_cityController, state.scheduleVisitCity);
        _syncController(
          _stateProvinceController,
          state.scheduleVisitStateProvince,
        );
        _syncController(_postalCodeController, state.scheduleVisitPostalCode);
        _syncController(_phoneNumberController, state.scheduleVisitPhoneNumber);

        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            _closeAllSuggestions();
          },
          child: Column(
            children: <Widget>[
              _ScheduleVisitHeader(
                onClose: () {
                  _closeAllSuggestions();
                  Scaffold.of(context).closeEndDrawer();
                },
              ),
              Expanded(
                child: ListView(
                  controller: _mainScrollController,
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
                  children: <Widget>[
                    _SectionHeader(
                      isAddingPatient: state.scheduleVisitIsAddingPatient,
                    ),
                    if (!state.scheduleVisitIsAddingPatient) ...<Widget>[
                      Container(
                        key: _patientSelectionKey,
                        child: _RequiredLabel(
                          text: AppStrings.scheduleVisitSelectOrCreatePatient,
                        ),
                      ),
                      const SizedBox(height: 8),
                      VisibilityDetector(
                        key: const Key('patient_search_dropdown'),
                        onVisibilityChanged: (info) {
                          if (info.visibleFraction == 0) {
                            _patientSuggestionsController.close(
                              retainFocus: false,
                            );
                          }
                        },
                        child: CommonTypeAheadDropdown<PatientListRow>(
                          controller: _searchController,
                          focusNode: _patientSearchFocusNode,
                          scrollController: _patientSuggestionsScrollController,
                          suggestionsController: _patientSuggestionsController,
                          hintText: AppStrings.scheduleVisitPatientSearchHint,
                          prefixIcon: const Icon(
                            Icons.search,
                            size: 20,
                            color: AppColors.blueGray,
                          ),
                          onChanged: (String value) {
                            context.read<HomeScreenBloc>().add(
                              HomeScreenScheduleVisitPatientSearchChanged(value),
                            );
                          },
                          onClear: () {
                            _patientSuggestionsController.close(
                              retainFocus: false,
                            );
                            _patientSearchFocusNode.unfocus();
                            context.read<HomeScreenBloc>().add(
                              const HomeScreenScheduleVisitPatientSearchChanged(
                                '',
                              ),
                            );
                          },
                          suggestionsCallback: (String pattern) async {
                            final Completer<List<PatientListRow>> completer =
                                Completer<List<PatientListRow>>();
                            context.read<HomeScreenBloc>().add(
                              HomeScreenScheduleVisitPatientSuggestionsRequested(
                                query: pattern,
                                completer: completer,
                              ),
                            );
                            return completer.future;
                          },
                          onSelected: (PatientListRow patient) {
                            _patientSuggestionsController.close(
                              retainFocus: false,
                            );
                            _patientSearchFocusNode.unfocus();
                            context.read<HomeScreenBloc>().add(
                              HomeScreenScheduleVisitPatientSelected(patient),
                            );
                          },
                          header: _AddPatientTile(
                            onTap: () {
                              _patientSuggestionsController.close(
                                retainFocus: false,
                              );
                              _patientSearchFocusNode.unfocus();
                              context.read<HomeScreenBloc>().add(
                                const HomeScreenScheduleVisitAddPatientSelected(),
                              );
                            },
                          ),
                          emptyBuilder: (BuildContext context) =>
                              const SizedBox.shrink(),
                          itemBuilder:
                              (BuildContext context, PatientListRow patient) {
                                return _PatientDropdownRow(
                                  patient: patient,
                                  showDivider: true,
                                );
                              },
                        ),
                      ),
                      _ErrorText(_errors['patient']),
                    ],
                    if (state.scheduleVisitIsAddingPatient ||
                        state.scheduleVisitSelectedPatient != null) ...<Widget>[
                      const SizedBox(height: 8),
                      _PurpleHeader(
                        text: AppStrings.scheduleVisitPatientInfoSection,
                      ),
                      const SizedBox(height: 8),
                      if (state.scheduleVisitIsAddingPatient) ...<Widget>[
                        Container(
                          key: _firstNameKey,
                          child: _RequiredLabel(
                            text: AppStrings.scheduleVisitFirstNameLabel,
                          ),
                        ),
                      const SizedBox(height: 8),
                      CommonTextFormField(
                        controller: _firstNameController,
                        hintText: AppStrings.scheduleVisitFirstNameLabel,
                        onChanged: (String value) {
                          context.read<HomeScreenBloc>().add(
                            HomeScreenScheduleVisitFirstNameChanged(value),
                          );
                        },
                      ),
                      _ErrorText(_errors['firstName']),
                      const SizedBox(height: 16),
                      Container(
                        key: _lastNameKey,
                        child: _RequiredLabel(
                          text: AppStrings.scheduleVisitLastNameLabel,
                        ),
                      ),
                      const SizedBox(height: 8),
                      CommonTextFormField(
                        controller: _lastNameController,
                        hintText: AppStrings.scheduleVisitLastNameLabel,
                        onChanged: (String value) {
                          // context.read<HomeScreenBloc>().add(HomeScreenScheduleVisitLastNameChanged(value));
                        },
                      ),
                      _ErrorText(_errors['lastName']),
                      const SizedBox(height: 16),
                      Container(
                        key: _dateOfBirthKey,
                        child: _FieldLabel(
                          text: AppStrings.scheduleVisitDateOfBirthLabel,
                          isRequired: OrganizationSingleton().organization?.hasOptumIntegration == true ||
                              OrganizationSingleton().organization?.isEmaLiteEnabled == true,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _DatePickerButton(
                        date: state.dateOfBirth,
                        onChanged: (DateTime date) {
                          context.read<HomeScreenBloc>().add(
                            HomeScreenScheduleVisitDateOfBirthChanged(date),
                          );
                        },
                        firstDate: DateTime(1970),
                        lastDate: todayDateOnly,
                        initialDate: state.dateOfBirth ?? todayDateOnly,
                        placeholder: AppStrings.scheduleVisitDateHint,
                      ),
                      _ErrorText(_errors['dateOfBirth']),
                      const SizedBox(height: 16),
                      _FieldLabel(
                        text: AppStrings.scheduleVisitGenderAtBirthLabel,
                      ),
                      const SizedBox(height: 8),
                      _SimpleDropdown(
                        value: state.scheduleVisitGender,
                        items: const <String>[
                          AppStrings.scheduleVisitGenderUndeclared,
                          AppStrings.scheduleVisitGenderMale,
                          AppStrings.scheduleVisitGenderFemale,
                        ],
                        onChanged: (value) {
                          context.read<HomeScreenBloc>().add(
                            HomeScreenScheduleVisitGender(value),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      ],
                      Container(
                        key: _phoneNumberKey,
                        child: _FieldLabel(
                          text: AppStrings.scheduleVisitPhoneNumberLabel,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _PhoneNumberField(
                        selectedCountry: state.scheduleVisitPhoneCountry,
                        phoneNumberController: _phoneNumberController,
                        countrySearchController: _phoneCountrySearchController,
                        showDropdownListenable: _showPhoneCountryDropdown,
                        onPhoneNumberChanged: (String value) {
                          context.read<HomeScreenBloc>().add(
                            HomeScreenScheduleVisitPhoneNumberChanged(value),
                          );
                        },
                        onCountrySelected: (CountryOption country) {
                          _phoneCountrySearchController.clear();
                          _showPhoneCountryDropdown.value = false;
                          context.read<HomeScreenBloc>().add(
                            HomeScreenScheduleVisitPhoneCountryChanged(country),
                          );
                        },
                      ),
                      _ErrorText(_errors['phoneNumber']),
                      const SizedBox(height: 16),
                      _FieldLabel(text: AppStrings.emailAddressLabel),
                      const SizedBox(height: 8),
                      CommonTextFormField(
                        controller: _emailAddressController,
                        hintText: AppStrings.scheduleVisitEmailHint,
                        onChanged: (String value) {},
                      ),
                      const SizedBox(height: 16),
                      _FieldLabel(text: AppStrings.scheduleVisitCountryLabel),
                      const SizedBox(height: 8),
                      VisibilityDetector(
                        key: const Key('country_dropdown'),
                        onVisibilityChanged: (info) {
                          if (info.visibleFraction == 0) {
                            _countrySuggestionsController.close(
                              retainFocus: false,
                            );
                          }
                        },
                        child: CommonTypeAheadDropdown<CountryOption>(
                          controller: _countryController,
                          focusNode: _countryFocusNode,
                          suggestionsController: _countrySuggestionsController,
                          scrollController: _countrySuggestionsScrollController,
                          hintText: AppStrings.scheduleVisitCountryHint,
                          suffixIcon: const Icon(
                            CupertinoIcons.chevron_down,
                            size: 18,
                            color: AppColors.blueGray,
                          ),
                          suggestionsCallback: (String pattern) {
                            final String normalized = pattern.trim();
                            if (normalized.isEmpty ||
                                normalized ==
                                    state.scheduleVisitCountry.displayLabel ||
                                normalized == state.scheduleVisitCountry.name ||
                                normalized.toLowerCase() ==
                                    state.scheduleVisitCountry.isoCode
                                        .toLowerCase()) {
                              return _countrySuggestions('');
                            }
                            return _countrySuggestions(pattern);
                          },
                          itemBuilder:
                              (BuildContext context, CountryOption country) {
                                return _CountryDropdownRow(
                                  country: country,
                                  isSelected:
                                      country.isoCode ==
                                      state.scheduleVisitCountry.isoCode,
                                  showDivider:
                                      _countryController.text.trim().isEmpty &&
                                      country.isoCode ==
                                          CountryOption.zimbabwe.isoCode,
                                  onTap: () {
                                    _countrySuggestionsController.close(
                                      retainFocus: false,
                                    );
                                    _countryFocusNode.unfocus();
                                    context.read<HomeScreenBloc>().add(
                                      HomeScreenScheduleVisitCountryChanged(country),
                                    );
                                  },
                                );
                              },
                          onSelected: (CountryOption country) {
                            _countrySuggestionsController.close(
                              retainFocus: false,
                            );
                            _countryFocusNode.unfocus();
                            context.read<HomeScreenBloc>().add(
                              HomeScreenScheduleVisitCountryChanged(country),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      _FieldLabel(
                        text: AppStrings.scheduleVisitStreetAddressLabel,
                      ),
                      const SizedBox(height: 8),
                      VisibilityDetector(
                        key: const Key('street_address_dropdown'),
                        onVisibilityChanged: (info) {
                          if (info.visibleFraction == 0) {
                            _streetAddressSuggestionsController.close(
                              retainFocus: false,
                            );
                          }
                        },
                        child: CommonTypeAheadDropdown<ScheduleVisitAddressSuggestion>(
                          controller: _streetAddressController,
                          focusNode: _streetAddressFocusNode,
                          suggestionsController:
                              _streetAddressSuggestionsController,
                          scrollController:
                              _streetAddressSuggestionsScrollController,
                          hintText: AppStrings.scheduleVisitStateAddressHint,
                          onChanged: (String value) {
                            context.read<HomeScreenBloc>().add(
                              HomeScreenScheduleVisitStreetAddressChanged(value),
                            );
                          },
                          onClear: () {
                            _streetAddressSuggestionsController.close(
                              retainFocus: false,
                            );
                            _streetAddressFocusNode.unfocus();
                            context.read<HomeScreenBloc>().add(
                              const HomeScreenScheduleVisitStreetAddressChanged(
                                '',
                              ),
                            );
                          },
                          suggestionsCallback: (String pattern) async {
                            final Completer<List<ScheduleVisitAddressSuggestion>>
                            completer =
                                Completer<List<ScheduleVisitAddressSuggestion>>();
                            context.read<HomeScreenBloc>().add(
                              HomeScreenScheduleVisitStreetAddressSuggestionsRequested(
                                query: pattern,
                                country: state.scheduleVisitCountry,
                                completer: completer,
                              ),
                            );
                            return completer.future;
                          },
                          emptyBuilder: (BuildContext context) =>
                              const SizedBox.shrink(),
                          itemBuilder:
                              (
                                BuildContext context,
                                ScheduleVisitAddressSuggestion suggestion,
                              ) {
                                return _StreetAddressDropdownRow(
                                  suggestion: suggestion,
                                );
                              },
                          onSelected:
                              (ScheduleVisitAddressSuggestion suggestion) {
                                _streetAddressSuggestionsController.close(
                                  retainFocus: false,
                                );
                                _streetAddressFocusNode.unfocus();
                                context.read<HomeScreenBloc>().add(
                                  HomeScreenScheduleVisitStreetAddressSelected(
                                    suggestion,
                                  ),
                                );
                              },
                        ),
                      ),
                      const SizedBox(height: 16),
                      _FieldLabel(text: AppStrings.scheduleVisitCityLabel),
                      const SizedBox(height: 8),
                      CommonTextFormField(
                        controller: _cityController,
                        readOnly: true,
                        hintText: AppStrings.scheduleVisitCityLabel,
                      ),
                      const SizedBox(height: 16),
                      _FieldLabel(text: AppStrings.scheduleVisitStateLabel),
                      const SizedBox(height: 8),
                      CommonTextFormField(
                        controller: _stateProvinceController,
                        readOnly: true,
                        hintText: AppStrings.scheduleVisitStateLabel,
                      ),
                      const SizedBox(height: 16),
                      _FieldLabel(
                        text: AppStrings.scheduleVisitPostalCodeLabel,
                      ),
                      const SizedBox(height: 8),
                      CommonTextFormField(
                        controller: _postalCodeController,
                        readOnly: true,
                        hintText: AppStrings.scheduleVisitPostalCodeLabel,
                      ),
                    ],

                    const SizedBox(height: 8),
                    const Divider(
                      height: 1,
                      thickness: 1,
                      color: AppColors.fieldBorder,
                    ),
                    const SizedBox(height: 8),

                    // Visit Info Section
                    _PurpleHeader(
                      text: AppStrings.scheduleVisitVisitInfoSection,
                    ),
                    const SizedBox(height: 8),

                    Container(
                      key: _officeLocationKey,
                      child: _RequiredLabel(text: AppStrings.officeLocationLabel),
                    ),
                    const SizedBox(height: 4),
                    CommonTypeAheadDropdown<OfficeLocationModel>(
                      controller: _officeController,
                      hintText: AppStrings.officeSelectorHint,
                      suffixIcon: const Icon(
                        CupertinoIcons.chevron_down,
                        size: 18,
                        color: AppColors.blueGray,
                      ),
                      suggestionsCallback: (pattern) {
                        final list = state.allOfficeLocations;
                        // Return full list on focus or if match
                        if (pattern.isEmpty ||
                            state.scheduleVisitOfficeLocation?.name ==
                                pattern) {
                          return list;
                        }
                        return list
                            .where(
                              (l) => l.name.toLowerCase().contains(
                                pattern.toLowerCase(),
                              ),
                            )
                            .toList();
                      },
                      itemBuilder: (context, location) => ListTile(
                        dense: true,
                        title: Text(
                          location.name,
                          style: AppFonts.regular(14, AppColors.primaryText),
                        ),
                      ),
                      onSelected: (location) {
                        context.read<HomeScreenBloc>().add(
                          HomeScreenScheduleVisitOfficeLocationChanged(
                            location,
                          ),
                        );
                      },
                    ),
                    _ErrorText(_errors['officeLocation']),
                    const SizedBox(height: 10),

                    Container(
                      key: _providerKey,
                      child: _RequiredLabel(text: AppStrings.providerLabel),
                    ),
                    const SizedBox(height: 5),
                    CommonTypeAheadDropdown<StaffModel>(
                      controller: _providerController,
                      hintText: AppStrings.providerSelectorHint,
                      suffixIcon: const Icon(
                        CupertinoIcons.chevron_down,
                        size: 18,
                        color: AppColors.blueGray,
                      ),
                      suggestionsCallback: (pattern) {
                        final list = state.allProviders;
                        final currentName = state.scheduleVisitProvider != null
                            ? '${AppStrings.scheduleVisitProviderPrefix} ${state.scheduleVisitProvider!.name}'
                            : '';
                        if (pattern.isEmpty || currentName == pattern) {
                          return list;
                        }
                        return list
                            .where(
                              (p) => p.name.toLowerCase().contains(
                                pattern.toLowerCase(),
                              ),
                            )
                            .toList();
                      },
                      itemBuilder: (context, provider) => ListTile(
                        dense: true,
                        leading: _ProviderAvatar(provider: provider),
                        title: Text(
                          provider.name,
                          style: AppFonts.regular(14, AppColors.primaryText),
                        ),
                      ),
                      onSelected: (provider) {
                        context.read<HomeScreenBloc>().add(
                          HomeScreenScheduleVisitProviderChanged(provider),
                        );
                      },
                    ),
                    _ErrorText(_errors['provider']),
                    const SizedBox(height: 10),

                    Container(
                      key: _visitDateKey,
                      child: _RequiredLabel(text: AppStrings.visitDateLabel),
                    ),
                    const SizedBox(height: 5),
                    _DatePickerButton(
                      date: state.scheduleVisitDate,
                      firstDate: todayDateOnly,
                      lastDate: DateTime.now().add(
                        const Duration(days: 365 * 15),
                      ),
                      initialDate: state.scheduleVisitDate ?? todayDateOnly,
                      onChanged: (date) {
                        context.read<HomeScreenBloc>().add(
                          HomeScreenScheduleVisitDateChanged(date),
                        );
                      },
                    ),
                    _ErrorText(_errors['visitDate']),
                    const SizedBox(height: 10),

                    Container(
                      key: _visitTimeKey,
                      child: _RequiredLabel(text: AppStrings.visitTimeLabel),
                    ),
                    const SizedBox(height: 5),
                    CompositedTransformTarget(
                      link: _timeLayerLink,
                      child: _TimePickerButton(
                        time: state.scheduleVisitTime,
                        link: _timeLayerLink,
                        onChanged: (time) {
                          context.read<HomeScreenBloc>().add(
                            HomeScreenScheduleVisitTimeChanged(time),
                          );
                        },
                      ),
                    ),
                    _ErrorText(_errors['visitTime']),
                    const SizedBox(height: 10),

                    Container(
                      key: _visitTypeKey,
                      child: _RequiredLabel(text: AppStrings.visitTypeLabel),
                    ),
                    const SizedBox(height: 5),
                    CommonTypeAheadDropdown<VisitTypeModel>(
                      controller: _visitTypeController,
                      hintText: AppStrings.visitTypeHint,
                      suffixIcon: const Icon(
                        CupertinoIcons.chevron_down,
                        size: 18,
                        color: AppColors.blueGray,
                      ),
                      suggestionsCallback: (pattern) {
                        final list = state.allVisitTypes;
                        if (pattern.isEmpty ||
                            state.scheduleVisitType?.name == pattern) {
                          return list;
                        }
                        return list
                            .where(
                              (v) => v.name.toLowerCase().contains(
                                pattern.toLowerCase(),
                              ),
                            )
                            .toList();
                      },
                      itemBuilder: (context, type) => ListTile(
                        dense: true,
                        title: Text(
                          type.name,
                          style: AppFonts.regular(14, AppColors.primaryText),
                        ),
                      ),
                      onSelected: (type) {
                        context.read<HomeScreenBloc>().add(
                          HomeScreenScheduleVisitTypeChanged(type),
                        );
                      },
                    ),
                    _ErrorText(_errors['visitType']),
                    const SizedBox(height: 10),

                    _FieldLabel(
                      text: AppStrings.scheduleVisitAppointmentNoteLabel,
                    ),
                    const SizedBox(height: 5),
                    CommonTextFormField(
                      controller: _noteController,
                      maxLines: 3,
                      hintText: AppStrings.scheduleVisitAppointmentNoteHint,
                      onChanged: (value) {
                        context.read<HomeScreenBloc>().add(
                          HomeScreenScheduleVisitNoteChanged(value),
                        );
                      },
                    ),
                    const SizedBox(height: 20),

                    // Financial Responsibility Section
                    _PurpleHeader(
                      text: AppStrings
                          .scheduleVisitFinancialResponsibilitySection,
                    ),
                    const SizedBox(height: 10),

                    Container(
                      key: _paymentMethodKey,
                      child: _RequiredLabel(
                        text: AppStrings.scheduleVisitPaymentMethodLabel,
                      ),
                    ),
                    const SizedBox(height: 5),
                    _SimpleDropdown(
                      value: state.scheduleVisitPaymentMethod,
                      items: const [
                        AppStrings.scheduleVisitPaymentMethodSelfPay,
                        AppStrings.scheduleVisitPaymentMethodMedicalInsurance,
                        AppStrings.scheduleVisitOptionOther,
                      ],
                      onChanged: (value) {
                        context.read<HomeScreenBloc>().add(
                          HomeScreenScheduleVisitPaymentMethodChanged(value),
                        );
                      },
                      hintText: AppStrings.scheduleVisitPaymentMethodHint,
                    ),
                    _ErrorText(_errors['paymentMethod']),
                    const SizedBox(height: 10),

                    Container(
                      key: _reasonKey,
                      child: _RequiredLabel(text: AppStrings.scheduleVisitReasonLabel),
                    ),
                    const SizedBox(height: 5),
                    _SimpleDropdown(
                      value: state.scheduleVisitReason,
                      items: const [
                        AppStrings.scheduleVisitReasonMedicalNonEmergency,
                        AppStrings.scheduleVisitReasonCosmetic,
                        AppStrings.scheduleVisitOptionOther,
                      ],
                      onChanged: (value) {
                        context.read<HomeScreenBloc>().add(
                          HomeScreenScheduleVisitReasonChanged(value),
                        );
                      },
                      hintText: AppStrings.scheduleVisitReasonHint,
                    ),
                    _ErrorText(_errors['reason']),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              AnimatedPadding(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOut,
                padding: EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 12,
                  bottom: MediaQuery.viewInsetsOf(context).bottom + 0,
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: CommonButton(
                        label: AppStrings.cancelButton,
                        height: 40,
                        backgroundColor: AppColors.white,
                        textColor: AppColors.scheduleVisitAccent,
                        borderColor: AppColors.scheduleVisitAccent,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        elevation: 0,
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          _closeAllSuggestions();
                          Scaffold.of(context).closeEndDrawer();
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: CommonButton(
                        label: AppStrings.homeScheduleVisit,
                        height: 40,
                        backgroundColor: AppColors.scheduleVisitAccent,
                        textColor: AppColors.white,
                        borderColor: AppColors.scheduleVisitAccent,
                        fontSize: 14,
                        onPressed: state.isSubmittingScheduleVisit
                            ? null
                            : () {
                                FocusScope.of(context).unfocus();
                                _closeAllSuggestions();
                                _validateAndSubmit(state);
                              },
                        isLoading: state.isSubmittingScheduleVisit,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
      ),
    );
  }

  void _validateAndSubmit(HomeScreenReady state) {
    setState(() {
      _errors.clear();
    });

    GlobalKey? firstErrorKey;

    if (!state.scheduleVisitIsAddingPatient && state.scheduleVisitSelectedPatient == null) {
      _errors['patient'] = 'Select patient is required';
      firstErrorKey ??= _patientSelectionKey;
    } else if (state.scheduleVisitIsAddingPatient) {
      if (state.scheduleVisitFirstName.trim().isEmpty) {
        _errors['firstName'] = 'First name is required';
        firstErrorKey ??= _firstNameKey;
      }
      if (state.scheduleVisitLastName.trim().isEmpty) {
        _errors['lastName'] = 'Last name is required';
        firstErrorKey ??= _lastNameKey;
      }
      if (state.scheduleVisitPhoneNumber.trim().isEmpty) {
        _errors['phoneNumber'] = 'Phone number is required';
        firstErrorKey ??= _phoneNumberKey;
      }
    }

    if (state.scheduleVisitOfficeLocation == null) {
      _errors['officeLocation'] = 'Office location is required';
      firstErrorKey ??= _officeLocationKey;
    }
    
    if (state.scheduleVisitProvider == null) {
      _errors['provider'] = 'Provider is required';
      firstErrorKey ??= _providerKey;
    }
    
    if (state.scheduleVisitDate == null) {
      _errors['visitDate'] = 'Visit date is required';
      firstErrorKey ??= _visitDateKey;
    }
    
    if (state.scheduleVisitTime == null) {
      _errors['visitTime'] = 'Visit time is required';
      firstErrorKey ??= _visitTimeKey;
    } else if (state.scheduleVisitDate != null && _isVisitTimeInPast(state.scheduleVisitDate!, state.scheduleVisitTime!)) {
      _errors['visitTime'] = 'Selected visit time must be in the future';
      firstErrorKey ??= _visitTimeKey;
    }
    
    if (state.scheduleVisitType == null) {
      _errors['visitType'] = 'Visit type is required';
      firstErrorKey ??= _visitTypeKey;
    }
    
    if (state.scheduleVisitPaymentMethod == null) {
      _errors['paymentMethod'] = 'Payment method is required';
      firstErrorKey ??= _paymentMethodKey;
    }
    
    if (state.scheduleVisitReason == null) {
      _errors['reason'] = 'Reason is required';
      firstErrorKey ??= _reasonKey;
    }

    if (state.scheduleVisitIsAddingPatient) {
      final org = OrganizationSingleton().organization;
      bool dobRequired = org?.hasOptumIntegration == true || org?.isEmaLiteEnabled == true;
      if (dobRequired && state.dateOfBirth == null) {
        _errors['dateOfBirth'] = 'Date of birth is required';
        firstErrorKey ??= _dateOfBirthKey;
      }
    }

    if (_errors.isNotEmpty) {
      setState(() {});
      if (firstErrorKey != null) {
        _scrollToError(firstErrorKey);
      }
    } else {
      context.read<HomeScreenBloc>().add(const HomeScreenScheduleVisitSubmitted());
    }
  }

  bool _isVisitTimeInPast(DateTime date, DateTime time) {
    final visitDateTime = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
    return visitDateTime.isBefore(DateTime.now());
  }

  void _scrollToError(GlobalKey key) {
    if (key.currentContext != null) {
      Scrollable.ensureVisible(
        key.currentContext!,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        alignmentPolicy: ScrollPositionAlignmentPolicy.keepVisibleAtStart,
      );
    }
  }
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

List<CountryOption> _countrySuggestions(String pattern) {
  final String normalized = pattern.trim().toLowerCase();
  final Iterable<CountryOption> filtered = CountryOption.all.where((
    CountryOption country,
  ) {
    if (normalized.isEmpty) {
      return true;
    }
    return country.name.toLowerCase().contains(normalized) ||
        country.isoCode.toLowerCase().contains(normalized) ||
        country.dialCode.toLowerCase().contains(normalized);
  });

  final List<CountryOption> favorites = <CountryOption>[
    CountryOption.unitedStates,
    CountryOption.zimbabwe,
  ];

  final List<CountryOption> favoriteMatches = favorites
      .where(
        (CountryOption country) => filtered.any(
          (CountryOption option) => option.isoCode == country.isoCode,
        ),
      )
      .toList();
  final List<CountryOption> others =
      filtered
          .where(
            (CountryOption country) => !favorites.any(
              (CountryOption favorite) => favorite.isoCode == country.isoCode,
            ),
          )
          .toList()
        ..sort(
          (CountryOption a, CountryOption b) => a.name.compareTo(b.name),
        );

  return <CountryOption>[...favoriteMatches, ...others];
}

class _ScheduleVisitHeader extends StatelessWidget {
  const _ScheduleVisitHeader({required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      color: AppColors.scheduleVisitAccent,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            AppStrings.homeScheduleVisit,
            style: AppFonts.medium(16, AppColors.white),
          ),
          InkWell(
            onTap: onClose,
            child: const Icon(Icons.close, color: AppColors.white, size: 20),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.isAddingPatient});

  final bool isAddingPatient;

  @override
  Widget build(BuildContext context) {
    if (!isAddingPatient) {
      return const SizedBox.shrink();
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          AppStrings.scheduleVisitNewPatientInformation,
          style: AppFonts.medium(14, AppColors.primaryText),
        ),
        InkWell(
          onTap: () {
            context.read<HomeScreenBloc>().add(
              const HomeScreenScheduleVisitSearchExistingPatientSelected(),
            );
          },
          child: Text(
            AppStrings.scheduleVisitSearchExistingPatient,
            style: AppFonts.medium(14, AppColors.scheduleVisitAccent),
          ),
        ),
      ],
    );
  }
}

class _RequiredLabel extends StatelessWidget {
  const _RequiredLabel({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: <InlineSpan>[
          TextSpan(text: text, style: AppFonts.regular(14, AppColors.black)),
          TextSpan(text: ' *', style: AppFonts.regular(14, AppColors.red)),
        ],
      ),
    );
  }
}

class _ErrorText extends StatelessWidget {
  const _ErrorText(this.error);

  final String? error;

  @override
  Widget build(BuildContext context) {
    if (error == null || error!.isEmpty) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.only(top: 4, left: 4),
      child: Text(
        error!,
        style: AppFonts.regular(12, AppColors.red),
      ),
    );
  }
}

class _AddPatientTile extends StatelessWidget {
  const _AddPatientTile({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: <Widget>[
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.chipSelectedBackground,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.person_add_alt_1,
                  color: AppColors.scheduleVisitAccent,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      AppStrings.scheduleVisitAddNewPatient,
                      style: AppFonts.medium(16, AppColors.scheduleVisitAccent),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      AppStrings.scheduleVisitAddNewPatientSubtitle,
                      style: AppFonts.regular(14, AppColors.secondaryText),
                    ),
                  ],
                ),
              ),
            ],
          ),
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
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.only(top: 2),
                child: Icon(
                  Icons.location_on_outlined,
                  size: 18,
                  color: AppColors.secondaryText,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      suggestion.primaryText?.trim().isNotEmpty == true
                          ? suggestion.primaryText!
                          : suggestion.description,
                      style: AppFonts.regular(14, AppColors.primaryText),
                    ),
                    if (suggestion.secondaryText?.trim().isNotEmpty == true)
                      Text(
                        suggestion.secondaryText!,
                        style: AppFonts.regular(14, AppColors.primaryText),
                      ),
                  ],
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

class _PhoneNumberField extends StatefulWidget {
  const _PhoneNumberField({
    super.key,
    required this.selectedCountry,
    required this.phoneNumberController,
    required this.countrySearchController,
    required this.showDropdownListenable,
    required this.onPhoneNumberChanged,
    required this.onCountrySelected,
  });

  final CountryOption selectedCountry;
  final TextEditingController phoneNumberController;
  final TextEditingController countrySearchController;
  final ValueNotifier<bool> showDropdownListenable;
  final ValueChanged<String> onPhoneNumberChanged;
  final ValueChanged<CountryOption> onCountrySelected;

  @override
  State<_PhoneNumberField> createState() => _PhoneNumberFieldState();
}

class _PhoneNumberFieldState extends State<_PhoneNumberField> {
  final LayerLink _link = LayerLink();
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    widget.showDropdownListenable.addListener(_handleExternalToggle);
  }

  @override
  void dispose() {
    widget.showDropdownListenable.removeListener(_handleExternalToggle);
    _overlayEntry?.remove();
    super.dispose();
  }

  void _handleExternalToggle() {
    if (widget.showDropdownListenable.value) {
      if (_overlayEntry == null) {
        _showOverlay();
      }
    } else {
      if (_overlayEntry != null) {
        _hideOverlay();
      }
    }
  }

  void _toggleOverlay() {
    widget.showDropdownListenable.value = !widget.showDropdownListenable.value;
  }

  void _showOverlay() {
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  OverlayEntry _createOverlayEntry() {
    const double h = 320;
    return OverlayEntry(
      builder: (BuildContext context) => Stack(
        children: <Widget>[
          Positioned.fill(
            child: GestureDetector(
              onTap: _toggleOverlay,
              behavior: HitTestBehavior.opaque,
              child: Container(color: Colors.transparent),
            ),
          ),
          _buildSmartOverlay(
            context: this.context,
            link: _link,
            overlayHeight: h,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.fieldBorder),
              ),
              child: ValueListenableBuilder<TextEditingValue>(
                valueListenable: widget.countrySearchController,
                builder: (
                  BuildContext context,
                  TextEditingValue searchValue,
                  Widget? child,
                ) {
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
                          onChanged: (_) {},
                          style: AppFonts.regular(
                            14,
                            AppColors.primaryText,
                          ),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: AppColors.white,
                            hintText: AppStrings.scheduleVisitCountrySearchHint,
                            hintStyle: AppFonts.regular(
                              14,
                              AppColors.blueGray,
                            ),
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
        border: Border.all(color: AppColors.scheduleVisitAccent),
      ),
      child: CompositedTransformTarget(
        link: _link,
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
                  hintText: AppStrings.scheduleVisitPhoneNumberHint,
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
    return Column(
      children: <Widget>[
        InkWell(
          onTap: onTap,
          child: Container(
            color: isSelected ? const Color(0xFFF4F2FF) : AppColors.white,
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
            child: Row(
              children: <Widget>[
                Text(
                  country.flagEmoji,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: 44,
                  child: Text(
                    country.dialCode,
                    style: AppFonts.regular(
                      14,
                      AppColors.primaryText,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    country.name,
                    style: AppFonts.regular(
                      14,
                      AppColors.primaryText,
                    ),
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
        ),
        const Divider(
          height: 1,
          thickness: 1,
          color: AppColors.fieldBorder,
        ),
        if (showDivider)
          const Divider(
            height: 1,
            thickness: 1,
            color: AppColors.fieldBorder,
          ),
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

class _PurpleHeader extends StatelessWidget {
  const _PurpleHeader({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text, style: AppFonts.medium(16, const Color(0xFF5B5BE1)));
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel({required this.text, this.isRequired = false});

  final String text;
  final bool isRequired;

  @override
  Widget build(BuildContext context) {
    if (isRequired) {
      return RichText(
        text: TextSpan(
          children: <InlineSpan>[
            TextSpan(text: text, style: AppFonts.regular(14, AppColors.black)),
            TextSpan(text: ' *', style: AppFonts.regular(14, AppColors.red)),
          ],
        ),
      );
    }
    return Text(text, style: AppFonts.regular(14, AppColors.black));
  }
}

/// Helper to determine if an overlay should open above or below the target.
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

  // Check if there is enough space below (current height + 5px gap + overlay height)
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

class _DatePickerButton extends StatefulWidget {
  const _DatePickerButton({
    required this.date,
    required this.onChanged,
    required this.firstDate,
    required this.lastDate,
    this.initialDate,
    this.placeholder = AppStrings.scheduleVisitDateHint,
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

    if (normalizedValue.isBefore(min)) {
      return min;
    }
    if (normalizedValue.isAfter(max)) {
      return max;
    }
    return normalizedValue;
  }

  DateTime _dateOnly(DateTime value) {
    return DateTime(value.year, value.month, value.day);
  }

  Future<void> _showPicker() async {
    final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    final DateTime initialDate = _clampDate(
      widget.date ?? widget.initialDate ?? widget.lastDate,
    );

    final DateTime? pickedDate = await showCupertinoCalendarPicker(
      context,
      widgetRenderBox: renderBox,
      minimumDateTime: _dateOnly(widget.firstDate),
      maximumDateTime: _dateOnly(widget.lastDate),
      initialDateTime: initialDate,
      currentDateTime: _dateOnly(DateTime.now()),
      mainColor: AppColors.scheduleVisitAccent,
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
            const Icon(
              Icons.calendar_today,
              size: 18,
              color: AppColors.blueGray,
            ),
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
    String formatted = AppStrings.scheduleVisitTimeHint;
    if (widget.time != null) {
      final hour = widget.time!.hour > 12
          ? widget.time!.hour - 12
          : (widget.time!.hour == 0 ? 12 : widget.time!.hour);
      final String amPm = widget.time!.hour >= 12
          ? AppStrings.meridiemPm
          : AppStrings.meridiemAm;
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

class _ProviderAvatar extends StatelessWidget {
  const _ProviderAvatar({required this.provider});

  final StaffModel provider;

  String _getInitials(String name) {
    if (name.isEmpty) return '';
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length > 1) {
      if (parts[1].isEmpty) return parts[0][0].toUpperCase();
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.substring(0, 1).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final Widget fallback = CircleAvatar(
      radius: 16,
      backgroundColor: AppColors.chipSelectedBackground,
      child: Text(
        _getInitials(provider.name),
        style: AppFonts.medium(12, AppColors.scheduleVisitAccent),
      ),
    );

    if (provider.profileImage != null && provider.profileImage!.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: provider.profileImage!,
        imageBuilder: (context, imageProvider) => CircleAvatar(
          radius: 16,
          backgroundImage: imageProvider,
        ),
        errorWidget: (context, url, error) => fallback,
      );
    }
    return fallback;
  }
}

class _SimpleDropdown extends StatefulWidget {
  const _SimpleDropdown({
    required this.value,
    required this.items,
    required this.onChanged,
    this.hintText,
  });

  final String? value;
  final List<String> items;
  final ValueChanged<String> onChanged;
  final String? hintText;

  @override
  State<_SimpleDropdown> createState() => _SimpleDropdownState();
}

class _SimpleDropdownState extends State<_SimpleDropdown> {
  final LayerLink _link = LayerLink();
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
    final double h = widget.items.length * 48.0 + 10;
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
            link: _link,
            overlayHeight: h,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.fieldBorder),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: widget.items.map((item) {
                  final bool isSelected = item == widget.value;
                  return InkWell(
                    onTap: () {
                      widget.onChanged(item);
                      _toggleOverlay();
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      color: isSelected
                          ? const Color(0xFFF3F4F6)
                          : Colors.transparent,
                      child: Text(
                        item,
                        style: AppFonts.regular(14, AppColors.primaryText),
                      ),
                    ),
                  );
                }).toList(),
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
    return CompositedTransformTarget(
      link: _link,
      child: InkWell(
        onTap: _toggleOverlay,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.textFieldBorder),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.value ?? widget.hintText ?? AppStrings.selectLabel,
                style: AppFonts.regular(
                  14,
                  widget.value == null
                      ? AppColors.blueGray
                      : AppColors.primaryText,
                ),
              ),
              const Icon(
                CupertinoIcons.chevron_down,
                size: 18,
                color: AppColors.blueGray,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

