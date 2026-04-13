import 'package:flutter/material.dart';
import 'package:subqdocs_bloc/core/constants/app_fonts.dart';
import 'package:subqdocs_bloc/core/constants/app_colors.dart';

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
      color: const Color(0xFF4A4ADE),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Filter',
            style: AppFonts.medium(16, AppColors.white),
          ),
          InkWell(
            onTap: onClearTap,
            child: Text(
              'clear',
              style: AppFonts.medium(14, AppColors.white),
            ),
          ),
        ],
      ),
    );
  }
}
