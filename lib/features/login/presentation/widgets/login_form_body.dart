import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subqdocs_bloc/core/constants/app_colors.dart';
import 'package:subqdocs_bloc/core/constants/app_fonts.dart';
import 'package:subqdocs_bloc/core/constants/app_strings.dart';
import 'package:subqdocs_bloc/core/widgets/common_text_form_field.dart';
import 'package:subqdocs_bloc/features/login/presentation/bloc/login_screen_bloc.dart';
import 'package:subqdocs_bloc/features/login/presentation/login_screen_validation.dart';

class LoginFormBody extends StatelessWidget {
  const LoginFormBody({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.emailFocus,
    required this.passwordFocus,
    required this.onSubmit,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;
  final FocusNode emailFocus;
  final FocusNode passwordFocus;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(
          AppStrings.loginTitle,
          style: AppFonts.semiBold(24, AppColors.splashBackground),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          AppStrings.loginSubtitle,
          style: AppFonts.regular(16, AppColors.primaryText),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        Text(
          AppStrings.emailAddressLabel,
          style: AppFonts.regular(12, AppColors.primaryText),
        ),
        const SizedBox(height: 8),
        CommonTextFormField(
          controller: emailController,
          focusNode: emailFocus,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          fillColor: AppColors.white,
          hintText: AppStrings.loginEmailHint,
          validator: validateLoginFormEmail,
        ),
        const SizedBox(height: 16),
        Text(
          AppStrings.passwordLabel,
          style: AppFonts.regular(12, AppColors.primaryText),
        ),
        const SizedBox(height: 8),
        BlocBuilder<LoginScreenBloc, LoginScreenState>(
          buildWhen: (LoginScreenState p, LoginScreenState c) =>
              p.obscurePassword != c.obscurePassword,
          builder: (BuildContext context, LoginScreenState state) {
            return CommonTextFormField(
              controller: passwordController,
              focusNode: passwordFocus,
              obscureText: state.obscurePassword,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => onSubmit(),
              fillColor: AppColors.white,
              hintText: AppStrings.loginPasswordHint,
              suffixIcon: IconButton(
                icon: Icon(
                  state.obscurePassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: AppColors.secondaryText,
                ),
                onPressed: () => context.read<LoginScreenBloc>().add(
                  const LoginPasswordVisibilityToggled(),
                ),
              ),
              validator: validateLoginFormPassword,
            );
          },
        ),
        const SizedBox(height: 12),
        BlocBuilder<LoginScreenBloc, LoginScreenState>(
          buildWhen: (LoginScreenState p, LoginScreenState c) =>
              p.rememberMe != c.rememberMe,
          builder: (BuildContext context, LoginScreenState state) {
            return Row(
              children: <Widget>[
                Checkbox(
                  value: state.rememberMe,
                  onChanged: (bool? value) {
                    context.read<LoginScreenBloc>().add(
                      LoginRememberMeChanged(value ?? false),
                    );
                  },
                  visualDensity: VisualDensity.compact,
                ),
                Text(
                  AppStrings.rememberMe,
                  style: AppFonts.regular(14, AppColors.primaryText),
                ),
                const Spacer(),
                Text(
                  AppStrings.forgotPassword,
                  style: AppFonts.regular(14, AppColors.splashBackground),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 20),
        BlocBuilder<LoginScreenBloc, LoginScreenState>(
          buildWhen: (LoginScreenState p, LoginScreenState c) =>
              p.isSubmitting != c.isSubmitting ||
              p.errorMessage != c.errorMessage,
          builder: (BuildContext context, LoginScreenState state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                if (state.errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(
                      state.errorMessage!,
                      style: AppFonts.regular(14, AppColors.error),
                    ),
                  ),
                SizedBox(
                  height: 40,
                  child: FilledButton(
                    onPressed: state.isSubmitting ? null : onSubmit,
                    child: state.isSubmitting
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.white,
                            ),
                          )
                        : Text(
                            AppStrings.loginButton,
                            style: AppFonts.medium(14, AppColors.white),
                          ),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
