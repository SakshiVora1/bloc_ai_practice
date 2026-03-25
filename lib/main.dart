import 'package:flutter/material.dart';
import 'package:subqdocs_bloc/core/config/app_config.dart';
import 'package:subqdocs_bloc/core/config/environment.dart';
import 'package:subqdocs_bloc/core/constants/app_colors.dart';
import 'package:subqdocs_bloc/core/routes/app_routes.dart';
import 'package:subqdocs_bloc/core/routes/route_names.dart';
import 'package:subqdocs_bloc/core/services/app_preferences.dart';
import 'package:subqdocs_bloc/core/services/device_detection_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppConfig.init(env: Environment.dev); // Change to .prod / .stage / .ngrok as needed
  await AppPreferences.instance.initialize();
  await DeviceDetectionService.instance.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SubQ Docs',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.splashBackground,
        ),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: RouteNames.splashScreen,
      routes: AppRoutes.routes,
    );
  }
}
