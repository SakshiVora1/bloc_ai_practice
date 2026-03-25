import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subqdocs_bloc/core/routes/route_names.dart';
import 'package:subqdocs_bloc/screens/splash_screen/bloc/splash_screen_bloc.dart';
import 'package:subqdocs_bloc/screens/splash_screen/view/splash_screen_view.dart';

abstract final class AppRoutes {
  AppRoutes._();

  static final Map<String, WidgetBuilder> routes = {
    RouteNames.splashScreen: (context) => BlocProvider(
          create: (_) {
            final bloc = SplashScreenBloc();
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!bloc.isClosed) {
                bloc.add(const SplashScreenStarted());
              }
            });
            return bloc;
          },
          child: const SplashScreenView(),
        ),
  };
}
