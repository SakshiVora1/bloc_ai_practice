import 'package:flutter/material.dart';
import 'package:subqdocs_bloc/core/constants/app_colors.dart';
import 'package:subqdocs_bloc/core/constants/app_fonts.dart';
import 'package:subqdocs_bloc/core/constants/app_strings.dart';
import 'package:subqdocs_bloc/features/home/presentation/widgets/home_filter_summary.dart';
import 'package:subqdocs_bloc/features/home/presentation/widgets/home_schedule_sections_scroll.dart';
import 'package:subqdocs_bloc/features/home/presentation/widgets/home_schedule_top_section.dart';

class HomeBodyContent extends StatelessWidget {
  const HomeBodyContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: ColoredBox(
        color: AppColors.scaffoldWhite,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 20, 16, 0),
              child: HomeScheduleTopSection(),
            ),
            const HomeFilterSummary(),
            const SizedBox(height: 8),
            Expanded(
              child: Stack(
                clipBehavior: Clip.none,
                children: <Widget>[
                  const HomeScheduleSectionsScroll(),
                  Positioned(
                    right: 16,
                    bottom: 16,
                    child: FloatingActionButton.extended(
                      onPressed: () {},
                      backgroundColor: AppColors.recordNow,
                      foregroundColor: AppColors.black,
                      icon: const Icon(Icons.fiber_manual_record, size: 18),
                      label: Text(
                        AppStrings.drawerRecordNow,
                        style: AppFonts.semiBold(14, AppColors.black),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
