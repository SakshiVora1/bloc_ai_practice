import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subqdocs_bloc/core/constants/app_colors.dart';
import 'package:subqdocs_bloc/core/constants/app_strings.dart';
import 'package:subqdocs_bloc/core/services/app_toast.dart';
import 'package:subqdocs_bloc/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:subqdocs_bloc/widgets/common_button.dart';

class SettingsActionRow extends StatelessWidget {
  const SettingsActionRow({super.key, required this.isLoggingOut});

  final bool isLoggingOut;

  static const double _logoutWidth = 100;
  static const double _deleteWidth = 200;
  static const double _gap = 16;

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
          onPressed: isLoggingOut
              ? null
              : () => context.read<SettingsBloc>().add(
                  const SettingsLogoutPressed(),
                ),
          isLoading: isLoggingOut,
        );

        final Widget deleteAccount = CommonButton(
          label: AppStrings.settingsDeleteAccountButton,
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
          backgroundColor: AppColors.white,
          textColor: AppColors.red,
          borderColor: AppColors.red,
          onPressed: () => AppToast.showInfo(
            context,
            AppStrings.settingsDeleteNotImplemented,
          ),
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
