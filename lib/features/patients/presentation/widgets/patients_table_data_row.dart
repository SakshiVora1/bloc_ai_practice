import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:subqdocs_bloc/core/constants/app_colors.dart';
import 'package:subqdocs_bloc/core/constants/app_fonts.dart';
import 'package:subqdocs_bloc/core/constants/app_strings.dart';
import 'package:subqdocs_bloc/core/routing/app_router.dart';
import 'package:subqdocs_bloc/core/services/app_toast.dart';
import 'package:subqdocs_bloc/features/patients/data/patient_list_row.dart';
import 'package:subqdocs_bloc/features/patients/domain/patients_row_menu_action.dart';

class PatientsTableDataRow extends StatelessWidget {
  const PatientsTableDataRow({required this.row, super.key});

  final PatientListRow row;

  @override
  Widget build(BuildContext context) {
    final TextStyle cellStyle = AppFonts.regular(14, AppColors.blueGray);

    return DecoratedBox(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.homeSectionDivider, width: 1),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(flex: 36, child: _PatientNameTapCell(row: row)),
            Expanded(flex: 10, child: Text(row.ageDisplay, style: cellStyle)),
            Expanded(
              flex: 10,
              child: Text(row.genderInitial, style: cellStyle),
            ),
            Expanded(
              flex: 14,
              child: Text(
                row.lastVisitDisplay,
                style: cellStyle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Expanded(
              flex: 12,
              child: Text('${row.previousVisitsCount}', style: cellStyle),
            ),
            Expanded(
              flex: 10,
              child: Align(
                alignment: Alignment.centerLeft,
                child: PopupMenuButton<PatientsRowMenuAction>(
                  icon: Icon(
                    Icons.more_vert,
                    color: AppColors.blueGray,
                    size: 22,
                  ),
                  padding: EdgeInsets.zero,
                  onSelected: (PatientsRowMenuAction value) {
                    switch (value) {
                      case PatientsRowMenuAction.startVisit:
                        AppToast.showInfo(
                          context,
                          AppStrings.patientsStartVisitComingSoon,
                        );
                      case PatientsRowMenuAction.medicalRecord:
                        AppRouter.pushMedicalRecord(context, patientId: row.id);
                      case PatientsRowMenuAction.schedule:
                        AppToast.showInfo(
                          context,
                          AppStrings.patientsScheduleComingSoon,
                        );
                      case PatientsRowMenuAction.editPatient:
                        AppToast.showInfo(
                          context,
                          AppStrings.patientsEditPatientComingSoon,
                        );
                    }
                  },
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<PatientsRowMenuAction>>[
                        PopupMenuItem<PatientsRowMenuAction>(
                          value: PatientsRowMenuAction.startVisit,
                          child: Text(
                            AppStrings.patientsActionStartVisit,
                            style: cellStyle,
                          ),
                        ),
                        const PopupMenuDivider(),
                        PopupMenuItem<PatientsRowMenuAction>(
                          value: PatientsRowMenuAction.medicalRecord,
                          child: Text(
                            AppStrings.patientsActionMedicalRecord,
                            style: cellStyle,
                          ),
                        ),
                        const PopupMenuDivider(),
                        PopupMenuItem<PatientsRowMenuAction>(
                          value: PatientsRowMenuAction.schedule,
                          child: Text(
                            AppStrings.patientsActionSchedule,
                            style: cellStyle,
                          ),
                        ),
                        const PopupMenuDivider(),
                        PopupMenuItem<PatientsRowMenuAction>(
                          value: PatientsRowMenuAction.editPatient,
                          child: Text(
                            AppStrings.patientsActionEditPatient,
                            style: cellStyle,
                          ),
                        ),
                      ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PatientNameTapCell extends StatelessWidget {
  const _PatientNameTapCell({required this.row});

  final PatientListRow row;

  @override
  Widget build(BuildContext context) {
    final String? url = row.profileImageUrl;
    final Widget avatar = url != null && url.isNotEmpty
        ? ClipOval(
            child: CachedNetworkImage(
              imageUrl: url,
              width: 30,
              height: 30,
              fit: BoxFit.cover,
              errorWidget: (BuildContext context, String _, Object __) =>
                  _InitialsAvatar(initials: row.initials),
            ),
          )
        : _InitialsAvatar(initials: row.initials);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => AppRouter.pushMedicalRecord(context, patientId: row.id),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            avatar,
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                row.fullName,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppFonts.regular(14, AppColors.blueGray),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InitialsAvatar extends StatelessWidget {
  const _InitialsAvatar({required this.initials});

  final String initials;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 30,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: AppColors.homeSectionDivider,
        shape: BoxShape.circle,
      ),
      child: Text(initials, style: AppFonts.medium(11, AppColors.blueGray)),
    );
  }
}
