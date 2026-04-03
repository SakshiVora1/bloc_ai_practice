import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subqdocs_bloc/core/constants/app_colors.dart';
import 'package:subqdocs_bloc/core/models/session_user_info.dart';
import 'package:subqdocs_bloc/core/routing/app_router.dart';
import 'package:subqdocs_bloc/features/login/presentation/bloc/login_screen_bloc.dart';
import 'package:subqdocs_bloc/features/login/presentation/login_field_focus_scroll.dart';
import 'package:subqdocs_bloc/features/login/presentation/widgets/login_landscape_body.dart';
import 'package:subqdocs_bloc/features/login/presentation/widgets/login_portrait_body.dart';

class LoginScreenView extends StatefulWidget {
  const LoginScreenView({super.key});

  @override
  State<LoginScreenView> createState() => _LoginScreenViewState();
}

class _LoginScreenViewState extends State<LoginScreenView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _emailFocus.addListener(_onLoginFieldFocus);
    _passwordFocus.addListener(_onLoginFieldFocus);
  }

  void _onLoginFieldFocus() {
    scheduleLoginFieldVisibleIfFocused(
      emailFocus: _emailFocus,
      passwordFocus: _passwordFocus,
    );
  }

  @override
  void dispose() {
    _emailFocus.removeListener(_onLoginFieldFocus);
    _passwordFocus.removeListener(_onLoginFieldFocus);
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    final FormState? form = _formKey.currentState;
    if (form == null || !form.validate()) {
      return;
    }
    context.read<LoginScreenBloc>().add(
      LoginSubmitted(
        email: _emailController.text,
        password: _passwordController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool landscape =
        MediaQuery.orientationOf(context) == Orientation.landscape;

    return BlocListener<LoginScreenBloc, LoginScreenState>(
      listenWhen: (LoginScreenState p, LoginScreenState c) => c.didSucceed,
      listener: (BuildContext context, LoginScreenState state) async {
        await SessionUserInfo.hydrate();
        if (context.mounted) {
          AppRouter.replaceWithHome(context);
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: AppColors.white,
        body: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          behavior: HitTestBehavior.translucent,
          child: landscape
              ? LoginLandscapeBody(
                  formKey: _formKey,
                  emailController: _emailController,
                  passwordController: _passwordController,
                  emailFocus: _emailFocus,
                  passwordFocus: _passwordFocus,
                  onSubmit: _submit,
                )
              : LoginPortraitBody(
                  formKey: _formKey,
                  emailController: _emailController,
                  passwordController: _passwordController,
                  emailFocus: _emailFocus,
                  passwordFocus: _passwordFocus,
                  onSubmit: _submit,
                ),
        ),
      ),
    );
  }
}
