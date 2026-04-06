import 'package:flutter/material.dart';
import 'package:subqdocs_bloc/core/constants/app_colors.dart';
import 'package:subqdocs_bloc/core/constants/app_fonts.dart';

class SettingsScreenTitle extends StatelessWidget {
  const SettingsScreenTitle({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: AppColors.scheduleVisitAccent),
            ),
          ),
          child: Text(
            title,
            style: AppFonts.medium(16, AppColors.scheduleVisitAccent),
          ),
        ),
      ],
    );
  }
}
