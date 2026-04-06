import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:subqdocs_bloc/core/constants/app_assets.dart';
import 'package:subqdocs_bloc/core/constants/app_colors.dart';
import 'package:subqdocs_bloc/core/constants/app_fonts.dart';
import 'package:subqdocs_bloc/core/constants/app_strings.dart';

class PatientsRecordNowFab extends StatelessWidget {
  const PatientsRecordNowFab({required this.onPressed, super.key});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      backgroundColor: AppColors.recordNow,
      foregroundColor: AppColors.black,
      elevation: 6,
      onPressed: onPressed,
      icon: SvgPicture.asset(
        AppAssets.quickStart,
        width: 30,
        height: 30,
        theme: const SvgTheme(currentColor: AppColors.black),
        colorFilter: const ColorFilter.mode(AppColors.black, BlendMode.srcIn),
      ),
      label: Text(
        AppStrings.patientsRecordNow,
        style: AppFonts.medium(20, AppColors.black),
      ),
    );
  }
}
