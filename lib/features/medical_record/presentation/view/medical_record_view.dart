import 'package:flutter/material.dart';
import 'package:subqdocs_bloc/core/constants/app_colors.dart';
import 'package:subqdocs_bloc/core/constants/app_fonts.dart';
import 'package:subqdocs_bloc/core/constants/app_strings.dart';

class MedicalRecordView extends StatelessWidget {
  const MedicalRecordView({required this.patientId, super.key});

  final int patientId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldWhite,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: AppColors.white,
        title: Text(
          AppStrings.medicalRecordTitle,
          style: AppFonts.medium(16, AppColors.primaryText),
        ),
      ),
      body: Center(
        child: Text(
          AppStrings.medicalRecordBody(patientId),
          textAlign: TextAlign.center,
          style: AppFonts.regular(14, AppColors.blueGray),
        ),
      ),
    );
  }
}
