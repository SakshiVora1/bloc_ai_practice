import 'package:flutter/material.dart';
import 'package:subqdocs_bloc/core/constants/app_colors.dart';
import 'package:subqdocs_bloc/core/constants/app_fonts.dart';
import 'package:subqdocs_bloc/features/home/domain/home_visit_display.dart';

class HomeVisitAvatar extends StatelessWidget {
  const HomeVisitAvatar({super.key, required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    final String initials = initialsFromFullName(name);
    return Container(
      width: 34,
      height: 34,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: AppColors.scheduleVisitAccent,
        shape: BoxShape.circle,
      ),
      child: Text(initials, style: AppFonts.semiBold(12, AppColors.white)),
    );
  }
}
