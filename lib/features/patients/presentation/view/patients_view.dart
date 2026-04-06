import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subqdocs_bloc/core/constants/app_colors.dart';
import 'package:subqdocs_bloc/core/constants/app_strings.dart';
import 'package:subqdocs_bloc/core/enums/app_drawer_item.dart';
import 'package:subqdocs_bloc/core/routing/app_router.dart';
import 'package:subqdocs_bloc/core/services/app_toast.dart';
import 'package:subqdocs_bloc/features/patients/data/patient_list_row.dart';
import 'package:subqdocs_bloc/features/patients/domain/patient_sort_column.dart';
import 'package:subqdocs_bloc/features/patients/domain/patients_row_menu_action.dart';
import 'package:subqdocs_bloc/features/patients/presentation/bloc/patients_screen_bloc.dart';
import 'package:subqdocs_bloc/features/patients/presentation/widgets/patients_load_failure_body.dart';
import 'package:subqdocs_bloc/features/patients/presentation/widgets/patients_ready_body.dart';
import 'package:subqdocs_bloc/features/patients/presentation/widgets/patients_screen_header_section.dart';
import 'package:subqdocs_bloc/features/patients/presentation/widgets/patients_record_now_fab.dart';
import 'package:subqdocs_bloc/widgets/common_app_drawer.dart';
import 'package:subqdocs_bloc/widgets/common_user_app_bar.dart';

class PatientsView extends StatefulWidget {
  const PatientsView({super.key});

  @override
  State<PatientsView> createState() => _PatientsViewState();
}

class _PatientsViewState extends State<PatientsView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchQueryChanged(String query) {
    context.read<PatientsScreenBloc>().add(PatientsSearchQueryChanged(query));
  }

  void _onSearchClear() {
    _searchController.clear();
    context.read<PatientsScreenBloc>().add(const PatientsSearchCleared());
  }

  void _onSortColumnPressed(PatientSortColumn column) {
    context.read<PatientsScreenBloc>().add(PatientsSortColumnPressed(column));
  }

  void _onLoadMoreRequested() {
    context.read<PatientsScreenBloc>().add(const PatientsLoadMoreRequested());
  }

  void _onRetryRequested() {
    context.read<PatientsScreenBloc>().add(const PatientsRetryRequested());
  }

  void _onAddPatient() {
    AppToast.showInfo(context, AppStrings.patientsAddPatientComingSoon);
  }

  void _onPatientNameTap(int patientId) {
    AppRouter.pushMedicalRecord(context, patientId: patientId);
  }

  void _onRowMenuAction(PatientsRowMenuAction action, PatientListRow row) {
    switch (action) {
      case PatientsRowMenuAction.medicalRecord:
        AppRouter.pushMedicalRecord(context, patientId: row.id);
      case PatientsRowMenuAction.startVisit:
        AppToast.showInfo(context, AppStrings.patientsStartVisitComingSoon);
      case PatientsRowMenuAction.schedule:
        AppToast.showInfo(context, AppStrings.patientsScheduleComingSoon);
      case PatientsRowMenuAction.editPatient:
        AppToast.showInfo(context, AppStrings.patientsEditPatientComingSoon);
    }
  }

  Widget _buildReadySurface(PatientsScreenReady ready) {
    return PatientsReadyBody(
      ready: ready,
      searchController: _searchController,
      onSearchChanged: _onSearchQueryChanged,
      onSearchClear: _onSearchClear,
      onSort: _onSortColumnPressed,
      onNearBottom: _onLoadMoreRequested,
      onNameTap: _onPatientNameTap,
      onMenuAction: _onRowMenuAction,
      onEmptyAddPatient: _onAddPatient,
      onAddPatient: _onAddPatient,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: <BlocListener<PatientsScreenBloc, PatientsScreenState>>[
        BlocListener<PatientsScreenBloc, PatientsScreenState>(
          listenWhen: (PatientsScreenState p, PatientsScreenState c) {
            return c is PatientsScreenLoadFailed;
          },
          listener: (BuildContext context, PatientsScreenState state) {
            final PatientsScreenLoadFailed s =
                state as PatientsScreenLoadFailed;
            AppToast.showError(context, s.message);
          },
        ),
        BlocListener<PatientsScreenBloc, PatientsScreenState>(
          listenWhen: (PatientsScreenState p, PatientsScreenState c) {
            return switch (c) {
              PatientsScreenReady(:final loadMoreErrorMessage) =>
                loadMoreErrorMessage != null,
              _ => false,
            };
          },
          listener: (BuildContext context, PatientsScreenState state) {
            final PatientsScreenReady r = state as PatientsScreenReady;
            final String? m = r.loadMoreErrorMessage;
            if (m != null && m.isNotEmpty) {
              AppToast.showError(context, m);
              context.read<PatientsScreenBloc>().add(
                const PatientsLoadMoreErrorConsumed(),
              );
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: AppColors.scaffoldWhite,
        appBar: const CommonUserAppBar(),
        drawer: const CommonAppDrawer(selectedItem: AppDrawerItem.patients),
        floatingActionButton: PatientsRecordNowFab(
          onPressed: () => AppRouter.goHome(context),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        body: SafeArea(
          bottom: false,
          child: BlocBuilder<PatientsScreenBloc, PatientsScreenState>(
            builder: (BuildContext context, PatientsScreenState state) {
              return switch (state) {
                PatientsScreenInitial() => _buildReadySurface(
                  PatientsScreenReady.initialPageOneLoading,
                ),
                PatientsScreenLoadFailed(:final message) => Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    PatientsScreenHeaderSection(
                      outerPadding:
                          PatientsScreenHeaderSection.compactOuterPadding,
                      searchController: _searchController,
                      onSearchChanged: _onSearchQueryChanged,
                      onSearchClear: _onSearchClear,
                      onAddPatient: _onAddPatient,
                    ),
                    Expanded(
                      child: PatientsLoadFailureBody(
                        message: message,
                        onRetry: _onRetryRequested,
                      ),
                    ),
                  ],
                ),
                final PatientsScreenReady ready => _buildReadySurface(ready),
              };
            },
          ),
        ),
      ),
    );
  }
}
