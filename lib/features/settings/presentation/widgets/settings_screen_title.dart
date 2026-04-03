import 'package:flutter/material.dart';
import 'package:subqdocs_bloc/core/constants/app_colors.dart';
import 'package:subqdocs_bloc/core/constants/app_fonts.dart';

class SettingsScreenTitle extends StatelessWidget {
  const SettingsScreenTitle({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(title, style: AppFonts.medium(16, AppColors.scheduleVisitAccent)),
        const SizedBox(height: 8),
        Container(width: 120, height: 2, color: AppColors.scheduleVisitAccent),
      ],
    );
  }
}
