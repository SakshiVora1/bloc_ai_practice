import 'package:flutter/material.dart';
import 'package:subqdocs_bloc/core/constants/app_colors.dart';
import 'package:subqdocs_bloc/core/constants/app_fonts.dart';
import 'package:subqdocs_bloc/core/constants/app_strings.dart';
import 'package:subqdocs_bloc/features/patients/presentation/widgets/patients_primary_common_button.dart';

class PatientsLoadFailureBody extends StatelessWidget {
  const PatientsLoadFailureBody({
    required this.message,
    required this.onRetry,
    super.key,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppFonts.regular(14, AppColors.blueGray),
            ),
            const SizedBox(height: 16),
            PatientsPrimaryCommonButton(
              label: AppStrings.patientsRetry,
              onPressed: onRetry,
            ),
          ],
        ),
      ),
    );
  }
}
