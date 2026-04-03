import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:subqdocs_bloc/core/constants/app_assets.dart';
import 'package:subqdocs_bloc/core/constants/app_colors.dart';
import 'package:subqdocs_bloc/core/constants/app_fonts.dart';
import 'package:subqdocs_bloc/core/constants/app_strings.dart';
import 'package:subqdocs_bloc/features/home/presentation/bloc/home_screen_bloc.dart';
import 'package:subqdocs_bloc/features/home/presentation/widgets/schedule_date_popover.dart';
import 'package:subqdocs_bloc/widgets/common_button.dart';
import 'package:subqdocs_bloc/widgets/date_selector_widget.dart';
import 'package:subqdocs_bloc/widgets/search_bar_widget.dart';

class HomeScheduleTopSection extends StatefulWidget {
  const HomeScheduleTopSection({super.key});

  @override
  State<HomeScheduleTopSection> createState() => _HomeScheduleTopSectionState();
}

class _HomeScheduleTopSectionState extends State<HomeScheduleTopSection> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeScreenBloc, HomeScreenState>(
      builder: (BuildContext context, HomeScreenState state) {
        if (state is! HomeScreenReady) {
          return const SizedBox.shrink();
        }
        final HomeScreenReady scheduleState = state;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              AppStrings.homeScheduleTopTitle,
              style: AppFonts.medium(16, AppColors.primaryText),
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: <Widget>[
                        SearchBarWidget(
                          hintText: AppStrings.homeScheduleSearchHint,
                          onChanged: (String q) => context
                              .read<HomeScreenBloc>()
                              .add(HomeScreenSearchQueryChanged(q)),
                        ),
                        const SizedBox(width: 8),
                        CommonButton(
                          label: AppStrings.homeScheduleFilter,
                          height: 40,
                          borderRadius: 6,
                          backgroundColor: AppColors.white,
                          textColor: AppColors.primaryText,
                          borderColor: AppColors.fieldBorder,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          elevation: 0,
                          onPressed: () => context.read<HomeScreenBloc>().add(
                            const HomeScreenFilterPanelOpened(),
                          ),
                        ),
                        const SizedBox(width: 8),
                        CommonButton(
                          label: AppStrings.homeScheduleVisit,
                          height: 40,
                          borderRadius: 6,
                          backgroundColor: AppColors.scheduleVisitAccent,
                          textColor: AppColors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          elevation: 0,
                          icon: SvgPicture.asset(
                            AppAssets.calendarWhite,
                            width: 20,
                            height: 20,
                          ),
                          onPressed: () => context.read<HomeScreenBloc>().add(
                            const HomeScreenScheduleVisitOpened(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                DateSelectorWidget(
                  displayLabel: scheduleState.displayLabel,
                  onPrevious: () => context.read<HomeScreenBloc>().add(
                    const HomeScreenDateBackward(),
                  ),
                  onNext: () => context.read<HomeScreenBloc>().add(
                    const HomeScreenDateForward(),
                  ),
                  onCenterTap: () {
                    showScheduleDatePopover(
                      context: context,
                      initialStart: scheduleState.startDate ?? DateTime.now(),
                      initialEnd: scheduleState.endDate,
                      onCommitted: (DateTime start, DateTime? end) {
                        context.read<HomeScreenBloc>().add(
                          HomeScreenDateSelected(start: start, end: end),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
