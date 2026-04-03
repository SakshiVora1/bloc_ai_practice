import 'package:flutter/material.dart';
import 'package:subqdocs_bloc/core/constants/app_colors.dart';
import 'package:subqdocs_bloc/core/constants/app_fonts.dart';
import 'package:subqdocs_bloc/core/constants/app_strings.dart';
import 'package:subqdocs_bloc/core/enums/drawer_primary_action.dart';

/// Primary drawer actions (Record Now, Schedule, etc.).
class DrawerPrimaryActions extends StatelessWidget {
  const DrawerPrimaryActions({
    super.key,
    required this.selected,
    required this.onAction,
  });

  final DrawerPrimaryAction? selected;
  final void Function(DrawerPrimaryAction action) onAction;

  @override
  Widget build(BuildContext context) {
    final double gap = MediaQuery.sizeOf(context).height * 0.005;
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.sizeOf(context).width * 0.02,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _DrawerTile(
            icon: Icons.fiber_manual_record_rounded,
            label: AppStrings.drawerRecordNow,
            highlighted: selected == DrawerPrimaryAction.recordNow,
            onTap: () => onAction(DrawerPrimaryAction.recordNow),
          ),
          SizedBox(height: gap),
          _DrawerTile(
            icon: Icons.calendar_month_rounded,
            label: AppStrings.drawerSchedule,
            highlighted: selected == DrawerPrimaryAction.schedule,
            onTap: () => onAction(DrawerPrimaryAction.schedule),
          ),
          SizedBox(height: gap),
          _DrawerTile(
            icon: Icons.people_outline_rounded,
            label: AppStrings.drawerPatients,
            highlighted: selected == DrawerPrimaryAction.patients,
            onTap: () => onAction(DrawerPrimaryAction.patients),
          ),
          SizedBox(height: gap),
          _DrawerTile(
            icon: Icons.medication_liquid_outlined,
            label: AppStrings.drawerPrescription,
            highlighted: selected == DrawerPrimaryAction.prescription,
            onTap: () => onAction(DrawerPrimaryAction.prescription),
          ),
          SizedBox(height: gap),
          _DrawerTile(
            icon: Icons.fact_check_outlined,
            label: AppStrings.drawerPatientCheckIn,
            highlighted: selected == DrawerPrimaryAction.patientCheckIn,
            onTap: () => onAction(DrawerPrimaryAction.patientCheckIn),
          ),
        ],
      ),
    );
  }
}

class _DrawerTile extends StatelessWidget {
  const _DrawerTile({
    required this.icon,
    required this.label,
    required this.highlighted,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool highlighted;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color bg = highlighted
        ? AppColors.chipSelectedBackground
        : Colors.transparent;
    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Row(
            children: [
              Icon(icon, color: AppColors.primaryText, size: 22),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: AppFonts.regular(14, AppColors.primaryText),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
