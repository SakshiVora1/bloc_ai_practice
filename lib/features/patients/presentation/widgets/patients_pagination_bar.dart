import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subqdocs_bloc/core/constants/app_colors.dart';
import 'package:subqdocs_bloc/core/constants/app_fonts.dart';
import 'package:subqdocs_bloc/core/constants/app_strings.dart';
import 'package:subqdocs_bloc/features/patients/presentation/bloc/patients_screen_bloc.dart';

class PatientsPaginationBar extends StatelessWidget {
  const PatientsPaginationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PatientsScreenBloc, PatientsScreenState>(
      buildWhen: (PatientsScreenState previous, PatientsScreenState current) {
        if (previous is! PatientsScreenReady ||
            current is! PatientsScreenReady) {
          return true;
        }
        return previous.page != current.page ||
            previous.totalPage != current.totalPage ||
            previous.totalCount != current.totalCount ||
            previous.isListLoading != current.isListLoading;
      },
      builder: (BuildContext context, PatientsScreenState state) {
        if (state is! PatientsScreenReady) {
          return const SizedBox.shrink();
        }
        final PatientsScreenReady s = state;
        final bool onFirst = s.page <= 1;
        final bool onLast = s.page >= s.totalPage || s.totalPage < 1;

        return Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
          child: Row(
            children: <Widget>[
              Text(
                '${s.totalCount} total',
                style: AppFonts.regular(12, AppColors.blueGray),
              ),
              const Spacer(),
              TextButton(
                onPressed: onFirst || s.isListLoading
                    ? null
                    : () => context.read<PatientsScreenBloc>().add(
                        const PatientsPreviousPageTapped(),
                      ),
                child: Text(
                  AppStrings.patientsPrev,
                  style: AppFonts.medium(14, AppColors.drawerItemSelected),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  '${s.page} / ${s.totalPage}',
                  style: AppFonts.regular(14, AppColors.primaryText),
                ),
              ),
              TextButton(
                onPressed: onLast || s.isListLoading
                    ? null
                    : () => context.read<PatientsScreenBloc>().add(
                        const PatientsNextPageTapped(),
                      ),
                child: Text(
                  AppStrings.patientsNext,
                  style: AppFonts.medium(14, AppColors.drawerItemSelected),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
