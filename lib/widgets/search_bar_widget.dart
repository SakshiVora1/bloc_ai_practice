import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/constants/app_fonts.dart';

/// Compact search field for scheduling toolbars. Presentation only.
class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({
    super.key,
    this.controller,
    this.onChanged,
    this.hintText,
    this.width = 170,
    this.height = 40,
  });

  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final String? hintText;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: AppFonts.regular(14, AppColors.primaryText),
        cursorColor: AppColors.scheduleVisitAccent,
        decoration: InputDecoration(
          isDense: true,
          filled: true,
          fillColor: AppColors.white,
          hintText: hintText,
          hintStyle: AppFonts.regular(14, AppColors.secondaryText),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(color: AppColors.fieldBorder),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(color: AppColors.fieldBorder),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(color: AppColors.scheduleVisitAccent),
          ),
        ),
      ),
    );
  }
}
