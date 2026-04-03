import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subqdocs_bloc/core/constants/app_colors.dart';
import 'package:subqdocs_bloc/core/constants/app_fonts.dart';
import 'package:subqdocs_bloc/core/constants/app_strings.dart';
import 'package:subqdocs_bloc/features/patients/presentation/bloc/patients_screen_bloc.dart';

class PatientsLoadFailureBody extends StatelessWidget {
  const PatientsLoadFailureBody({required this.message, super.key});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppFonts.regular(14, AppColors.blueGray),
            ),
            const SizedBox(height: 16),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.drawerItemSelected,
                foregroundColor: AppColors.white,
                minimumSize: const Size(120, 40),
              ),
              onPressed: () => context.read<PatientsScreenBloc>().add(
                const PatientsScreenStarted(),
              ),
              child: Text(
                AppStrings.patientsRetry,
                style: AppFonts.medium(14, AppColors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
