import 'package:flutter/material.dart';
import 'package:subqdocs_bloc/core/constants/app_colors.dart';
import 'package:subqdocs_bloc/core/constants/app_fonts.dart';

/// Shared typography for patient table body cells.
abstract final class PatientsTableCellStyle {
  PatientsTableCellStyle._();

  static TextStyle get body => AppFonts.regular(14, AppColors.blueGray);
}
