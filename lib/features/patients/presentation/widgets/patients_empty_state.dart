import 'package:flutter/material.dart';
import 'package:subqdocs_bloc/core/constants/app_colors.dart';
import 'package:subqdocs_bloc/core/constants/app_fonts.dart';
import 'package:subqdocs_bloc/core/constants/app_strings.dart';
import 'package:subqdocs_bloc/features/patients/presentation/widgets/patients_primary_common_button.dart';

class PatientsEmptyState extends StatelessWidget {
  const PatientsEmptyState({required this.onAddPatient, super.key});

  final VoidCallback onAddPatient;

  @override
  Widget build(BuildContext context) {
    final Color descColor = AppColors.blueGray.withValues(alpha: 0.6);
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              AppStrings.patientsEmptyTitle,
              textAlign: TextAlign.center,
              style: AppFonts.medium(20, AppColors.blueGray),
            ),
            const SizedBox(height: 12),
            Text(
              AppStrings.patientsEmptyDescription,
              textAlign: TextAlign.center,
              style: AppFonts.regular(14, descColor),
            ),
            const SizedBox(height: 24),
            PatientsPrimaryCommonButton(
              label: AppStrings.patientsAddPatient,
              onPressed: onAddPatient,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ],
        ),
      ),
    );
  }
}
