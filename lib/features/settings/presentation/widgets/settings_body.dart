import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subqdocs_bloc/core/constants/app_colors.dart';
import 'package:subqdocs_bloc/core/constants/app_strings.dart';
import 'package:subqdocs_bloc/core/models/session_user_info.dart';
import 'package:subqdocs_bloc/core/services/app_toast.dart';
import 'package:subqdocs_bloc/data/models/login_model.dart';
import 'package:subqdocs_bloc/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:subqdocs_bloc/features/settings/presentation/widgets/settings_action_row.dart';
import 'package:subqdocs_bloc/features/settings/presentation/widgets/settings_display_format.dart';
import 'package:subqdocs_bloc/features/settings/presentation/widgets/settings_info_field.dart';
import 'package:subqdocs_bloc/features/settings/presentation/widgets/settings_info_grid.dart';
import 'package:subqdocs_bloc/features/settings/presentation/widgets/settings_profile_header.dart';
import 'package:subqdocs_bloc/features/settings/presentation/widgets/settings_screen_title.dart';
import 'package:subqdocs_bloc/features/settings/presentation/widgets/settings_section_title.dart';

class SettingsBody extends StatelessWidget {
  const SettingsBody({
    super.key,
    required this.user,
    required this.isLoggingOut,
  });

  final User? user;
  final bool isLoggingOut;

  static Widget _sectionHorizontalPadding(Widget child) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: child,
    );
  }

  bool _isDoctorRole(User? currentUser) {
    final String role = (currentUser?.role ?? '').trim().toLowerCase();
    return role == 'doctor';
  }

  void _openEditPanel(BuildContext context) {
    final User? currentUser = user;
    if (currentUser == null) {
      AppToast.showError(context, AppStrings.settingsLoadUserFailure);
      return;
    }
    context.read<SettingsBloc>().add(const SettingsEditPanelOpened());
  }

  @override
  Widget build(BuildContext context) {
    final SessionUserInfo info = SessionUserInfo.loadSync();

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _sectionHorizontalPadding(
            const SettingsScreenTitle(
              title: AppStrings.settingsPersonalSettingsTitle,
            ),
          ),
          const Divider(
            height: 1,
            thickness: 1,
            color: AppColors.homeSectionDivider,
          ),
          const SizedBox(height: 18),
          _sectionHorizontalPadding(
            SettingsProfileHeader(
              info: info,
              onEditTap: () => _openEditPanel(context),
            ),
          ),
          const SizedBox(height: 22),
          _sectionHorizontalPadding(
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SettingsSectionTitle(
                  title: AppStrings.settingsPersonalInformationTitle,
                ),
                const SizedBox(height: 12),
                SettingsInfoGrid(
                  maxColumns: 3,
                  children: <Widget>[
                    SettingsInfoField(
                      label: AppStrings.settingsFirstNameLabel,
                      value: settingsDisplayOrDash(user?.firstName),
                    ),
                    SettingsInfoField(
                      label: AppStrings.settingsLastNameLabel,
                      value: settingsDisplayOrDash(user?.lastName),
                    ),
                    SettingsInfoField(
                      label: AppStrings.settingsOfficeLocationLabel,
                      value: settingsDisplayOrDash(
                        settingsOfficeLocationNamesText(user),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _sectionHorizontalPadding(
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SettingsSectionTitle(
                  title: AppStrings.settingsContactTitle,
                ),
                const SizedBox(height: 12),
                SettingsInfoGrid(
                  maxColumns: 3,
                  children: <Widget>[
                    SettingsInfoField(
                      label: AppStrings.settingsEmailIdLabel,
                      value: settingsDisplayOrDash(user?.email),
                    ),
                    SettingsInfoField(
                      label: AppStrings.settingsPhoneNumberLabel,
                      value: settingsDisplayPhone(user?.contactNo),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (_isDoctorRole(user)) ...<Widget>[
            const SizedBox(height: 20),
            _sectionHorizontalPadding(
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SettingsSectionTitle(
                    title: AppStrings.settingsPractitionerDetailsTitle,
                  ),
                  const SizedBox(height: 12),
                  SettingsInfoGrid(
                    maxColumns: 3,
                    children: <Widget>[
                      SettingsInfoField(
                        label: AppStrings.settingsTitleLabel,
                        value: settingsDisplayOrDash(user?.title?.toString()),
                      ),
                      SettingsInfoField(
                        label: AppStrings.settingsDegreeLabel,
                        value: settingsDisplayOrDash(user?.degree?.toString()),
                      ),
                      SettingsInfoField(
                        label: AppStrings.settingsMedicalLicenseNumberLabel,
                        value: settingsDisplayOrDash(
                          user?.medicalLicenseNumber?.toString(),
                        ),
                      ),
                      SettingsInfoField(
                        label: AppStrings.settingsLicenseExpiryDateLabel,
                        value: settingsDisplayCalendarDate(
                          user?.licenseExpiryDate,
                        ),
                      ),
                      SettingsInfoField(
                        label:
                            AppStrings.settingsNationalProviderIdentifierLabel,
                        value: settingsDisplayOrDash(
                          user?.nationalProviderIdentifier?.toString(),
                        ),
                      ),
                      SettingsInfoField(
                        label: AppStrings.settingsTaxonomyCodeLabel,
                        value: settingsDisplayOrDash(
                          user?.taxonomyCode?.toString(),
                        ),
                      ),
                      SettingsInfoField(
                        label: AppStrings.settingsSpecializationLabel,
                        value: settingsDisplayOrDash(
                          user?.specialization?.toString(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 26),
          _sectionHorizontalPadding(
            SettingsActionRow(isLoggingOut: isLoggingOut),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
