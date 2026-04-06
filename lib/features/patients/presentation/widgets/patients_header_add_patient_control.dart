import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:subqdocs_bloc/core/constants/app_assets.dart';
import 'package:subqdocs_bloc/core/constants/app_colors.dart';
import 'package:subqdocs_bloc/core/constants/app_strings.dart';
import 'package:subqdocs_bloc/widgets/common_button.dart';

class PatientsHeaderAddPatientControl extends StatelessWidget {
  const PatientsHeaderAddPatientControl({required this.onPressed, super.key});

  final VoidCallback onPressed;

  static const double _buttonHeight = 40;

  static Widget _whitePlusIcon(double size) {
    return SvgPicture.asset(
      AppAssets.whitePlus,
      width: size,
      height: size,
      fit: BoxFit.contain,
    );
  }

  @override
  Widget build(BuildContext context) {
    return CommonButton(
      label: AppStrings.patientsAddPatient,
      icon: _whitePlusIcon(20),
      height: _buttonHeight,
      borderRadius: 8,
      backgroundColor: AppColors.primaryAction,
      textColor: AppColors.white,
      fontSize: 14,
      fontWeight: FontWeight.w500,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      elevation: 0,
      onPressed: onPressed,
    );
  }
}
