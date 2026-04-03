import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:subqdocs_bloc/core/constants/app_assets.dart';
import 'package:subqdocs_bloc/core/constants/app_colors.dart';
import 'package:subqdocs_bloc/features/login/presentation/login_layout_constants.dart';

class LoginLandscapeHeroPanel extends StatelessWidget {
  const LoginLandscapeHeroPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topRight: Radius.circular(LoginLayoutConstants.landscapeHeroClipRadius),
        bottomRight: Radius.circular(
          LoginLayoutConstants.landscapeHeroClipRadius,
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          SvgPicture.asset(AppAssets.backgroundVisit, fit: BoxFit.cover),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: LoginLayoutConstants.landscapeCardHorizontalPadding,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(
                  LoginLayoutConstants.landscapeCardRadius,
                ),
                child: ColoredBox(
                  color: AppColors.white.withValues(alpha: 0.4),
                  child: Padding(
                    padding: const EdgeInsets.all(
                      LoginLayoutConstants.landscapeCardInnerPadding,
                    ),
                    child: Image.asset(
                      AppAssets.visitPage,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: LoginLayoutConstants.logoTopOffset,
            left: 0,
            right: 0,
            child: Center(
              child: SvgPicture.asset(
                AppAssets.subqdocsWhite,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
