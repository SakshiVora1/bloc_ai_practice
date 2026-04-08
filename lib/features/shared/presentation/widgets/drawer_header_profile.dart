import 'package:flutter/material.dart';
import 'package:subqdocs_bloc/core/constants/app_colors.dart';
import 'package:subqdocs_bloc/core/constants/app_fonts.dart';
import 'package:subqdocs_bloc/core/constants/app_strings.dart';

/// Drawer header: avatar, provider name, close control.
class DrawerHeaderProfile extends StatelessWidget {
  const DrawerHeaderProfile({
    super.key,
    required this.providerName,
    required this.onClose,
  });

  final String providerName;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.white,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 8, 16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: AppColors.primaryAction.withValues(
                  alpha: 0.15,
                ),
                child: Icon(
                  Icons.person_rounded,
                  color: AppColors.primaryAction,
                  size: 32,
                ),
              ),
              SizedBox(width: MediaQuery.sizeOf(context).width * 0.03),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      providerName.isEmpty
                          ? AppStrings.drawerProviderFallback
                          : providerName,
                      style: AppFonts.semiBold(18, AppColors.primaryText),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      AppStrings.drawerProviderFallback,
                      style: AppFonts.regular(12, AppColors.secondaryText),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: onClose,
                icon: const Icon(Icons.close_rounded),
                tooltip: AppStrings.drawerCloseSemantics,
                color: AppColors.secondaryText,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
