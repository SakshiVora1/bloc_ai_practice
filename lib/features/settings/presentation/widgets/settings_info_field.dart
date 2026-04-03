import 'package:flutter/material.dart';
import 'package:subqdocs_bloc/core/constants/app_colors.dart';
import 'package:subqdocs_bloc/core/constants/app_fonts.dart';

class SettingsInfoField extends StatelessWidget {
  const SettingsInfoField({
    super.key,
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(label, style: AppFonts.regular(12, AppColors.primaryText)),
        const SizedBox(height: 8),
        Text(value, style: AppFonts.regular(14, AppColors.blueGray)),
      ],
    );
  }
}
