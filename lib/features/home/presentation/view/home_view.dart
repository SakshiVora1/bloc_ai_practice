import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subqdocs_bloc/core/constants/app_colors.dart';
import 'package:subqdocs_bloc/core/enums/app_drawer_item.dart';
import 'package:subqdocs_bloc/features/home/presentation/bloc/home_screen_bloc.dart';
import 'package:subqdocs_bloc/features/home/presentation/widgets/home_body_content.dart';
import 'package:subqdocs_bloc/features/home/presentation/widgets/home_end_drawer.dart';
import 'package:subqdocs_bloc/widgets/common_app_drawer.dart';
import 'package:subqdocs_bloc/widgets/common_user_app_bar.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeScreenBloc, HomeScreenState>(
      listenWhen: (HomeScreenState p, HomeScreenState c) {
        return c is HomeScreenReady && c.signalOpenEndDrawer;
      },
      listener: (BuildContext context, HomeScreenState state) {
        final HomeScreenReady ready = state as HomeScreenReady;
        if (ready.signalOpenEndDrawer) {
          _scaffoldKey.currentState?.openEndDrawer();
          context.read<HomeScreenBloc>().add(
            const HomeScreenEndDrawerOpenConsumed(),
          );
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: AppColors.scaffoldWhite,
        appBar: CommonUserAppBar(),
        drawer: const CommonAppDrawer(selectedItem: AppDrawerItem.schedule),
        endDrawer: const HomeEndDrawer(),
        body: const HomeBodyContent(),
      ),
    );
  }
}
