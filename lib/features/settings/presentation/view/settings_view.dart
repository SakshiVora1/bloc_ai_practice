import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subqdocs_bloc/core/constants/app_colors.dart';
import 'package:subqdocs_bloc/core/enums/app_drawer_item.dart';
import 'package:subqdocs_bloc/core/models/session_user_info.dart';
import 'package:subqdocs_bloc/core/routing/app_router.dart';
import 'package:subqdocs_bloc/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:subqdocs_bloc/features/settings/presentation/widgets/settings_body.dart';
import 'package:subqdocs_bloc/widgets/common_app_drawer.dart';
import 'package:subqdocs_bloc/widgets/common_user_app_bar.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SettingsBloc, SettingsState>(
      listenWhen: (SettingsState previous, SettingsState current) {
        return current is SettingsLoggedOut;
      },
      listener: (BuildContext context, SettingsState state) {
        SessionUserInfo.clearCache();
        AppRouter.replaceWithLogin(context);
      },
      child: Scaffold(
        backgroundColor: AppColors.scaffoldWhite,
        appBar: const CommonUserAppBar(),
        drawer: const CommonAppDrawer(selectedItem: AppDrawerItem.settings),
        body: SafeArea(
          child: BlocBuilder<SettingsBloc, SettingsState>(
            buildWhen: (SettingsState previous, SettingsState current) {
              return previous.runtimeType != current.runtimeType;
            },
            builder: (BuildContext context, SettingsState state) {
              return switch (state) {
                SettingsInitial() || SettingsLoading() => const Center(
                  child: CircularProgressIndicator(),
                ),
                SettingsReady(:final user) => SettingsBody(
                  user: user,
                  isLoggingOut: false,
                ),
                SettingsLoggingOut(:final user) => SettingsBody(
                  user: user,
                  isLoggingOut: true,
                ),
                SettingsLoggedOut(:final user) => SettingsBody(
                  user: user,
                  isLoggingOut: false,
                ),
                SettingsLoadFailed(:final message) => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(message, textAlign: TextAlign.center),
                  ),
                ),
              };
            },
          ),
        ),
      ),
    );
  }
}
