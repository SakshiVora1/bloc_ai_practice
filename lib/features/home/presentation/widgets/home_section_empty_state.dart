import 'package:flutter/material.dart';
import 'package:subqdocs_bloc/core/constants/app_colors.dart';
import 'package:subqdocs_bloc/core/constants/app_fonts.dart';
import 'package:subqdocs_bloc/core/constants/app_strings.dart';

class HomeSectionEmptyState extends StatelessWidget {
  const HomeSectionEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: Text(
          AppStrings.homeNoVisitsFound,
          style: AppFonts.regular(13, AppColors.secondaryText),
        ),
      ),
    );
  }
}
