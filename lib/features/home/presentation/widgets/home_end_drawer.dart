import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subqdocs_bloc/core/constants/app_colors.dart';
import 'package:subqdocs_bloc/core/constants/app_fonts.dart';
import 'package:subqdocs_bloc/core/constants/app_strings.dart';
import 'package:subqdocs_bloc/features/home/presentation/bloc/home_screen_bloc.dart';
import 'package:subqdocs_bloc/features/home/presentation/widgets/home_filter_panel.dart';

class HomeEndDrawer extends StatelessWidget {
  const HomeEndDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.sizeOf(context).width * 0.45,
      backgroundColor: AppColors.white,
      child: SafeArea(
        child:
            BlocSelector<
              HomeScreenBloc,
              HomeScreenState,
              HomeScreenEndDrawerKind?
            >(
              selector: (HomeScreenState state) {
                return switch (state) {
                  HomeScreenReady(
                    :final HomeScreenEndDrawerKind? activeEndDrawer,
                  ) =>
                    activeEndDrawer,
                  HomeScreenInitial() => null,
                };
              },
              builder:
                  (
                    BuildContext context,
                    HomeScreenEndDrawerKind? activeEndDrawer,
                  ) {
                    final String title = switch (activeEndDrawer) {
                      HomeScreenEndDrawerKind.filter =>
                        AppStrings.homeEndDrawerFilterTitle,
                      HomeScreenEndDrawerKind.scheduleVisit =>
                        AppStrings.homeEndDrawerScheduleVisitTitle,
                      null => '',
                    };
                    final Widget content = switch (activeEndDrawer) {
                      HomeScreenEndDrawerKind.filter => const HomeFilterPanel(),
                      HomeScreenEndDrawerKind.scheduleVisit => Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Text(
                              title,
                              style: AppFonts.semiBold(
                                18,
                                AppColors.primaryText,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              AppStrings.homeSubtitle,
                              style: AppFonts.regular(
                                14,
                                AppColors.secondaryText,
                              ),
                            ),
                          ],
                        ),
                      ),
                      null => const SizedBox.shrink(),
                    };
                    return content;
                  },
            ),
      ),
    );
  }
}
