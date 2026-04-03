import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subqdocs_bloc/core/constants/app_colors.dart';
import 'package:subqdocs_bloc/core/constants/app_fonts.dart';
import 'package:subqdocs_bloc/core/constants/app_strings.dart';
import 'package:subqdocs_bloc/features/patients/domain/patient_sort_column.dart';
import 'package:subqdocs_bloc/features/patients/presentation/bloc/patients_screen_bloc.dart';
import 'package:subqdocs_bloc/features/patients/presentation/widgets/patients_sortable_table_header_cell.dart';

class PatientsTableHeaderRow extends StatelessWidget {
  const PatientsTableHeaderRow({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PatientsScreenBloc, PatientsScreenState>(
      buildWhen: (PatientsScreenState previous, PatientsScreenState current) {
        if (previous is! PatientsScreenReady ||
            current is! PatientsScreenReady) {
          return true;
        }
        return previous.activeSortColumn != current.activeSortColumn ||
            previous.sortDescending != current.sortDescending;
      },
      builder: (BuildContext context, PatientsScreenState state) {
        final PatientsScreenReady? ready = state is PatientsScreenReady
            ? state
            : null;
        final PatientSortColumn? active = ready?.activeSortColumn;
        final bool desc = ready?.sortDescending ?? false;

        void sort(PatientSortColumn column) {
          context.read<PatientsScreenBloc>().add(
            PatientsSortColumnTapped(column),
          );
        }

        return DecoratedBox(
          decoration: const BoxDecoration(
            color: AppColors.patientsTableHeaderBackground,
          ),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  flex: 36,
                  child: PatientsSortableTableHeaderCell(
                    label: AppStrings.patientsColPatientName,
                    column: PatientSortColumn.patientName,
                    isActive: active == PatientSortColumn.patientName,
                    descending: desc,
                    onTap: () => sort(PatientSortColumn.patientName),
                  ),
                ),
                Expanded(
                  flex: 10,
                  child: PatientsSortableTableHeaderCell(
                    label: AppStrings.patientsColAge,
                    column: PatientSortColumn.age,
                    isActive: active == PatientSortColumn.age,
                    descending: desc,
                    onTap: () => sort(PatientSortColumn.age),
                  ),
                ),
                Expanded(
                  flex: 10,
                  child: PatientsSortableTableHeaderCell(
                    label: AppStrings.patientsColGender,
                    column: PatientSortColumn.gender,
                    isActive: active == PatientSortColumn.gender,
                    descending: desc,
                    onTap: () => sort(PatientSortColumn.gender),
                  ),
                ),
                Expanded(
                  flex: 14,
                  child: PatientsSortableTableHeaderCell(
                    label: AppStrings.patientsColLastVisit,
                    column: PatientSortColumn.lastVisitDate,
                    isActive: active == PatientSortColumn.lastVisitDate,
                    descending: desc,
                    onTap: () => sort(PatientSortColumn.lastVisitDate),
                  ),
                ),
                Expanded(
                  flex: 12,
                  child: PatientsSortableTableHeaderCell(
                    label: AppStrings.patientsColPreviousVisits,
                    column: PatientSortColumn.previousVisits,
                    isActive: active == PatientSortColumn.previousVisits,
                    descending: desc,
                    onTap: () => sort(PatientSortColumn.previousVisits),
                  ),
                ),
                Expanded(
                  flex: 10,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 8,
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        AppStrings.patientsColAction,
                        style: AppFonts.regular(14, AppColors.black),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
