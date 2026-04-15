import 'package:flutter/material.dart';
import 'package:subqdocs_bloc/core/constants/app_colors.dart';
import 'package:subqdocs_bloc/core/constants/app_fonts.dart';
import 'package:subqdocs_bloc/core/constants/app_strings.dart';

class FilterHeader extends StatelessWidget {
  const FilterHeader({
    super.key,
    required this.onClearTap,
  });

  final VoidCallback onClearTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      color: AppColors.scheduleVisitAccent,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            AppStrings.homeEndDrawerFilterTitle,
            style: AppFonts.medium(16, AppColors.white),
          ),
          InkWell(
            onTap: onClearTap,
            child: Text(
              AppStrings.homeFilterClearAll,
              style: AppFonts.medium(14, AppColors.white),
            ),
          ),
        ],
      ),
    );
  }
}
