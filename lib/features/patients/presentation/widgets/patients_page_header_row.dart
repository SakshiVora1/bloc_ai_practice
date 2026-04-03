import 'package:flutter/material.dart';
import 'package:subqdocs_bloc/core/constants/app_colors.dart';
import 'package:subqdocs_bloc/core/constants/app_fonts.dart';
import 'package:subqdocs_bloc/core/constants/app_strings.dart';
import 'package:subqdocs_bloc/core/services/app_toast.dart';
import 'package:subqdocs_bloc/features/patients/presentation/widgets/patients_search_bar.dart';

class PatientsPageHeaderRow extends StatelessWidget {
  const PatientsPageHeaderRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            AppStrings.patientsScreenTitle,
            style: AppFonts.medium(18, AppColors.primaryText),
          ),
          const Spacer(),
          const PatientsSearchBar(),
          const SizedBox(width: 12),
          SizedBox(
            height: 40,
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.drawerItemSelected,
                foregroundColor: AppColors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              onPressed: () => AppToast.showInfo(
                context,
                AppStrings.patientsAddPatientComingSoon,
              ),
              child: Text(
                AppStrings.patientsAddPatient,
                style: AppFonts.medium(14, AppColors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
