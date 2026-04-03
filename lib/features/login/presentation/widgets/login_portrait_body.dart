import 'package:flutter/material.dart';
import 'package:subqdocs_bloc/features/login/presentation/login_layout_constants.dart';
import 'package:subqdocs_bloc/features/login/presentation/widgets/login_bottom_note.dart';
import 'package:subqdocs_bloc/features/login/presentation/widgets/login_form_body.dart';
import 'package:subqdocs_bloc/features/login/presentation/widgets/login_portrait_hero.dart';

class LoginPortraitBody extends StatelessWidget {
  const LoginPortraitBody({
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
    return SingleChildScrollView(
      padding: EdgeInsets.only(bottom: keyboardBottom),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: MediaQuery.sizeOf(context).height,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              children: <Widget>[
                const LoginPortraitHero(),
                const SizedBox(
                  height: LoginLayoutConstants.portraitFormTopSpacing,
                ),
                Center(
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
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(
                bottom: LoginLayoutConstants.bottomNotePadding,
              ),
              child: const LoginBottomNote(),
            ),
          ],
        ),
      ),
    );
  }
}
