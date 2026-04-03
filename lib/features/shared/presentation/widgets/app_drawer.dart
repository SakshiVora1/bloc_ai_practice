import 'package:flutter/material.dart';
import 'package:subqdocs_bloc/core/constants/app_colors.dart';
import 'package:subqdocs_bloc/core/routing/app_router.dart';
import 'package:subqdocs_bloc/core/enums/drawer_primary_action.dart';
import 'package:subqdocs_bloc/features/shared/presentation/widgets/drawer_footer_actions.dart';
import 'package:subqdocs_bloc/features/shared/presentation/widgets/drawer_header_profile.dart';
import 'package:subqdocs_bloc/features/shared/presentation/widgets/drawer_primary_actions.dart';

/// Full drawer layout: profile header, primary actions, footer.
class AppDrawer extends StatelessWidget {
  const AppDrawer({
    super.key,
    required this.providerName,
    required this.selectedPrimary,
    required this.onPrimaryAction,
    required this.onContactSupport,
    required this.onSettings,
  });

  final String providerName;
  final DrawerPrimaryAction? selectedPrimary;
  final void Function(DrawerPrimaryAction action) onPrimaryAction;
  final VoidCallback onContactSupport;
  final VoidCallback onSettings;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.drawerBackground,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DrawerHeaderProfile(
            providerName: providerName,
            onClose: () => AppRouter.maybePop(context),
          ),
          const Divider(height: 1, color: AppColors.drawerDivider),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: DrawerPrimaryActions(
                selected: selectedPrimary,
                onAction: onPrimaryAction,
              ),
            ),
          ),
          const Divider(height: 1, color: AppColors.drawerDivider),
          DrawerFooterActions(
            onContactSupport: onContactSupport,
            onSettings: onSettings,
          ),
        ],
      ),
    );
  }
}
