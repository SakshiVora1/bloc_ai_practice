import 'package:flutter/material.dart';
import 'package:subqdocs_bloc/core/constants/app_colors.dart';
import 'package:subqdocs_bloc/core/models/session_user_info.dart';

class SessionUserAvatar extends StatelessWidget {
  const SessionUserAvatar({
    required this.info,
    required this.radius,
    required this.initialsTextStyle,
    super.key,
  });

  final SessionUserInfo info;
  final double radius;
  final TextStyle initialsTextStyle;

  @override
  Widget build(BuildContext context) {
    if (info.profileImageUrl.isNotEmpty) {
      return CircleAvatar(
        radius: radius,
        backgroundImage: NetworkImage(info.profileImageUrl),
        backgroundColor: AppColors.white,
      );
    }

    return CircleAvatar(
      radius: radius,
      backgroundColor: info.fallbackDarkColor,
      child: Text(info.initials, style: initialsTextStyle),
    );
  }
}
