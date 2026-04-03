import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:subqdocs_bloc/core/constants/app_assets.dart';
import 'package:subqdocs_bloc/core/constants/app_colors.dart';
import 'package:subqdocs_bloc/core/constants/app_fonts.dart';
import 'package:subqdocs_bloc/core/constants/app_strings.dart';
import 'package:subqdocs_bloc/core/routing/app_router.dart';

class PatientsRecordNowBottomBar extends StatelessWidget {
  const PatientsRecordNowBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    final EdgeInsets padding = EdgeInsets.fromLTRB(
      16,
      0,
      16,
      12 + MediaQuery.paddingOf(context).bottom,
    );

    return Material(
      elevation: 8,
      color: AppColors.white,
      child: Padding(
        padding: padding,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () => AppRouter.goHome(context),
          child: Ink(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.recordNow,
              borderRadius: BorderRadius.circular(8),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: AppColors.black.withValues(alpha: 0.08),
                  blurRadius: math.max(8, 12),
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SvgPicture.asset(
                  AppAssets.quickStart,
                  width: 24,
                  height: 24,
                  colorFilter: const ColorFilter.mode(
                    AppColors.black,
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  AppStrings.drawerRecordNow,
                  style: AppFonts.medium(16, AppColors.black),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
