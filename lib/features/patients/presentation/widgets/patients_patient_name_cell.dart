import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:subqdocs_bloc/core/constants/app_colors.dart';
import 'package:subqdocs_bloc/core/constants/app_fonts.dart';
import 'package:subqdocs_bloc/features/patients/data/patient_list_row.dart';
import 'package:subqdocs_bloc/features/patients/presentation/widgets/patient_avatar_palette.dart';
import 'package:subqdocs_bloc/features/patients/presentation/widgets/patients_table_cell_style.dart';

class PatientsPatientNameCell extends StatelessWidget {
  const PatientsPatientNameCell({required this.row, super.key});

  final PatientListRow row;

  static const double _avatarNameGap = 8;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 5, 0, 5),
      child: ClipRect(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _Avatar(row: row),
            const SizedBox(width: _avatarNameGap),
            Expanded(
              child: Text(
                row.fullName,
                maxLines: 2,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                style: PatientsTableCellStyle.body,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.row});

  final PatientListRow row;

  @override
  Widget build(BuildContext context) {
    const double size = 30;
    final String? url = row.profileImageUrl;
    if (url != null && url.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(size / 2),
        child: CachedNetworkImage(
          imageUrl: url,
          width: size,
          height: size,
          fit: BoxFit.cover,
          placeholder: (_, __) =>
              _InitialsAvatar(initials: row.initials, patientId: row.id),
          errorWidget: (_, __, ___) =>
              _InitialsAvatar(initials: row.initials, patientId: row.id),
        ),
      );
    }
    return _InitialsAvatar(initials: row.initials, patientId: row.id);
  }
}

class _InitialsAvatar extends StatelessWidget {
  const _InitialsAvatar({required this.initials, required this.patientId});

  final String initials;
  final int patientId;

  @override
  Widget build(BuildContext context) {
    const double size = 30;
    final Color bg = PatientAvatarPalette.backgroundForPatientId(patientId);
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
      child: Text(initials, style: AppFonts.medium(11, AppColors.white)),
    );
  }
}
