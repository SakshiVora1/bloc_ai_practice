import 'package:flutter/material.dart';
import 'package:subqdocs_bloc/core/constants/app_colors.dart';
import 'package:subqdocs_bloc/core/constants/app_fonts.dart';

/// Project-wide scaffold: app bar, drawer, and screen [body].
class CommonAppShell extends StatelessWidget {
  const CommonAppShell({
    super.key,
    required this.scaffoldKey,
    required this.title,
    required this.drawer,
    required this.body,
    this.appBarActions,
    this.onDrawerChanged,
  });

  final GlobalKey<ScaffoldState> scaffoldKey;
  final String title;
  final Widget drawer;
  final Widget body;
  final List<Widget>? appBarActions;
  final void Function(bool isOpen)? onDrawerChanged;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: AppColors.loginBackground,
      onDrawerChanged: onDrawerChanged,
      appBar: AppBar(
        backgroundColor: AppColors.shellAppBarBackground,
        foregroundColor: AppColors.primaryText,
        elevation: 0,
        centerTitle: false,
        title: Text(title, style: AppFonts.semiBold(18, AppColors.primaryText)),
        leading: IconButton(
          icon: const Icon(Icons.menu_rounded),
          onPressed: () => scaffoldKey.currentState?.openDrawer(),
          tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
        ),
        actions: appBarActions,
      ),
      drawer: drawer,
      body: body,
    );
  }
}
