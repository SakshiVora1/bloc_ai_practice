import 'package:flutter/material.dart';
import 'package:subqdocs_bloc/core/constants/app_colors.dart';
import 'package:subqdocs_bloc/widgets/common_button.dart';

/// Purple primary [CommonButton] shared by empty / error surfaces in this feature.
class PatientsPrimaryCommonButton extends StatelessWidget {
  const PatientsPrimaryCommonButton({
    required this.label,
    required this.onPressed,
    this.padding,
    super.key,
  });

  final String label;
  final VoidCallback onPressed;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return CommonButton(
      label: label,
      onPressed: onPressed,
      backgroundColor: AppColors.primaryAction,
      textColor: AppColors.white,
      fontSize: 14,
      fontWeight: FontWeight.w500,
      padding: padding,
      elevation: 0,
    );
  }
}
