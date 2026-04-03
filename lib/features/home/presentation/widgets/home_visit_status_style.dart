import 'package:flutter/material.dart';
import 'package:subqdocs_bloc/core/constants/app_colors.dart';

class HomeVisitStatusStyle {
  const HomeVisitStatusStyle({
    required this.backgroundColor,
    required this.textColor,
  });

  final Color backgroundColor;
  final Color textColor;
}

HomeVisitStatusStyle homeVisitStatusStyleFor(String status) {
  final String lower = status.toLowerCase();
  if (lower == 'paused') {
    return const HomeVisitStatusStyle(
      backgroundColor: AppColors.homeStatusPausedBackground,
      textColor: AppColors.homeStatusPausedText,
    );
  }
  if (lower == 'generating notes') {
    return const HomeVisitStatusStyle(
      backgroundColor: AppColors.homeStatusGeneratingBackground,
      textColor: AppColors.homeStatusGeneratingText,
    );
  }
  if (lower == 'scheduled') {
    return const HomeVisitStatusStyle(
      backgroundColor: AppColors.homeStatusScheduledBackground,
      textColor: AppColors.homeStatusScheduledText,
    );
  }
  return const HomeVisitStatusStyle(
    backgroundColor: AppColors.homeStatusRecordingBackground,
    textColor: AppColors.homeStatusRecordingText,
  );
}
