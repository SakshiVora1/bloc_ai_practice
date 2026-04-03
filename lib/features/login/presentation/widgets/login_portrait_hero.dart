import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:subqdocs_bloc/core/constants/app_assets.dart';
import 'package:subqdocs_bloc/features/login/presentation/login_layout_constants.dart';

class LoginPortraitHero extends StatelessWidget {
  const LoginPortraitHero({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Image.asset(
          AppAssets.loginImage,
          width: double.infinity,
          fit: BoxFit.fitWidth,
        ),
        Positioned(
          top: LoginLayoutConstants.logoTopOffset,
          left: 0,
          right: 0,
          child: Center(
            child: SvgPicture.asset(AppAssets.subqdocsWhite, fit: BoxFit.cover),
          ),
        ),
      ],
    );
  }
}
