import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:subqdocs_bloc/core/constants/app_assets.dart';
import 'package:subqdocs_bloc/core/constants/app_colors.dart';
import 'package:subqdocs_bloc/core/constants/device_breakpoints.dart';
import 'package:subqdocs_bloc/core/models/session_user_info.dart';
import 'package:subqdocs_bloc/core/routing/app_router.dart';
import 'package:subqdocs_bloc/features/splash/presentation/bloc/splash_screen_bloc.dart';

class SplashScreenView extends StatefulWidget {
  const SplashScreenView({super.key});

  @override
  State<SplashScreenView> createState() => _SplashScreenViewState();
}

class _SplashScreenViewState extends State<SplashScreenView> {
  static const Duration _minimumSplashDuration = Duration(milliseconds: 1500);

  final Stopwatch _splashVisibleStopwatch = Stopwatch()..start();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      context.read<SplashScreenBloc>().add(const SplashStarted());
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    final bool isMobileOrIphone = size.shortestSide < DeviceBreakpoints.mobile;
    final double logoWidthFactor = isMobileOrIphone ? 0.70 : 0.45;

    return BlocListener<SplashScreenBloc, SplashScreenState>(
      listenWhen: (SplashScreenState p, SplashScreenState c) =>
          c is SplashComplete,
      listener: (BuildContext context, SplashScreenState state) async {
        final SplashComplete done = state as SplashComplete;
        await SessionUserInfo.hydrate();
        if (!context.mounted) {
          return;
        }
        final Duration elapsed = _splashVisibleStopwatch.elapsed;
        if (elapsed < _minimumSplashDuration) {
          await Future<void>.delayed(_minimumSplashDuration - elapsed);
        }
        if (!context.mounted) {
          return;
        }
        if (done.hasSession) {
          AppRouter.goHome(context);
        } else {
          AppRouter.replaceWithLogin(context);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.splashBackground,
        body: Center(
          child: SvgPicture.asset(
            width: size.width * logoWidthFactor,
            AppAssets.subqdocsWhite,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
