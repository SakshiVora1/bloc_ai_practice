import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subqdocs_bloc/core/constants/app_colors.dart';
import 'package:subqdocs_bloc/core/routes/route_names.dart';
import 'package:subqdocs_bloc/screens/splash_screen/bloc/splash_screen_bloc.dart';
import 'package:subqdocs_bloc/screens/splash_screen/widgets/splash_screen_logo.dart';

class SplashScreenView extends StatelessWidget {
  const SplashScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashScreenBloc, SplashScreenState>(
      listenWhen: (previous, current) =>
          current is SplashScreenReadyForLogin &&
          previous is! SplashScreenReadyForLogin,
      listener: (context, state) {
        if (!context.mounted) {
          return;
        }
        Navigator.of(context).pushReplacementNamed(RouteNames.login);
      },
      child: Scaffold(
        backgroundColor: AppColors.splashBackground,
        body: const Center(
          child: SplashScreenLogo(),
        ),
      ),
    );
  }
}
