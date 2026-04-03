import 'package:flutter/material.dart';
import 'package:subqdocs_bloc/core/constants/app_colors.dart';
import 'package:subqdocs_bloc/core/constants/app_fonts.dart';
import 'package:subqdocs_bloc/core/constants/app_strings.dart';
import 'package:subqdocs_bloc/core/models/session_user_info.dart';
import 'package:subqdocs_bloc/core/services/app_toast.dart';
import 'package:subqdocs_bloc/widgets/session_user_avatar.dart';

class SettingsProfileHeader extends StatelessWidget {
  const SettingsProfileHeader({super.key, required this.info});

  final SessionUserInfo info;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        SessionUserAvatar(
          info: info,
          radius: 30,
          initialsTextStyle: AppFonts.bold(18, AppColors.white),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            info.displayName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppFonts.medium(16, AppColors.black),
          ),
        ),
        Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: () => AppToast.showInfo(
              context,
              AppStrings.settingsEditNotImplemented,
            ),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(
                Icons.edit_outlined,
                size: 18,
                color: AppColors.drawerItemUnselected,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
