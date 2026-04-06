import 'package:flutter/material.dart';
import 'package:subqdocs_bloc/core/constants/app_colors.dart';
import 'package:subqdocs_bloc/core/constants/app_fonts.dart';
import 'package:subqdocs_bloc/core/constants/app_strings.dart';
import 'package:subqdocs_bloc/features/patients/domain/patients_row_menu_action.dart';

class PatientsActionMenuButton extends StatelessWidget {
  const PatientsActionMenuButton({required this.onSelected, super.key});

  final ValueChanged<PatientsRowMenuAction> onSelected;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        splashColor: AppColors.black.withValues(alpha: 0.06),
        highlightColor: AppColors.black.withValues(alpha: 0.04),
      ),
      child: PopupMenuButton<PatientsRowMenuAction>(
        color: AppColors.white,
        surfaceTintColor: Colors.transparent,
        shadowColor: AppColors.black.withValues(alpha: 0.28),
        elevation: 14,
        position: PopupMenuPosition.under,
        offset: const Offset(0, 4),
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(minWidth: 36, minHeight: 40),
        menuPadding: const EdgeInsets.symmetric(vertical: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        icon: const Icon(Icons.more_vert, color: AppColors.blueGray, size: 22),
        onSelected: onSelected,
        itemBuilder: (BuildContext context) {
          final TextStyle itemStyle = AppFonts.getTextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.primaryText,
          );

          return <PopupMenuEntry<PatientsRowMenuAction>>[
            PopupMenuItem<PatientsRowMenuAction>(
              height: 34,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              value: PatientsRowMenuAction.startVisit,
              child: Text(
                AppStrings.patientsActionStartVisit,
                style: itemStyle,
              ),
            ),
            const PopupMenuDivider(height: 1),
            PopupMenuItem<PatientsRowMenuAction>(
              height: 34,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              value: PatientsRowMenuAction.medicalRecord,
              child: Text(
                AppStrings.patientsActionMedicalRecord,
                style: itemStyle,
              ),
            ),
            const PopupMenuDivider(height: 1),
            PopupMenuItem<PatientsRowMenuAction>(
              height: 34,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              value: PatientsRowMenuAction.schedule,
              child: Text(AppStrings.patientsActionSchedule, style: itemStyle),
            ),
            const PopupMenuDivider(height: 1),
            PopupMenuItem<PatientsRowMenuAction>(
              height: 34,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              value: PatientsRowMenuAction.editPatient,
              child: Text(
                AppStrings.patientsActionEditPatient,
                style: itemStyle,
              ),
            ),
          ];
        },
      ),
    );
  }
}
