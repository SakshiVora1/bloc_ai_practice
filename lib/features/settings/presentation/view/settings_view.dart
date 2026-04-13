import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subqdocs_bloc/core/constants/app_colors.dart';
import 'package:subqdocs_bloc/core/enums/app_drawer_item.dart';
import 'package:subqdocs_bloc/core/models/session_user_info.dart';
import 'package:subqdocs_bloc/core/routing/app_router.dart';
import 'package:subqdocs_bloc/core/services/app_toast.dart';
import 'package:subqdocs_bloc/data/models/login_model.dart';
import 'package:subqdocs_bloc/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:subqdocs_bloc/features/settings/presentation/widgets/personal_settings_edit_panel.dart';
import 'package:subqdocs_bloc/features/settings/presentation/widgets/settings_body.dart';
import 'package:subqdocs_bloc/widgets/common_app_drawer.dart';
import 'package:subqdocs_bloc/widgets/common_user_app_bar.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    context.read<SettingsBloc>().add(const SettingsStarted());
  }

  SettingsBody _buildSettingsBody(User? user, {required bool isLoggingOut}) {
    return SettingsBody(user: user, isLoggingOut: isLoggingOut);
  }

  Widget _buildStateContent(SettingsState state) {
    return switch (state) {
      SettingsInitial() ||
      SettingsLoading() => const Center(child: CircularProgressIndicator()),
      SettingsReady(:final user) => _buildSettingsBody(
        user,
        isLoggingOut: false,
      ),
      SettingsLoggingOut(:final user) => _buildSettingsBody(
        user,
        isLoggingOut: true,
      ),
      SettingsDeletingAccount(:final user) => _buildSettingsBody(
        user,
        isLoggingOut: false,
      ),
      SettingsLoggedOut(:final user) => _buildSettingsBody(
        user,
        isLoggingOut: false,
      ),
      SettingsLoadFailed(:final message) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(message, textAlign: TextAlign.center),
        ),
      ),
      SettingsProfileSaveFailed(:final user) => _buildSettingsBody(
        user,
        isLoggingOut: false,
      ),
      SettingsDeleteAccountFailed(:final user) => _buildSettingsBody(
        user,
        isLoggingOut: false,
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SettingsBloc, SettingsState>(
      listenWhen: (SettingsState previous, SettingsState current) {
        return current is SettingsLoggedOut ||
            current is SettingsProfileSaveFailed ||
            current is SettingsDeleteAccountFailed ||
            (current is SettingsReady && current.shouldOpenEditPanel);
      },
      listener: (BuildContext context, SettingsState state) {
        if (state is SettingsLoggedOut) {
          SessionUserInfo.clearCache();
          AppRouter.replaceWithLogin(context);
          return;
        }
        if (state is SettingsProfileSaveFailed) {
          AppToast.showError(context, state.message);
          return;
        }
        if (state is SettingsDeleteAccountFailed) {
          AppToast.showError(context, state.message);
          return;
        }
        if (state is SettingsReady && state.shouldOpenEditPanel) {
          _scaffoldKey.currentState?.openEndDrawer();
          context.read<SettingsBloc>().add(
            const SettingsEditPanelOpenConsumed(),
          );
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: AppColors.scaffoldWhite,
        appBar: const CommonUserAppBar(),
        drawer: const CommonAppDrawer(selectedItem: AppDrawerItem.settings),
        endDrawerEnableOpenDragGesture: false,
        onEndDrawerChanged: (bool isOpen) {
          if (!isOpen) {
            context.read<SettingsBloc>().add(const SettingsEditPanelClosed());
          }
        },
        endDrawer: BlocBuilder<SettingsBloc, SettingsState>(
          buildWhen: (SettingsState previous, SettingsState current) =>
              current is SettingsReady,
          builder: (BuildContext context, SettingsState state) {
            if (state is! SettingsReady) {
              return const Drawer(child: SizedBox.shrink());
            }
            final User user = state.user;
            final String role = (user.role ?? '').trim().toLowerCase();
            final bool isDoctor = role == 'doctor';
            return Drawer(
              width: MediaQuery.sizeOf(context).width * 0.65,
              child: PersonalSettingsEditPanel(
                key: ValueKey<String>('${user.id}_${user.profileImage ?? ''}'),
                baseUser: user,
                isDoctor: isDoctor,
              ),
            );
          },
        ),
        body: SafeArea(
          child: BlocBuilder<SettingsBloc, SettingsState>(
            buildWhen: (SettingsState previous, SettingsState current) {
              if (previous.runtimeType != current.runtimeType) {
                return true;
              }
              if (previous is SettingsReady && current is SettingsReady) {
                return !identical(previous.user, current.user);
              }
              return false;
            },
            builder: (BuildContext context, SettingsState state) {
              return _buildStateContent(state);
            },
          ),
        ),
      ),
    );
  }
}
