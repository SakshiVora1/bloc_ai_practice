import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:subqdocs_bloc/core/constants/app_assets.dart';
import 'package:subqdocs_bloc/core/constants/app_colors.dart';
import 'package:subqdocs_bloc/core/constants/app_fonts.dart';
import 'package:subqdocs_bloc/core/constants/app_strings.dart';
import 'package:subqdocs_bloc/core/enums/app_drawer_item.dart';
import 'package:subqdocs_bloc/core/models/session_user_info.dart';
import 'package:subqdocs_bloc/core/services/session_user_cache.dart';
import 'package:subqdocs_bloc/core/routing/app_router.dart';
import 'package:subqdocs_bloc/core/services/app_toast.dart';
import 'package:subqdocs_bloc/widgets/session_user_avatar.dart';

class CommonAppDrawer extends StatelessWidget {
  const CommonAppDrawer({
    required this.selectedItem,
    this.onItemTap,
    super.key,
  });

  final AppDrawerItem selectedItem;
  final ValueChanged<AppDrawerItem>? onItemTap;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: SessionUserCache.revision,
      builder: (BuildContext context, int _, Widget? __) {
        final SessionUserInfo info = SessionUserInfo.loadSync();

        return Drawer(
          width: 300,
          backgroundColor: AppColors.white,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _DrawerHeader(
                    info: info,
                    onProfileTap: () {
                      AppRouter.maybePop(context);
                      AppRouter.goSettings(context);
                    },
                  ),
                  const SizedBox(height: 14),
                  _RecordNowButton(
                    onTap: () => _handleTap(context, AppDrawerItem.schedule),
                  ),
                  const SizedBox(height: 8),
                  _DrawerMenuItem(
                    title: AppStrings.drawerSchedule,
                    iconPath: AppAssets.visitsMenu,
                    selected: selectedItem == AppDrawerItem.schedule,
                    onTap: () => _handleTap(context, AppDrawerItem.schedule),
                  ),
                  _DrawerMenuItem(
                    title: AppStrings.drawerPatients,
                    iconPath: AppAssets.patientsMenu,
                    selected: selectedItem == AppDrawerItem.patients,
                    onTap: () => _handleTap(context, AppDrawerItem.patients),
                  ),
                  _DrawerMenuItem(
                    title: AppStrings.drawerPrescription,
                    iconPath: AppAssets.prescription,
                    selected: selectedItem == AppDrawerItem.prescription,
                    onTap: () =>
                        _handleTap(context, AppDrawerItem.prescription),
                  ),
                  _DrawerMenuItem(
                    title: AppStrings.drawerPatientCheckIn,
                    iconPath: AppAssets.notepad,
                    selected: selectedItem == AppDrawerItem.patientCheckIn,
                    onTap: () =>
                        _handleTap(context, AppDrawerItem.patientCheckIn),
                  ),
                  const Spacer(),
                  _DrawerMenuItem(
                    title: AppStrings.drawerContactSupport,
                    iconPath: AppAssets.email,
                    selected: selectedItem == AppDrawerItem.contactSupport,
                    onTap: () =>
                        _handleTap(context, AppDrawerItem.contactSupport),
                  ),
                  _DrawerMenuItem(
                    title: AppStrings.drawerSettings,
                    iconPath: AppAssets.settingsDrawer,
                    selected: selectedItem == AppDrawerItem.settings,
                    onTap: () => _handleTap(context, AppDrawerItem.settings),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.only(left: 6),
                    child: Text(
                      AppStrings.drawerVersionLabel,
                      style: AppFonts.regular(
                        12,
                        AppColors.drawerItemUnselected,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _handleTap(BuildContext context, AppDrawerItem item) {
    AppRouter.maybePop(context);
    if (onItemTap != null) {
      onItemTap!(item);
      return;
    }
    switch (item) {
      case AppDrawerItem.schedule:
        AppRouter.goHome(context);
      case AppDrawerItem.patients:
        AppRouter.goPatients(context);
      case AppDrawerItem.settings:
        AppRouter.goSettings(context);
      case AppDrawerItem.prescription:
      case AppDrawerItem.patientCheckIn:
      case AppDrawerItem.contactSupport:
        AppToast.showInfo(context, AppStrings.drawerFeatureComingSoon);
    }
  }
}

class _DrawerHeader extends StatelessWidget {
  const _DrawerHeader({required this.info, required this.onProfileTap});

  final SessionUserInfo info;
  final VoidCallback onProfileTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: GestureDetector(
            onTap: onProfileTap,
            behavior: HitTestBehavior.opaque,
            child: Row(
              children: <Widget>[
                SessionUserAvatar(
                  info: info,
                  radius: 17,
                  initialsTextStyle: AppFonts.semiBold(12, AppColors.white),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        info.displayName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppFonts.medium(15, AppColors.primaryText),
                      ),
                      if (info.title.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                            info.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppFonts.regular(
                              12,
                              AppColors.drawerItemUnselected,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        IconButton(
          onPressed: () => AppRouter.maybePop(context),
          icon: const Icon(
            Icons.close,
            color: AppColors.drawerCloseIcon,
            size: 20,
          ),
        ),
      ],
    );
  }
}

class _RecordNowButton extends StatelessWidget {
  const _RecordNowButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(6),
      onTap: onTap,
      child: Ink(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        decoration: BoxDecoration(
          color: AppColors.recordNow,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          children: <Widget>[
            SvgPicture.asset(
              AppAssets.quickStart,
              width: 18,
              height: 18,
              theme: const SvgTheme(currentColor: AppColors.black),
              colorFilter: const ColorFilter.mode(
                AppColors.black,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              AppStrings.drawerRecordNow,
              style: AppFonts.semiBold(14, AppColors.black),
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerMenuItem extends StatelessWidget {
  const _DrawerMenuItem({
    required this.title,
    required this.iconPath,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final String iconPath;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color contentColor = selected
        ? AppColors.white
        : AppColors.drawerItemUnselected;
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: InkWell(
        borderRadius: BorderRadius.circular(6),
        onTap: onTap,
        child: Ink(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
          decoration: BoxDecoration(
            color: selected ? AppColors.drawerItemSelected : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            children: <Widget>[
              SvgPicture.asset(
                iconPath,
                width: 18,
                height: 18,
                theme: SvgTheme(currentColor: contentColor),
                colorFilter: ColorFilter.mode(contentColor, BlendMode.srcIn),
              ),
              const SizedBox(width: 8),
              Text(title, style: AppFonts.medium(15, contentColor)),
            ],
          ),
        ),
      ),
    );
  }
}
