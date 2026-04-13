import 'package:flutter/material.dart';

abstract final class AppColors {
  AppColors._();

  static const Color splashBackground = Color(0xFF5B5BE1);

  static const Color loginBackground = Color(0xFFF7F8FF);
  static const Color primaryText = Color(0xFF111827);
  static const Color secondaryText = Color(0xFF6B7280);
  static const Color fieldBorder = Color(0xFFE5E7EB);
  static const Color textFieldBorder = Color(0xFFD8DCE4);
  static const Color blueGray = Color(0xFF6C778B);
  static const Color red = Color(0xFFEB4335);
  static const Color error = Color(0xFFEB4335);
  static const Color white = Color(0xFFFFFFFF);
  static const Color scaffoldWhite = Color(0xFFFFFFFF);
  static const Color drawerItemSelected = Color(0xFF5B5BE1);
  static const Color drawerItemUnselected = Color(0xFF555A63);
  static const Color drawerCloseIcon = Color(0xFFB5BCC8);
  static const Color recordNow = Color(0xFFFFDC15);
  static const Color black = Color(0xFF000000);

  static const Color scheduleVisitAccent = Color(0xFF5B5BE1);
  static const Color primaryAction = Color(0xFF5B5BE1);

  static const Color drawerBackground = Color(0xFFFFFFFF);
  static const Color drawerDivider = Color(0xFFE5E7EB);

  static const Color chipSelectedBackground = Color(0xFFE8EAFF);

  static const Color homeSectionBackground = Color(0xFFF9FAFB);
  static const Color homeSectionDivider = Color(0xFFE5E7EB);
  static const Color homeSectionHeaderBackground = Color(0xFFEFF6FF);
  static const Color homeTimeColumnBackground = Color(0xFFF3F4F6);

  static const Color homeStatusScheduledBackground = Color(0xFFE0E7FF);
  static const Color homeStatusScheduledText = Color(0xFF3730A3);
  static const Color homeStatusRecordingBackground = Color(0xFFFEE2E2);
  static const Color homeStatusRecordingText = Color(0xFF991B1B);
  static const Color homeStatusPausedBackground = Color(0xFFFEF3C7);
  static const Color homeStatusPausedText = Color(0xFF92400E);
  static const Color homeStatusGeneratingBackground = Color(0xFFD1FAE5);
  static const Color homeStatusGeneratingText = Color(0xFF065F46);

  static const Color homeVisitMarkerActive = Color(0xFF5B5BE1);
  static const Color homeVisitMarkerUpcoming = Color(0xFF9CA3AF);
  static const Color homeVisitMarkerCompleted = Color(0xFF10B981);

  static const Color panelBackground = Color(0xFFFFFFFF);
  static const Color panelScrim = Color(0x66000000);
  static const Color shellAppBarBackground = Color(0xFFFFFFFF);
  static const Color patientsTableHeaderBackground = Color(0xFFF3F4F6);

  /// Patients list table header (spec #F9F9F9).
  static const Color patientsTableHeaderBar = Color(0xFFF9F9F9);
  static const Color visitRowDivider = Color(0xFFE5E7EB);
  static const Color visitStatusChipText = Color(0xFF111827);
  static const Color visitStatusScheduled = Color(0xFF6366F1);
  static const Color visitStatusPaused = Color(0xFFF59E0B);
  static const Color visitStatusCompleted = Color(0xFF10B981);
}
