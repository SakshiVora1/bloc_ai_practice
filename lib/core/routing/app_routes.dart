import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subqdocs_bloc/core/routing/medical_record_route_args.dart';
import 'package:subqdocs_bloc/core/routing/route_names.dart';
import 'package:subqdocs_bloc/features/home/presentation/bloc/home_screen_bloc.dart';
import 'package:subqdocs_bloc/features/home/data/home_repository_impl.dart';
import 'package:subqdocs_bloc/features/home/presentation/view/home_view.dart';
import 'package:subqdocs_bloc/features/login/data/login_repository_impl.dart';
import 'package:subqdocs_bloc/features/login/presentation/bloc/login_screen_bloc.dart';
import 'package:subqdocs_bloc/features/login/presentation/view/login_screen_view.dart';
import 'package:subqdocs_bloc/features/medical_record/presentation/view/medical_record_view.dart';
import 'package:subqdocs_bloc/features/patients/data/patients_repository_impl.dart';
import 'package:subqdocs_bloc/features/patients/presentation/bloc/patients_screen_bloc.dart';
import 'package:subqdocs_bloc/features/patients/presentation/view/patients_view.dart';
import 'package:subqdocs_bloc/features/settings/data/settings_repository_impl.dart';
import 'package:subqdocs_bloc/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:subqdocs_bloc/features/settings/presentation/view/settings_view.dart';
import 'package:subqdocs_bloc/features/splash/presentation/bloc/splash_screen_bloc.dart';
import 'package:subqdocs_bloc/features/splash/presentation/view/splash_screen_view.dart';

import 'package:subqdocs_bloc/features/patients/presentation/bloc/add_patient_bloc.dart';
import 'package:subqdocs_bloc/features/patients/presentation/view/add_patient_screen.dart';

abstract final class AppRoutes {
  AppRoutes._();

  static final Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{
    RouteNames.splashScreen: (BuildContext context) => BlocProvider(
      create: (_) => SplashScreenBloc(),
      child: const SplashScreenView(),
    ),
    RouteNames.login: (BuildContext context) => BlocProvider(
      create: (_) => LoginScreenBloc(loginRepository: LoginRepositoryImpl()),
      child: const LoginScreenView(),
    ),
    RouteNames.home: (BuildContext context) => BlocProvider(
      create: (_) => HomeScreenBloc(homeRepository: HomeRepositoryImpl()),
      child: const HomeView(),
    ),
    RouteNames.patients: (BuildContext context) => BlocProvider(
      create: (_) =>
          PatientsScreenBloc(patientsRepository: PatientsRepositoryImpl()),
      child: const PatientsView(),
    ),
    RouteNames.settings: (BuildContext context) => BlocProvider(
      create: (_) => SettingsBloc(settingsRepository: SettingsRepositoryImpl()),
      child: const SettingsView(),
    ),
    RouteNames.medicalRecord: (BuildContext context) {
      final Object? args = ModalRoute.of(context)?.settings.arguments;
      final int patientId = args is MedicalRecordRouteArgs ? args.patientId : 0;
      return MedicalRecordView(patientId: patientId);
    },
    RouteNames.addPatient: (BuildContext context) => BlocProvider(
      create: (_) => AddPatientBloc(
        patientsRepository: PatientsRepositoryImpl(),
        homeRepository: HomeRepositoryImpl(),
      ),
      child: const AddPatientScreen(),
    ),
  };
}
