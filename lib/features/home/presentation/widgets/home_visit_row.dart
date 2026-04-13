import 'package:flutter/material.dart';
import 'package:subqdocs_bloc/core/constants/app_colors.dart';
import 'package:subqdocs_bloc/core/constants/app_fonts.dart';
import 'package:subqdocs_bloc/core/constants/app_strings.dart';
import 'package:subqdocs_bloc/features/home/domain/home_visit_display.dart';
import 'package:subqdocs_bloc/features/home/domain/status_mapping.dart';
import 'package:subqdocs_bloc/features/home/presentation/widgets/home_visit_avatar.dart';
import 'package:subqdocs_bloc/features/home/presentation/widgets/home_visit_marker.dart';

class HomeVisitRow extends StatelessWidget {
  const HomeVisitRow({
    super.key,
    required this.visit,
    required this.markerType,
  });

  final Map<String, dynamic> visit;
  final HomeVisitMarkerType markerType;

  @override
  Widget build(BuildContext context) {
    final String visitTime = formatHomeVisitDateTime(
      visit['appointmentTime']?.toString(),
      visit['visit_time']?.toString(),
    );
    final String doctor = homeVisitDoctorName(visit['doctorName']?.toString());
    final String firstName = visit['first_name']?.toString().trim() ?? '';
    final String lastName = visit['last_name']?.toString().trim() ?? '';
    final String fullName = '$firstName $lastName'.trim();
    final String gender = homeVisitGenderCode(visit['gender']?.toString());
    final String dateAge = homeVisitDateAndAge(
      visit['date_of_birth']?.toString(),
      visit['age'],
    );
    final String visitType =
        (visit['visitTypeName']?.toString().trim().isNotEmpty ?? false)
        ? visit['visitTypeName'].toString().trim()
        : AppStrings.homeUnknownLabel;
    final String visitDescription =
        (visit['visit_type_description']?.toString().trim().isNotEmpty ?? false)
        ? visit['visit_type_description'].toString().trim()
        : AppStrings.homeUnknownLabel;
    final String status = visit['visit_status']?.toString().trim() ?? '';

    return Container(
      height: 88,
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(bottom: BorderSide(color: AppColors.homeSectionDivider)),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Container(
              color: AppColors.homeTimeColumnBackground,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: <Widget>[
                  HomeVisitMarker(type: markerType),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          visitTime,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppFonts.medium(12, AppColors.primaryText),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          doctor,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppFonts.regular(12, AppColors.secondaryText),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: <Widget>[
                  HomeVisitAvatar(name: fullName),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '$fullName ($gender)',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppFonts.medium(14, AppColors.primaryText),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          dateAge,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppFonts.regular(12, AppColors.secondaryText),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: MediaQuery.orientationOf(context) == Orientation.portrait
                ? 2
                : 3,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    visitType.trim(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppFonts.medium(13, AppColors.primaryText),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    visitDescription.trim(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppFonts.regular(12, AppColors.secondaryText),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                SizedBox(
                  width: MediaQuery.orientationOf(context) == Orientation.portrait
                      ? 155
                      : 180,
                  height: 30,
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: StatusMapping.getColor(status)
                          .withAlpha((0.2 * 255).toInt()),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      status,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppFonts.medium(
                        12,
                        StatusMapping.getColor(status),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 30,
                    minHeight: 30,
                  ),
                  splashRadius: 16,
                  icon: const Icon(
                    Icons.more_vert,
                    size: 18,
                    color: AppColors.secondaryText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
