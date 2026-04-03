import 'package:flutter/material.dart';
import 'package:subqdocs_bloc/core/constants/app_strings.dart';
import 'package:subqdocs_bloc/core/models/session_user_info.dart';
import 'package:subqdocs_bloc/data/models/login_model.dart';
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

  @override
  Widget build(BuildContext context) {
    final SessionUserInfo info = SessionUserInfo.loadSync();

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SettingsScreenTitle(
            title: AppStrings.settingsPersonalSettingsTitle,
          ),
          const SizedBox(height: 18),
          SettingsProfileHeader(info: info),
          const SizedBox(height: 22),
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
                  settingsOfficeLocationIdsText(user),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const SettingsSectionTitle(title: AppStrings.settingsContactTitle),
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
                value: settingsDisplayOrDash(user?.contactNo),
              ),
            ],
          ),
          const SizedBox(height: 20),
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
                value: settingsDisplayOrDash(
                  user?.licenseExpiryDate?.toString(),
                ),
              ),
              SettingsInfoField(
                label: AppStrings.settingsNationalProviderIdentifierLabel,
                value: settingsDisplayOrDash(
                  user?.nationalProviderIdentifier?.toString(),
                ),
              ),
              SettingsInfoField(
                label: AppStrings.settingsTaxonomyCodeLabel,
                value: settingsDisplayOrDash(user?.taxonomyCode?.toString()),
              ),
              SettingsInfoField(
                label: AppStrings.settingsSpecializationLabel,
                value: settingsDisplayOrDash(user?.specialization?.toString()),
              ),
            ],
          ),
          const SizedBox(height: 26),
          SettingsActionRow(isLoggingOut: isLoggingOut),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
