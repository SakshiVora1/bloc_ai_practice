import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:subqdocs_bloc/core/constants/app_assets.dart';
import 'package:subqdocs_bloc/core/constants/app_colors.dart';
import 'package:subqdocs_bloc/core/constants/app_fonts.dart';
import 'package:subqdocs_bloc/core/constants/app_strings.dart';
import 'package:subqdocs_bloc/core/routing/app_router.dart';
import 'package:subqdocs_bloc/widgets/common_button.dart';

class CommonDialog extends StatelessWidget {
  const CommonDialog({
    super.key,
    required this.title,
    required this.description,
    required this.confirmLabel,
    required this.onConfirm,
    this.imageAsset = AppAssets.confirmCheck,
    this.isLoading = false,
    this.autoCloseOnConfirm = true,
  });

  final String title;
  final String description;
  final String confirmLabel;
  final String imageAsset;
  final VoidCallback onConfirm;
  final bool isLoading;
  final bool autoCloseOnConfirm;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 400,
          color: AppColors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                width: double.infinity,
                height: 50,
                color: AppColors.drawerItemSelected,
                padding: const EdgeInsets.fromLTRB(16, 0, 8, 0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        title,
                        style: AppFonts.medium(15, AppColors.white),
                      ),
                    ),
                    IconButton(
                      onPressed: isLoading
                          ? null
                          : () => AppRouter.pop(context),
                      icon: const Icon(Icons.close, color: AppColors.white),
                      splashRadius: 16,
                      tooltip: AppStrings.cancelButton,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                child: Column(
                  children: <Widget>[
                    SvgPicture.asset(imageAsset, width: 54, height: 54),
                    const SizedBox(height: 16),
                    Text(
                      description,
                      textAlign: TextAlign.center,
                      style: AppFonts.medium(17, AppColors.black),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: CommonButton(
                            label: AppStrings.settingsDialogCancel,
                            height: 40,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            backgroundColor: AppColors.white,
                            textColor: AppColors.drawerItemSelected,
                            borderColor: AppColors.drawerItemSelected,
                            fontWeight: FontWeight.w500,
                            onPressed: isLoading
                                ? null
                                : () => AppRouter.pop(context),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: CommonButton(
                            label: confirmLabel,
                            height: 40,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            backgroundColor: AppColors.drawerItemSelected,
                            textColor: AppColors.white,
                            borderColor: AppColors.drawerItemSelected,
                            fontWeight: FontWeight.w500,
                            isLoading: isLoading,
                            onPressed: isLoading
                                ? null
                                : () {
                                    if (autoCloseOnConfirm) {
                                      AppRouter.pop(context);
                                    }
                                    onConfirm();
                                  },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
