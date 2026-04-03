import 'package:flutter/material.dart';
import 'package:subqdocs_bloc/features/login/presentation/login_layout_constants.dart';
import 'package:subqdocs_bloc/features/login/presentation/widgets/login_bottom_note.dart';
import 'package:subqdocs_bloc/features/login/presentation/widgets/login_form_body.dart';
import 'package:subqdocs_bloc/features/login/presentation/widgets/login_landscape_hero_panel.dart';

class LoginLandscapeBody extends StatelessWidget {
  const LoginLandscapeBody({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.emailFocus,
    required this.passwordFocus,
    required this.onSubmit,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final FocusNode emailFocus;
  final FocusNode passwordFocus;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final double keyboardBottom = MediaQuery.viewInsetsOf(context).bottom;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const Expanded(child: LoginLandscapeHeroPanel()),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    return SingleChildScrollView(
                      padding: EdgeInsets.fromLTRB(
                        LoginLayoutConstants.landscapeHorizontalPadding,
                        LoginLayoutConstants.landscapeScrollTopPadding,
                        LoginLayoutConstants.landscapeHorizontalPadding,
                        LoginLayoutConstants.landscapeScrollTopPadding +
                            keyboardBottom,
                      ),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight,
                        ),
                        child: Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(
                              maxWidth: LoginLayoutConstants.formMaxWidth,
                            ),
                            child: Form(
                              key: formKey,
                              child: LoginFormBody(
                                emailController: emailController,
                                passwordController: passwordController,
                                emailFocus: emailFocus,
                                passwordFocus: passwordFocus,
                                onSubmit: onSubmit,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                  LoginLayoutConstants.landscapeHorizontalPadding,
                  0,
                  LoginLayoutConstants.landscapeHorizontalPadding,
                  LoginLayoutConstants.bottomNotePadding + keyboardBottom,
                ),
                child: const LoginBottomNote(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
