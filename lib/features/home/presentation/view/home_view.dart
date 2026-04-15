import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subqdocs_bloc/core/constants/app_colors.dart';
import 'package:subqdocs_bloc/core/enums/app_drawer_item.dart';
import 'package:subqdocs_bloc/features/home/presentation/bloc/home_screen_bloc.dart';
import 'package:subqdocs_bloc/features/home/presentation/widgets/home_body_content.dart';
import 'package:subqdocs_bloc/features/home/presentation/widgets/home_end_drawer.dart';
import 'package:subqdocs_bloc/core/services/app_toast.dart';
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
  void initState() {
    super.initState();
    context.read<HomeScreenBloc>().add(const HomeScreenStarted());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeScreenBloc, HomeScreenState>(
      listenWhen: (HomeScreenState p, HomeScreenState c) {
        if (c is! HomeScreenReady) return false;
        final HomeScreenReady prev = p is HomeScreenReady ? p : const HomeScreenReady(startDate: null, displayLabel: '');
        return c.signalOpenEndDrawer ||
            (c.errorMessage != null && c.errorMessage != prev.errorMessage) ||
            (c.successMessage != null && c.successMessage != prev.successMessage);
      },
      listener: (BuildContext context, HomeScreenState state) {
        final HomeScreenReady ready = state as HomeScreenReady;
        if (ready.signalOpenEndDrawer) {
          _scaffoldKey.currentState?.openEndDrawer();
          context.read<HomeScreenBloc>().add(
            const HomeScreenEndDrawerOpenConsumed(),
          );
        }
        if (ready.errorMessage != null) {
          AppToast.showError(context, ready.errorMessage!);
          context.read<HomeScreenBloc>().add(
            const HomeScreenErrorMessageConsumed(),
          );
        }
        if (ready.successMessage != null) {
          AppToast.showSuccess(context, ready.successMessage!);
          context.read<HomeScreenBloc>().add(
            const HomeScreenSuccessMessageConsumed(),
          );
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: AppColors.scaffoldWhite,
        appBar: const CommonUserAppBar(),
        drawer: const CommonAppDrawer(selectedItem: AppDrawerItem.schedule),
        endDrawer: const HomeEndDrawer(),
        onEndDrawerChanged: (bool isOpened) {
          if (!isOpened) {
            // Only apply filter logic when the filter drawer was active.
            // Closing the Schedule Visit drawer must not trigger filter
            // sync or overwrite the active date/filter state.
            final HomeScreenState current =
                context.read<HomeScreenBloc>().state;
            final bool isFilterDrawer = current is HomeScreenReady &&
                current.activeEndDrawer == HomeScreenEndDrawerKind.filter;
            if (isFilterDrawer) {
              context
                  .read<HomeScreenBloc>()
                  .add(const HomeScreenFilterPanelClosed());
            }
          }
        },
        body: const HomeBodyContent(),
      ),
    );
  }
}
