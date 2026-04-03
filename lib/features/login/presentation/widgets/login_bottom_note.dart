import 'package:flutter/material.dart';
import 'package:subqdocs_bloc/core/constants/app_colors.dart';
import 'package:subqdocs_bloc/core/constants/app_fonts.dart';
import 'package:subqdocs_bloc/core/constants/app_strings.dart';

class LoginBottomNote extends StatelessWidget {
  const LoginBottomNote({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      AppStrings.loginBottomNote,
      textAlign: TextAlign.center,
      style: AppFonts.regular(12, AppColors.secondaryText),
    );
  }
}
