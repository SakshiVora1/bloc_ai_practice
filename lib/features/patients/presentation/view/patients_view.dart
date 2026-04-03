import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subqdocs_bloc/core/constants/app_colors.dart';
import 'package:subqdocs_bloc/core/enums/app_drawer_item.dart';
import 'package:subqdocs_bloc/core/services/app_toast.dart';
import 'package:subqdocs_bloc/features/patients/presentation/bloc/patients_screen_bloc.dart';
import 'package:subqdocs_bloc/features/patients/presentation/widgets/patients_load_failure_body.dart';
import 'package:subqdocs_bloc/features/patients/presentation/widgets/patients_page_header_row.dart';
import 'package:subqdocs_bloc/features/patients/presentation/widgets/patients_record_now_bottom_bar.dart';
import 'package:subqdocs_bloc/features/patients/presentation/widgets/patients_table_body.dart';
import 'package:subqdocs_bloc/widgets/common_app_drawer.dart';
import 'package:subqdocs_bloc/widgets/common_user_app_bar.dart';

class PatientsView extends StatelessWidget {
  const PatientsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<PatientsScreenBloc, PatientsScreenState>(
      listenWhen: (PatientsScreenState previous, PatientsScreenState current) {
        if (current is! PatientsScreenReady) {
          return false;
        }
        if (current.lastApiError == null) {
          return false;
        }
        if (previous is! PatientsScreenReady) {
          return true;
        }
        return current.lastApiError != previous.lastApiError;
      },
      listener: (BuildContext context, PatientsScreenState state) {
        final PatientsScreenReady ready = state as PatientsScreenReady;
        final String message = ready.lastApiError ?? '';
        if (message.isEmpty) {
          return;
        }
        AppToast.showError(context, message);
        context.read<PatientsScreenBloc>().add(
          const PatientsApiErrorToastConsumed(),
        );
      },
      child: Scaffold(
        backgroundColor: AppColors.scaffoldWhite,
        appBar: const CommonUserAppBar(),
        drawer: const CommonAppDrawer(selectedItem: AppDrawerItem.patients),
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const PatientsPageHeaderRow(),
                Expanded(
                  child: BlocBuilder<PatientsScreenBloc, PatientsScreenState>(
                    builder: (BuildContext context, PatientsScreenState state) {
                      return switch (state) {
                        PatientsScreenInitial() => const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.drawerItemSelected,
                          ),
                        ),
                        PatientsScreenFailure(:final message) =>
                          PatientsLoadFailureBody(message: message),
                        PatientsScreenReady() => PatientsTableBody(
                          state: state,
                        ),
                      };
                    },
                  ),
                ),
              ],
            ),
            const Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: PatientsRecordNowBottomBar(),
            ),
          ],
        ),
      ),
    );
  }
}
