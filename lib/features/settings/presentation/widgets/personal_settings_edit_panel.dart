import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:subqdocs_bloc/core/constants/app_assets.dart';
import 'package:subqdocs_bloc/core/constants/app_colors.dart';
import 'package:subqdocs_bloc/core/constants/app_fonts.dart';
import 'package:subqdocs_bloc/core/constants/app_strings.dart';
import 'package:subqdocs_bloc/core/routing/app_router.dart';
import 'package:subqdocs_bloc/core/services/app_toast.dart';
import 'package:subqdocs_bloc/core/utils/date_formatters.dart';
import 'package:subqdocs_bloc/data/models/login_model.dart';
import 'package:subqdocs_bloc/features/login/presentation/login_screen_validation.dart';
import 'package:subqdocs_bloc/features/settings/data/models/settings_office_location_response.dart';
import 'package:subqdocs_bloc/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:subqdocs_bloc/features/settings/presentation/utils/settings_profile_merge.dart';
import 'package:subqdocs_bloc/features/settings/presentation/widgets/edit_panel/edit_panel_avatar.dart';
import 'package:subqdocs_bloc/features/settings/presentation/widgets/edit_panel/edit_panel_office_selector.dart';
import 'package:subqdocs_bloc/features/settings/presentation/widgets/settings_section_title.dart';
import 'package:subqdocs_bloc/widgets/common_button.dart';
import 'package:subqdocs_bloc/widgets/common_text_form_field.dart';

class PersonalSettingsEditPanel extends StatefulWidget {
  const PersonalSettingsEditPanel({
    super.key,
    required this.baseUser,
    required this.isDoctor,
  });

  final User baseUser;
  final bool isDoctor;

  @override
  State<PersonalSettingsEditPanel> createState() =>
      _PersonalSettingsEditPanelState();
}

class _PersonalSettingsEditPanelState extends State<PersonalSettingsEditPanel> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _titleController;
  late final TextEditingController _degreeController;
  late final TextEditingController _medicalLicenseController;
  late final TextEditingController _licenseController;
  late final TextEditingController _npiController;
  late final TextEditingController _taxonomyController;
  late final TextEditingController _specializationController;
  late final MaskTextInputFormatter _phoneMask;
  late final FocusNode _licenseFocus;
  DateTime? _licenseDate;
  bool _isSaving = false;
  String? _officeLocationValidationError;

  bool _pendingRemoveProfileImage = false;
  String? _profileImagePathForUpload;

  static const double _fieldGap = 12;
  static const double _sectionGap = 16;
  static const double _labelToFieldGap = 8;

  @override
  void initState() {
    super.initState();
    _phoneMask = MaskTextInputFormatter(mask: '+1 (###) ###-####');
    _firstNameController = TextEditingController(
      text: (widget.baseUser.firstName ?? '').trim(),
    );
    _lastNameController = TextEditingController(
      text: (widget.baseUser.lastName ?? '').trim(),
    );
    _emailController = TextEditingController(
      text: (widget.baseUser.email ?? '').trim(),
    );
    _phoneController = TextEditingController(
      text: settingsFormatPhoneMaskInitial(widget.baseUser.contactNo),
    );
    _titleController = TextEditingController(
      text: (widget.baseUser.title ?? '').trim(),
    );
    _degreeController = TextEditingController(
      text: (widget.baseUser.degree ?? '').trim(),
    );
    _medicalLicenseController = TextEditingController(
      text: (widget.baseUser.medicalLicenseNumber ?? '').trim(),
    );
    _npiController = TextEditingController(
      text: (widget.baseUser.nationalProviderIdentifier ?? '').trim(),
    );
    _taxonomyController = TextEditingController(
      text: (widget.baseUser.taxonomyCode ?? '').trim(),
    );
    _specializationController = TextEditingController(
      text: (widget.baseUser.specialization ?? '').trim(),
    );
    _licenseDate = tryParseDate(widget.baseUser.licenseExpiryDate);
    _licenseController = TextEditingController(
      text: _licenseDate == null ? '' : formatDateMmDdYyyy(_licenseDate!),
    );
    _licenseFocus = FocusNode();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _titleController.dispose();
    _degreeController.dispose();
    _medicalLicenseController.dispose();
    _licenseController.dispose();
    _npiController.dispose();
    _taxonomyController.dispose();
    _specializationController.dispose();
    _licenseFocus.dispose();
    super.dispose();
  }

  Future<void> _pickLicenseDate() async {
    final DateTime initial = _licenseDate ?? DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked == null || !mounted) {
      return;
    }
    setState(() {
      _licenseDate = picked;
      _licenseController.text = formatDateMmDdYyyy(picked);
    });
  }

  void _clearOfficeLocationError() {
    setState(() => _officeLocationValidationError = null);
  }

  void _onImageChanged(String? imagePath, bool isRemoved) {
    setState(() {
      _pendingRemoveProfileImage = isRemoved;
      if (imagePath != null) {
        _profileImagePathForUpload = imagePath;
      } else if (isRemoved) {
        _profileImagePathForUpload = null;
      }
    });
  }

  List<OfficeLocation> _selectedOfficeLocations(SettingsReady ready) {
    final Map<int, String> namesById = <int, String>{
      for (final SettingsOfficeLocation location in ready.officeLocations)
        if (location.id != null) location.id!: (location.name ?? '').trim(),
    };
    return ready.selectedOfficeLocationIds
        .map(
          (int id) => OfficeLocation(
            id: id,
            name: namesById[id]?.isEmpty ?? true ? null : namesById[id],
          ),
        )
        .toList();
  }

  Future<void> _submit(SettingsReady ready) async {
    final bool formValid = _formKey.currentState?.validate() ?? false;
    final bool hasOfficeSelection = ready.selectedOfficeLocationIds.isNotEmpty;
    setState(() {
      _officeLocationValidationError = hasOfficeSelection
          ? null
          : AppStrings.settingsOfficeLocationRequired;
    });
    if (!formValid || !hasOfficeSelection) {
      return;
    }

    setState(() => _isSaving = true);
    try {
      final User merged = mergeUserFromProfileForm(
        widget.baseUser,
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        email: _emailController.text.trim(),
        contactNormalized: settingsNormalizeContactSave(_phoneController.text),
        isDoctor: widget.isDoctor,
        title: _titleController.text,
        degree: _degreeController.text,
        medicalLicenseNumber: _medicalLicenseController.text,
        licenseExpiry: widget.isDoctor ? _licenseDate : null,
        nationalProviderIdentifier: _npiController.text,
        taxonomyCode: _taxonomyController.text,
        specialization: _specializationController.text,
        officeLocationIds: ready.selectedOfficeLocationIds,
        officeLocations: _selectedOfficeLocations(ready),
        applyProfileImageOverride: _pendingRemoveProfileImage,
        profileImage: null,
      );
      final SettingsBloc bloc = context.read<SettingsBloc>();
      bloc.add(
        SettingsProfileSaveRequested(
          user: merged,
          profileImageFilePath: _pendingRemoveProfileImage
              ? null
              : _profileImagePathForUpload,
          deleteProfileImage: _pendingRemoveProfileImage,
        ),
      );
      final SettingsState result = await bloc.stream
          .firstWhere(
            (SettingsState s) =>
                s is SettingsReady ||
                s is SettingsProfileSaveFailed ||
                s is SettingsLoggedOut,
          )
          .timeout(const Duration(seconds: 10));
      if (!mounted) {
        return;
      }
      if (result is SettingsReady || result is SettingsLoggedOut) {
        AppRouter.pop(context);
      }
    } on TimeoutException {
      if (mounted) {
        AppToast.showError(context, AppStrings.settingsLoadUserFailure);
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  Widget _fieldLabel(String text) {
    return Text(text, style: AppFonts.regular(12, AppColors.primaryText));
  }

  Widget _twoColumnRow(Widget left, Widget right) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(child: left),
        const SizedBox(width: _fieldGap),
        Expanded(child: right),
      ],
    );
  }

  Widget _fullWidthField(String label, Widget field) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _fieldLabel(label),
        const SizedBox(height: _labelToFieldGap),
        field,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final double width = math.min(MediaQuery.sizeOf(context).width * 0.88, 520);
    final Widget calendarSuffix = IconButton(
      icon: SvgPicture.asset(
        AppAssets.calendarWhite,
        width: 20,
        height: 20,
        colorFilter: const ColorFilter.mode(
          AppColors.drawerItemSelected,
          BlendMode.srcIn,
        ),
      ),
      onPressed: _pickLicenseDate,
    );

    return SizedBox(
      width: width,
      child: ColoredBox(
        color: AppColors.white,
        child: BlocBuilder<SettingsBloc, SettingsState>(
          buildWhen: (SettingsState previous, SettingsState current) {
            return current is SettingsReady || current is SettingsLoggingOut;
          },
          builder: (BuildContext context, SettingsState state) {
            final SettingsReady? ready = switch (state) {
              SettingsReady() => state,
              SettingsLoggingOut(:final user) => SettingsReady(user: user!),
              _ => null,
            };
            if (ready == null) {
              return const SizedBox.shrink();
            }
            return Column(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(
                    left: 16,
                    top: MediaQuery.paddingOf(context).top,
                  ),
                  color: AppColors.drawerItemSelected,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          AppStrings.settingsPersonalSettingDialogTitle,
                          style: AppFonts.medium(14, AppColors.white),
                        ),
                      ),
                      IconButton(
                        onPressed: () => AppRouter.pop(context),
                        padding: EdgeInsets.zero,
                        icon: const Icon(
                          Icons.close,
                          color: AppColors.white,
                          size: 22,
                        ),
                        tooltip: AppStrings.settingsCloseEditPanel,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          EditPanelAvatar(
                            initialImageUrl: widget.baseUser.profileImage,
                            onImageChanged: _onImageChanged,
                          ),
                          const SizedBox(height: _sectionGap),
                          const SettingsSectionTitle(
                            title: AppStrings.settingsPersonalInformationTitle,
                          ),
                          const SizedBox(height: _fieldGap),
                          _twoColumnRow(
                            _fullWidthField(
                              AppStrings.settingsFirstNameLabel,
                              CommonTextFormField(
                                controller: _firstNameController,
                                fillColor: AppColors.white,
                                hintText: AppStrings.settingsHintFirstName,
                                keyboardType: TextInputType.name,
                                textInputAction: TextInputAction.next,
                                style: AppFonts.regular(
                                  14,
                                  AppColors.primaryText,
                                ),
                                borderRadius: 10,
                                focusedBorderColor: AppColors.splashBackground,
                                validator: (String? v) {
                                  if ((v ?? '').trim().isEmpty) {
                                    return AppStrings.settingsFirstNameRequired;
                                  }
                                  return null;
                                },
                              ),
                            ),
                            _fullWidthField(
                              AppStrings.settingsLastNameLabel,
                              CommonTextFormField(
                                controller: _lastNameController,
                                fillColor: AppColors.white,
                                hintText: AppStrings.settingsHintLastName,
                                keyboardType: TextInputType.name,
                                textInputAction: TextInputAction.next,
                                style: AppFonts.regular(
                                  14,
                                  AppColors.primaryText,
                                ),
                                borderRadius: 10,
                                focusedBorderColor: AppColors.splashBackground,
                                validator: (String? v) {
                                  if ((v ?? '').trim().isEmpty) {
                                    return AppStrings.settingsLastNameRequired;
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: _sectionGap),
                          const SettingsSectionTitle(
                            title: AppStrings.settingsContactTitle,
                          ),
                          const SizedBox(height: _fieldGap),
                          _twoColumnRow(
                            _fullWidthField(
                              AppStrings.settingsEmailIdLabel,
                              CommonTextFormField(
                                controller: _emailController,
                                fillColor: AppColors.white,
                                hintText: AppStrings.settingsHintEmail,
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                                style: AppFonts.regular(
                                  14,
                                  AppColors.primaryText,
                                ),
                                borderRadius: 10,
                                focusedBorderColor: AppColors.splashBackground,
                                validator: validateLoginEmail,
                              ),
                            ),
                            _fullWidthField(
                              AppStrings.settingsPhoneNumberLabel,
                              CommonTextFormField(
                                controller: _phoneController,
                                fillColor: AppColors.white,
                                hintText: AppStrings.settingsHintPhone,
                                keyboardType: TextInputType.phone,
                                textInputAction: TextInputAction.next,
                                inputFormatters: <TextInputFormatter>[
                                  _phoneMask,
                                ],
                                style: AppFonts.regular(
                                  14,
                                  AppColors.primaryText,
                                ),
                                borderRadius: 10,
                                focusedBorderColor: AppColors.splashBackground,
                                validator: (String? value) {
                                  final String digits = (value ?? '')
                                      .replaceAll(RegExp(r'\D'), '');
                                  if (digits.length != 11) {
                                    return AppStrings.settingsPhoneRequired;
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: _fieldGap),
                          _fullWidthField(
                            AppStrings.settingsOfficeLocationLabel,
                            EditPanelOfficeSelector(
                              ready: ready,
                              validationError: _officeLocationValidationError,
                              onClearError: _clearOfficeLocationError,
                            ),
                          ),
                          if (widget.isDoctor) ...<Widget>[
                            const SizedBox(height: _sectionGap),
                            const SettingsSectionTitle(
                              title:
                                  AppStrings.settingsPractitionerDetailsTitle,
                            ),
                            const SizedBox(height: _fieldGap),
                            _twoColumnRow(
                              _fullWidthField(
                                AppStrings.settingsTitleLabel,
                                CommonTextFormField(
                                  controller: _titleController,
                                  fillColor: AppColors.white,
                                  hintText: AppStrings.settingsHintTitle,
                                  textInputAction: TextInputAction.next,
                                  style: AppFonts.regular(
                                    14,
                                    AppColors.primaryText,
                                  ),
                                  borderRadius: 10,
                                  focusedBorderColor:
                                      AppColors.splashBackground,
                                ),
                              ),
                              _fullWidthField(
                                AppStrings.settingsDegreeLabel,
                                CommonTextFormField(
                                  controller: _degreeController,
                                  fillColor: AppColors.white,
                                  hintText: AppStrings.settingsHintDegree,
                                  textInputAction: TextInputAction.next,
                                  style: AppFonts.regular(
                                    14,
                                    AppColors.primaryText,
                                  ),
                                  borderRadius: 10,
                                  focusedBorderColor:
                                      AppColors.splashBackground,
                                ),
                              ),
                            ),
                            const SizedBox(height: _fieldGap),
                            _twoColumnRow(
                              _fullWidthField(
                                AppStrings.settingsMedicalLicenseNumberLabel,
                                CommonTextFormField(
                                  controller: _medicalLicenseController,
                                  fillColor: AppColors.white,
                                  hintText:
                                      AppStrings.settingsHintMedicalLicense,
                                  textInputAction: TextInputAction.next,
                                  style: AppFonts.regular(
                                    14,
                                    AppColors.primaryText,
                                  ),
                                  borderRadius: 10,
                                  focusedBorderColor:
                                      AppColors.splashBackground,
                                ),
                              ),
                              _fullWidthField(
                                AppStrings.settingsLicenseExpiryDateLabel,
                                CommonTextFormField(
                                  controller: _licenseController,
                                  fillColor: AppColors.white,
                                  focusNode: _licenseFocus,
                                  readOnly: true,
                                  onTap: _pickLicenseDate,
                                  hintText:
                                      AppStrings.settingsHintLicenseExpiry,
                                  style: AppFonts.regular(
                                    14,
                                    AppColors.primaryText,
                                  ),
                                  borderRadius: 10,
                                  focusedBorderColor:
                                      AppColors.splashBackground,
                                  suffixIcon: calendarSuffix,
                                ),
                              ),
                            ),
                            const SizedBox(height: _fieldGap),
                            _twoColumnRow(
                              _fullWidthField(
                                AppStrings
                                    .settingsNationalProviderIdentifierLabel,
                                CommonTextFormField(
                                  controller: _npiController,
                                  fillColor: AppColors.white,
                                  hintText: AppStrings.settingsHintNpi,
                                  textInputAction: TextInputAction.next,
                                  style: AppFonts.regular(
                                    14,
                                    AppColors.primaryText,
                                  ),
                                  borderRadius: 10,
                                  focusedBorderColor:
                                      AppColors.splashBackground,
                                ),
                              ),
                              _fullWidthField(
                                AppStrings.settingsTaxonomyCodeLabel,
                                CommonTextFormField(
                                  controller: _taxonomyController,
                                  fillColor: AppColors.white,
                                  hintText: AppStrings.settingsHintTaxonomy,
                                  textInputAction: TextInputAction.next,
                                  style: AppFonts.regular(
                                    14,
                                    AppColors.primaryText,
                                  ),
                                  borderRadius: 10,
                                  focusedBorderColor:
                                      AppColors.splashBackground,
                                ),
                              ),
                            ),
                            const SizedBox(height: _fieldGap),
                            _twoColumnRow(
                              _fullWidthField(
                                AppStrings.settingsSpecializationLabel,
                                CommonTextFormField(
                                  controller: _specializationController,
                                  fillColor: AppColors.white,
                                  hintText:
                                      AppStrings.settingsHintSpecialization,
                                  textInputAction: TextInputAction.done,
                                  style: AppFonts.regular(
                                    14,
                                    AppColors.primaryText,
                                  ),
                                  borderRadius: 10,
                                  focusedBorderColor:
                                      AppColors.splashBackground,
                                ),
                              ),
                              const SizedBox.shrink(),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      CommonButton(
                        label: AppStrings.settingsDialogCancel,
                        height: 40,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        backgroundColor: AppColors.white,
                        textColor: AppColors.drawerItemSelected,
                        borderColor: AppColors.drawerItemSelected,
                        fontWeight: FontWeight.w500,
                        onPressed: _isSaving
                            ? null
                            : () => AppRouter.pop(context),
                      ),
                      const SizedBox(width: 12),
                      CommonButton(
                        label: AppStrings.settingsDialogSave,
                        height: 40,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        backgroundColor: AppColors.drawerItemSelected,
                        textColor: AppColors.white,
                        borderColor: AppColors.drawerItemSelected,
                        fontWeight: FontWeight.w500,
                        isLoading: _isSaving,
                        onPressed: _isSaving ? null : () => _submit(ready),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
