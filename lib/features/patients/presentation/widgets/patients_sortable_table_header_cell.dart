import 'package:flutter/material.dart';
import 'package:subqdocs_bloc/core/constants/app_colors.dart';
import 'package:subqdocs_bloc/core/constants/app_fonts.dart';
import 'package:subqdocs_bloc/features/patients/domain/patient_sort_column.dart';

class PatientsSortableTableHeaderCell extends StatelessWidget {
  const PatientsSortableTableHeaderCell({
    required this.label,
    required this.column,
    required this.isActive,
    required this.descending,
    required this.onTap,
    super.key,
  });

  final String label;
  final PatientSortColumn column;
  final bool isActive;
  final bool descending;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Flexible(
                child: Text(
                  label,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppFonts.regular(14, AppColors.black),
                ),
              ),
              if (isActive) ...<Widget>[
                const SizedBox(width: 4),
                Icon(
                  descending ? Icons.arrow_downward : Icons.arrow_upward,
                  size: 16,
                  color: AppColors.black,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
