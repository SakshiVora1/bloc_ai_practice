import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:subqdocs_bloc/features/patients/data/patient_list_row.dart';
import 'package:subqdocs_bloc/features/patients/domain/patients_row_menu_action.dart';
import 'package:subqdocs_bloc/features/patients/presentation/bloc/patients_screen_bloc.dart';
import 'package:subqdocs_bloc/features/patients/presentation/widgets/patients_bottom_pagination_loader.dart';
import 'package:subqdocs_bloc/features/patients/presentation/widgets/patients_empty_state.dart';
import 'package:subqdocs_bloc/features/patients/presentation/widgets/patients_table_data_row.dart';

class PatientsTableBody extends StatelessWidget {
  const PatientsTableBody({
    required this.ready,
    required this.onNearBottom,
    required this.onNameTap,
    required this.onMenuAction,
    required this.onEmptyAddPatient,
    super.key,
  });

  final PatientsScreenReady ready;
  final VoidCallback onNearBottom;
  final void Function(int patientId) onNameTap;
  final void Function(PatientsRowMenuAction action, PatientListRow row)
  onMenuAction;
  final VoidCallback onEmptyAddPatient;

  @override
  Widget build(BuildContext context) {
    if (!ready.isPageOneLoading && ready.rows.isEmpty) {
      return PatientsEmptyState(onAddPatient: onEmptyAddPatient);
    }

    final bool showSkeletonOnly = ready.isPageOneLoading && ready.rows.isEmpty;
    final int itemCount = showSkeletonOnly
        ? 10
        : ready.rows.length + (ready.isLoadingMore ? 1 : 0);

    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification n) {
        if (ready.isPageOneLoading || ready.isLoadingMore || !ready.hasMore) {
          return false;
        }
        final ScrollMetrics m = n.metrics;
        if (!m.hasPixels || !m.hasViewportDimension) {
          return false;
        }
        if (m.pixels >= m.maxScrollExtent - 120) {
          onNearBottom();
        }
        return false;
      },
      child: Skeletonizer(
        enabled: ready.isPageOneLoading,
        child: ListView.separated(
          padding: const EdgeInsets.only(bottom: 88),
          itemCount: itemCount,
          separatorBuilder: (_, __) => const SizedBox.shrink(),
          itemBuilder: (BuildContext context, int index) {
            if (!showSkeletonOnly &&
                ready.isLoadingMore &&
                index == ready.rows.length) {
              return const PatientsBottomPaginationLoader();
            }

            final PatientListRow row = showSkeletonOnly
                ? PatientListRow.skeleton()
                : ready.rows[index];

            return PatientsTableDataRow(
              row: row,
              onNameTap: row.id < 0 ? () {} : () => onNameTap(row.id),
              onMenuAction: row.id < 0
                  ? (_) {}
                  : (PatientsRowMenuAction a) => onMenuAction(a, row),
            );
          },
        ),
      ),
    );
  }
}
