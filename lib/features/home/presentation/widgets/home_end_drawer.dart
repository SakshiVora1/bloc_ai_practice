import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subqdocs_bloc/core/constants/app_colors.dart';
import 'package:subqdocs_bloc/features/home/presentation/bloc/home_screen_bloc.dart';
import 'package:subqdocs_bloc/features/home/presentation/widgets/home_filter_panel.dart';
import 'package:subqdocs_bloc/features/home/presentation/widgets/home_schedule_visit_panel.dart';

class HomeEndDrawer extends StatelessWidget {
  const HomeEndDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<HomeScreenBloc, HomeScreenState, HomeScreenEndDrawerKind?>(
      selector: (HomeScreenState state) {
        return switch (state) {
          HomeScreenReady(:final activeEndDrawer) => activeEndDrawer,
          HomeScreenInitial() => null,
        };
      },
      builder: (BuildContext context, HomeScreenEndDrawerKind? activeEndDrawer) {
        final double widthFactor =
            activeEndDrawer == HomeScreenEndDrawerKind.scheduleVisit ? 0.65 : 0.45;

        return Drawer(
          width: MediaQuery.sizeOf(context).width * widthFactor,
          backgroundColor: AppColors.white,
          child: SafeArea(
            child: switch (activeEndDrawer) {
              HomeScreenEndDrawerKind.filter => const HomeFilterPanel(),
              HomeScreenEndDrawerKind.scheduleVisit => const HomeScheduleVisitPanel(),
              null => const SizedBox.shrink(),
            },
          ),
        );
      },
    );
  }
}
