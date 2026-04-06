import 'package:flutter/material.dart';
import 'package:subqdocs_bloc/core/constants/app_colors.dart';
import 'package:subqdocs_bloc/core/constants/app_fonts.dart';
import 'package:subqdocs_bloc/core/constants/app_strings.dart';
import 'package:subqdocs_bloc/features/patients/domain/patient_sort_column.dart';
import 'package:subqdocs_bloc/features/patients/presentation/widgets/patients_sortable_header_cell.dart';
import 'package:subqdocs_bloc/features/patients/presentation/widgets/patients_table_metrics.dart';

class PatientsTableHeaderRow extends StatelessWidget {
  const PatientsTableHeaderRow({
    required this.activeSortColumn,
    required this.sortDescending,
    required this.onSortPressed,
    super.key,
  });

  final PatientSortColumn? activeSortColumn;
  final bool sortDescending;
  final ValueChanged<PatientSortColumn> onSortPressed;

  @override
  Widget build(BuildContext context) {
    Widget sortableHeader({
      required int flex,
      required String label,
      required PatientSortColumn column,
      required TextAlign textAlign,
      required EdgeInsetsGeometry padding,
    }) {
      return Expanded(
        flex: flex,
        child: PatientsSortableHeaderCell(
          label: label,
          column: column,
          textAlign: textAlign,
          padding: padding,
          onPressed: () => onSortPressed(column),
          isActive: activeSortColumn == column,
          descending: sortDescending,
        ),
      );
    }

    return DecoratedBox(
      decoration: const BoxDecoration(color: AppColors.patientsTableHeaderBar),
      child: Row(
        children: <Widget>[
          sortableHeader(
            flex: PatientsTableMetrics.flexPatientName,
            label: AppStrings.patientsColPatientName,
            column: PatientSortColumn.patientName,
            textAlign: TextAlign.start,
            padding: PatientsTableMetrics.headerNamePadding,
          ),
          sortableHeader(
            flex: PatientsTableMetrics.flexAge,
            label: AppStrings.patientsColAge,
            column: PatientSortColumn.age,
            textAlign: TextAlign.center,
            padding: PatientsTableMetrics.headerAgeColumnPadding,
          ),
          sortableHeader(
            flex: PatientsTableMetrics.flexGender,
            label: AppStrings.patientsColGender,
            column: PatientSortColumn.gender,
            textAlign: TextAlign.center,
            padding: PatientsTableMetrics.headerCompactColumnPadding,
          ),
          sortableHeader(
            flex: PatientsTableMetrics.flexLastVisit,
            label: AppStrings.patientsColLastVisit,
            column: PatientSortColumn.lastVisitDate,
            textAlign: TextAlign.center,
            padding: PatientsTableMetrics.headerCompactColumnPadding,
          ),
          sortableHeader(
            flex: PatientsTableMetrics.flexPreviousVisits,
            label: AppStrings.patientsColPreviousVisits,
            column: PatientSortColumn.previousVisits,
            textAlign: TextAlign.center,
            padding: PatientsTableMetrics.headerCompactColumnPadding,
          ),
          Expanded(
            flex: PatientsTableMetrics.flexAction,
            child: Padding(
              padding: const EdgeInsets.only(
                right: PatientsTableMetrics.actionTrailingInset,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    AppStrings.patientsColAction,
                    textAlign: TextAlign.end,
                    maxLines: 1,
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                    style: AppFonts.regular(14, AppColors.black),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
