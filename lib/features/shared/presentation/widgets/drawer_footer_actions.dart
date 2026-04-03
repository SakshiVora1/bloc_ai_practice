import 'package:flutter/material.dart';
import 'package:subqdocs_bloc/core/constants/app_colors.dart';
import 'package:subqdocs_bloc/core/constants/app_fonts.dart';
import 'package:subqdocs_bloc/core/constants/app_strings.dart';

/// Drawer footer: support, settings, app version.
class DrawerFooterActions extends StatelessWidget {
  const DrawerFooterActions({
    super.key,
    required this.onContactSupport,
    required this.onSettings,
  });

  final VoidCallback onContactSupport;
  final VoidCallback onSettings;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextButton.icon(
            onPressed: onContactSupport,
            style: TextButton.styleFrom(
              alignment: Alignment.centerLeft,
              foregroundColor: AppColors.primaryText,
            ),
            icon: const Icon(Icons.support_agent_rounded, size: 22),
            label: Text(
              AppStrings.drawerContactSupport,
              style: AppFonts.regular(14, AppColors.primaryText),
            ),
          ),
          TextButton.icon(
            onPressed: onSettings,
            style: TextButton.styleFrom(
              alignment: Alignment.centerLeft,
              foregroundColor: AppColors.primaryText,
            ),
            icon: const Icon(Icons.settings_outlined, size: 22),
            label: Text(
              AppStrings.drawerSettings,
              style: AppFonts.regular(14, AppColors.primaryText),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${AppStrings.drawerVersionLabel} ${AppStrings.drawerVersionValue}',
            style: AppFonts.regular(12, AppColors.secondaryText),
          ),
        ],
      ),
    );
  }
}
