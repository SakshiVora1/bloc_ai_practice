import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subqdocs_bloc/core/constants/app_colors.dart';
import 'package:subqdocs_bloc/core/constants/app_strings.dart';
import 'package:subqdocs_bloc/core/services/app_toast.dart';
import 'package:subqdocs_bloc/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:subqdocs_bloc/features/settings/presentation/widgets/common_dialog.dart';
import 'package:subqdocs_bloc/widgets/common_button.dart';

class SettingsActionRow extends StatelessWidget {
  const SettingsActionRow({super.key, required this.isLoggingOut});

  final bool isLoggingOut;

  static const double _logoutWidth = 100;
  static const double _deleteWidth = 200;
  static const double _gap = 16;

  int? _resolveUserId(SettingsState state) {
    return switch (state) {
      SettingsReady(:final user) => user.id,
      SettingsDeletingAccount(:final user) => user.id,
      SettingsDeleteAccountFailed(:final user) => user.id,
      SettingsLoggingOut(:final user) => user?.id,
      SettingsLoggedOut(:final user) => user?.id,
      _ => null,
    };
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return CommonDialog(
          title: AppStrings.settingsConfirmDialogTitle,
          description: AppStrings.settingsLogoutConfirmDescription,
          confirmLabel: AppStrings.settingsDialogConfirm,
          onConfirm: () {
            context.read<SettingsBloc>().add(const SettingsLogoutPressed());
          },
        );
      },
    );
  }

  void _showDeleteDialog(BuildContext context) {
    final SettingsBloc bloc = context.read<SettingsBloc>();
    final int? userId = _resolveUserId(bloc.state);
    if (userId == null) {
      AppToast.showError(context, AppStrings.settingsLoadUserFailure);
      return;
    }
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return BlocProvider<SettingsBloc>.value(
          value: bloc,
          child: BlocBuilder<SettingsBloc, SettingsState>(
            buildWhen: (SettingsState previous, SettingsState current) {
              final bool prevDeleting = previous is SettingsDeletingAccount;
              final bool currDeleting = current is SettingsDeletingAccount;
              return prevDeleting != currDeleting;
            },
            builder: (BuildContext context, SettingsState state) {
              final bool isDeleting = state is SettingsDeletingAccount;
              return PopScope(
                canPop: !isDeleting,
                child: CommonDialog(
                  title: AppStrings.settingsDeleteDialogTitle,
                  description: AppStrings.settingsDeleteConfirmDescription,
                  confirmLabel: AppStrings.settingsDialogDelete,
                  isLoading: isDeleting,
                  autoCloseOnConfirm: false,
                  onConfirm: () {
                    context.read<SettingsBloc>().add(
                      SettingsDeleteAccountPressed(userId: userId),
                    );
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool stackButtons =
            constraints.maxWidth < (_logoutWidth + _gap + _deleteWidth);

        final Widget logout = CommonButton(
          label: AppStrings.settingsLogoutButton,
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
          backgroundColor: AppColors.red,
          textColor: AppColors.white,
          onPressed: isLoggingOut ? null : () => _showLogoutDialog(context),
          isLoading: isLoggingOut,
        );

        final Widget deleteAccount = CommonButton(
          label: AppStrings.settingsDeleteAccountButton,
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
          backgroundColor: AppColors.white,
          textColor: AppColors.red,
          borderColor: AppColors.red,
          onPressed: isLoggingOut ? null : () => _showDeleteDialog(context),
        );

        if (stackButtons) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              logout,
              const SizedBox(height: 12),
              deleteAccount,
            ],
          );
        }

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(width: _logoutWidth, child: logout),
            const SizedBox(width: _gap),
            SizedBox(width: _deleteWidth, child: deleteAccount),
          ],
        );
      },
    );
  }
}
