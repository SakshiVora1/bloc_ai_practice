import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';
import 'package:subqdocs_bloc/core/config/app_config.dart';
import 'package:subqdocs_bloc/core/theme/app_theme.dart';
import 'package:subqdocs_bloc/core/models/session_user_info.dart';
import 'package:subqdocs_bloc/core/routing/app_routes.dart';
import 'package:subqdocs_bloc/core/routing/root_navigator_key.dart';
import 'package:subqdocs_bloc/core/routing/route_names.dart';
import 'package:subqdocs_bloc/core/services/app_preferences.dart';

import 'core/config/environment.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppConfig.init(
    env: Environment.stage,
  ); // Change to .prod / .stage / .ngrok as needed
  await AppPreferences.instance.initialize();
  await SessionUserInfo.hydrate();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ToastificationWrapper(
      child: MaterialApp(
        title: 'SubQ Docs',
        navigatorKey: RootNavigatorKey.instance,
        theme: AppTheme.light(),
        debugShowCheckedModeBanner: false,
        initialRoute: RouteNames.splashScreen,
        routes: AppRoutes.routes,
      ),
    );
  }
}
