import 'package:flutter/material.dart';
import 'package:subqdocs_bloc/features/patients/data/patient_list_row.dart';
import 'package:subqdocs_bloc/features/patients/domain/patient_sort_column.dart';
import 'package:subqdocs_bloc/features/patients/domain/patients_row_menu_action.dart';
import 'package:subqdocs_bloc/features/patients/presentation/bloc/patients_screen_bloc.dart';
import 'package:subqdocs_bloc/features/patients/presentation/widgets/patients_screen_header_section.dart';
import 'package:subqdocs_bloc/features/patients/presentation/widgets/patients_table_body.dart';
import 'package:subqdocs_bloc/features/patients/presentation/widgets/patients_table_header_row.dart';

class PatientsReadyBody extends StatelessWidget {
  const PatientsReadyBody({
    required this.ready,
    required this.searchController,
    required this.onSearchChanged,
    required this.onSearchClear,
    required this.onSort,
    required this.onNearBottom,
    required this.onNameTap,
    required this.onMenuAction,
    required this.onEmptyAddPatient,
    required this.onAddPatient,
    super.key,
  });

  final PatientsScreenReady ready;
  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onSearchClear;
  final ValueChanged<PatientSortColumn> onSort;
  final VoidCallback onNearBottom;
  final void Function(int patientId) onNameTap;
  final void Function(PatientsRowMenuAction action, PatientListRow row)
  onMenuAction;
  final VoidCallback onEmptyAddPatient;
  final VoidCallback onAddPatient;

  static const double _horizontalTableMinWidth = 720;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        PatientsScreenHeaderSection(
          searchController: searchController,
          onSearchChanged: onSearchChanged,
          onSearchClear: onSearchClear,
          onAddPatient: onAddPatient,
        ),
        Expanded(
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final Widget tableCore = Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  PatientsTableHeaderRow(
                    activeSortColumn: ready.activeSortColumn,
                    sortDescending: ready.sortDescending,
                    onSortPressed: onSort,
                  ),
                  Expanded(
                    child: PatientsTableBody(
                      ready: ready,
                      onNearBottom: onNearBottom,
                      onNameTap: onNameTap,
                      onMenuAction: onMenuAction,
                      onEmptyAddPatient: onEmptyAddPatient,
                    ),
                  ),
                ],
              );

              if (constraints.maxWidth < _horizontalTableMinWidth) {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: _horizontalTableMinWidth,
                    height: constraints.maxHeight,
                    child: tableCore,
                  ),
                );
              }
              return tableCore;
            },
          ),
        ),
      ],
    );
  }
}
