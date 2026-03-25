import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:subqdocs_bloc/core/constants/app_images.dart';
import 'package:subqdocs_bloc/core/constants/app_strings.dart';

class SplashScreenLogo extends StatelessWidget {
  const SplashScreenLogo({super.key});

  static const double _minSide = 120;
  static const double _maxSide = 280;
  static const double _fractionOfShortestSide = 0.45;

  @override
  Widget build(BuildContext context) {
    final shortest = MediaQuery.sizeOf(context).shortestSide;
    final side =
        (shortest * _fractionOfShortestSide).clamp(_minSide, _maxSide);

    return Semantics(
      label: AppStrings.splashLogoSemanticsLabel,
      child: SizedBox(
        width: side,
        height: side,
        child: SvgPicture.asset(
          AppImages.subqdocsWhite,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
