import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:subqdocs_bloc/core/constants/app_assets.dart';
import 'package:subqdocs_bloc/core/constants/app_colors.dart';
import 'package:subqdocs_bloc/core/constants/app_fonts.dart';
import 'package:subqdocs_bloc/core/models/session_user_info.dart';
import 'package:subqdocs_bloc/core/services/session_user_cache.dart';
import 'package:subqdocs_bloc/core/routing/app_router.dart';
import 'package:subqdocs_bloc/widgets/session_user_avatar.dart';

class CommonUserAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CommonUserAppBar({this.trailingActions, super.key});

  /// Optional actions shown after the user name (e.g. log out on home).
  final List<Widget>? trailingActions;

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: SessionUserCache.revision,
      builder: (BuildContext context, int _, Widget? __) {
        final SessionUserInfo info = SessionUserInfo.loadSync();

        return AppBar(
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          shape: Border(
            bottom: BorderSide(
              color: Colors.black.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          leadingWidth: 52,
          backgroundColor: AppColors.white,
          leading: GestureDetector(
            onTap: () => Scaffold.of(context).openDrawer(),
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.only(
                right: 12,
                top: 17,
                bottom: 17,
                left: 16,
              ),
              child: ColorFiltered(
                colorFilter: const ColorFilter.mode(
                  AppColors.drawerItemUnselected,
                  BlendMode.srcIn,
                ),
                child: SvgPicture.asset(
                  AppAssets.logoDrawer,
                  width: 24,
                  height: 18,
                ),
              ),
            ),
          ),
          centerTitle: false,
          titleSpacing: 0,
          title: SizedBox(
            width: 132,
            child: SvgPicture.asset(
              AppAssets.subqdocsLogoAppbar,
              height: 28,
              fit: BoxFit.contain,
            ),
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  GestureDetector(
                    onTap: () => AppRouter.goSettings(context),
                    behavior: HitTestBehavior.opaque,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        SessionUserAvatar(
                          info: info,
                          radius: 22,
                          initialsTextStyle: AppFonts.semiBold(
                            18,
                            AppColors.white,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          info.displayName,
                          style: AppFonts.medium(14, AppColors.primaryText),
                        ),
                      ],
                    ),
                  ),
                  if (trailingActions != null) ...trailingActions!,
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
