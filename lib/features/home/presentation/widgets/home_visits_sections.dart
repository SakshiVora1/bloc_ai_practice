import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subqdocs_bloc/core/constants/app_colors.dart';
import 'package:subqdocs_bloc/core/constants/app_fonts.dart';
import 'package:subqdocs_bloc/core/constants/app_strings.dart';
import 'package:subqdocs_bloc/core/models/home_models.dart';
import 'package:subqdocs_bloc/features/home/domain/home_visit_list_utils.dart';
import 'package:subqdocs_bloc/features/home/presentation/bloc/home_screen_bloc.dart';
import 'package:subqdocs_bloc/features/home/presentation/widgets/home_section_empty_state.dart';
import 'package:subqdocs_bloc/features/home/presentation/widgets/home_section_header_delegate.dart';
import 'package:subqdocs_bloc/features/home/presentation/widgets/home_visit_marker.dart';
import 'package:subqdocs_bloc/features/home/presentation/widgets/home_visit_row.dart';
import 'package:subqdocs_bloc/features/home/presentation/widgets/home_visits_bottom_section_item.dart';

class HomeVisitsSections extends StatefulWidget {
  const HomeVisitsSections({super.key});

  @override
  State<HomeVisitsSections> createState() => _HomeVisitsSectionsState();
}

class _HomeVisitsSectionsState extends State<HomeVisitsSections> {
  static const Duration _scrollDuration = Duration(milliseconds: 260);
  static const Curve _scrollCurve = Curves.easeInOut;

  late final ScrollController _scrollController;
  final GlobalKey _viewportKey = GlobalKey();

  final GlobalKey _currentHeaderKey = GlobalKey();
  final GlobalKey _upcomingHeaderKey = GlobalKey();
  final GlobalKey _completedHeaderKey = GlobalKey();

  final GlobalKey _currentAnchorKey = GlobalKey();
  final GlobalKey _upcomingAnchorKey = GlobalKey();
  final GlobalKey _completedAnchorKey = GlobalKey();

  bool _showUpcomingBottom = false;
  bool _showCompletedBottom = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_updateBottomHeaders);
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateBottomHeaders());
  }

  @override
  void dispose() {
    _scrollController.removeListener(_updateBottomHeaders);
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _scrollToHeader(GlobalKey headerKey) async {
    final BuildContext? viewportContext = _viewportKey.currentContext;
    final BuildContext? headerContext = headerKey.currentContext;
    if (viewportContext == null || headerContext == null) {
      return;
    }
    final RenderBox? viewportBox =
        viewportContext.findRenderObject() as RenderBox?;
    final RenderBox? headerBox = headerContext.findRenderObject() as RenderBox?;
    if (viewportBox == null || headerBox == null) {
      return;
    }

    final Offset localTopLeft = viewportBox.globalToLocal(
      headerBox.localToGlobal(Offset.zero),
    );
    final double targetOffset = (_scrollController.offset + localTopLeft.dy)
        .clamp(0.0, _scrollController.position.maxScrollExtent);

    await _scrollController.animateTo(
      targetOffset,
      duration: _scrollDuration,
      curve: _scrollCurve,
    );
    _updateBottomHeaders();
  }

  Future<void> _scrollToAnchor(
    GlobalKey anchorKey, {
    double topInset = 0,
  }) async {
    final BuildContext? viewportContext = _viewportKey.currentContext;
    final BuildContext? anchorContext = anchorKey.currentContext;
    if (viewportContext == null || anchorContext == null) {
      return;
    }
    final RenderBox? viewportBox =
        viewportContext.findRenderObject() as RenderBox?;
    final RenderBox? anchorBox = anchorContext.findRenderObject() as RenderBox?;
    if (viewportBox == null || anchorBox == null) {
      return;
    }

    final Offset localTopLeft = viewportBox.globalToLocal(
      anchorBox.localToGlobal(Offset.zero),
    );
    final double targetOffset =
        (_scrollController.offset + localTopLeft.dy - topInset).clamp(
          0.0,
          _scrollController.position.maxScrollExtent,
        );

    await _scrollController.animateTo(
      targetOffset,
      duration: _scrollDuration,
      curve: _scrollCurve,
    );
    _updateBottomHeaders();
  }

  bool _isHeaderVisible(GlobalKey headerKey) {
    final BuildContext? viewportContext = _viewportKey.currentContext;
    final BuildContext? headerContext = headerKey.currentContext;
    if (viewportContext == null || headerContext == null) {
      return false;
    }
    final RenderBox? viewportBox =
        viewportContext.findRenderObject() as RenderBox?;
    final RenderBox? headerBox = headerContext.findRenderObject() as RenderBox?;
    if (viewportBox == null || headerBox == null) {
      return false;
    }

    final Offset topLeft = viewportBox.globalToLocal(
      headerBox.localToGlobal(Offset.zero),
    );
    final double top = topLeft.dy;
    final double bottom = top + headerBox.size.height;
    return bottom > 0 && top < viewportBox.size.height;
  }

  void _updateBottomHeaders() {
    if (!mounted) {
      return;
    }
    final bool nextShowUpcoming = !_isHeaderVisible(_upcomingHeaderKey);
    final bool nextShowCompleted = !_isHeaderVisible(_completedHeaderKey);
    if (nextShowUpcoming != _showUpcomingBottom ||
        nextShowCompleted != _showCompletedBottom) {
      setState(() {
        _showUpcomingBottom = nextShowUpcoming;
        _showCompletedBottom = nextShowCompleted;
      });
    }
  }

  bool _isSectionAnchorVisible(GlobalKey anchorKey) {
    final BuildContext? viewportContext = _viewportKey.currentContext;
    final BuildContext? anchorContext = anchorKey.currentContext;
    if (viewportContext == null || anchorContext == null) {
      return false;
    }
    final RenderBox? viewportBox =
        viewportContext.findRenderObject() as RenderBox?;
    final RenderBox? anchorBox = anchorContext.findRenderObject() as RenderBox?;
    if (viewportBox == null || anchorBox == null) {
      return false;
    }
    final Offset topLeft = viewportBox.globalToLocal(
      anchorBox.localToGlobal(Offset.zero),
    );
    final double top = topLeft.dy;
    final double bottom = top + anchorBox.size.height;
    return bottom > 32 && top < viewportBox.size.height;
  }

  Future<void> _maybeScrollToSection(
    GlobalKey anchorKey,
    GlobalKey headerKey,
  ) async {
    if (_isSectionAnchorVisible(anchorKey)) {
      return;
    }
    await _scrollToHeader(headerKey);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeScreenBloc, HomeScreenState>(
      buildWhen: (HomeScreenState previous, HomeScreenState current) {
        if (previous is! HomeScreenReady || current is! HomeScreenReady) {
          return false;
        }
        return previous.searchQuery != current.searchQuery;
      },
      builder: (BuildContext context, HomeScreenState state) {
        final String query = state is HomeScreenReady ? state.searchQuery : '';
        final List<Map<String, dynamic>> currentVisits = filterHomeVisits(
          extractHomeVisits(HomeModels.current),
          query,
        );
        final List<Map<String, dynamic>> upcomingVisits = filterHomeVisits(
          extractHomeVisits(HomeModels.upcoming),
          query,
        );
        final List<Map<String, dynamic>> completedVisits = filterHomeVisits(
          extractHomeVisits(HomeModels.completed),
          query,
        );

        final List<HomeVisitsBottomSectionItem>
        bottomItems = <HomeVisitsBottomSectionItem>[
          if (_showUpcomingBottom)
            HomeVisitsBottomSectionItem(
              label:
                  '${AppStrings.homeUpcomingLabel} (${upcomingVisits.length})',
              onTap: () => _scrollToHeader(_upcomingHeaderKey),
            ),
          if (_showCompletedBottom)
            HomeVisitsBottomSectionItem(
              label:
                  '${AppStrings.homeCompletedLabel} (${completedVisits.length})',
              onTap: () => _scrollToHeader(_completedHeaderKey),
            ),
        ];
        final double bottomBarHeight = bottomItems.isEmpty
            ? 0
            : bottomItems.length == 1
            ? 32
            : 64;

        return Container(
          key: _viewportKey,
          decoration: BoxDecoration(
            color: AppColors.homeSectionBackground,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Stack(
            children: <Widget>[
              CustomScrollView(
                controller: _scrollController,
                slivers: <Widget>[
                  ..._buildSectionSlivers(
                    title: AppStrings.homeCurrentLabel,
                    visits: currentVisits,
                    markerType: HomeVisitMarkerType.active,
                    sectionHeaderKey: _currentHeaderKey,
                    sectionAnchorKey: _currentAnchorKey,
                    onHeaderTap: () async {
                      await _scrollController.animateTo(
                        0,
                        duration: _scrollDuration,
                        curve: _scrollCurve,
                      );
                      _updateBottomHeaders();
                    },
                  ),
                  ..._buildSectionSlivers(
                    title: AppStrings.homeUpcomingLabel,
                    visits: upcomingVisits,
                    markerType: HomeVisitMarkerType.upcoming,
                    addTopDivider: true,
                    sectionHeaderKey: _upcomingHeaderKey,
                    sectionAnchorKey: _upcomingAnchorKey,
                    onHeaderTap: () =>
                        _scrollToAnchor(_upcomingAnchorKey, topInset: 64),
                  ),
                  ..._buildSectionSlivers(
                    title: AppStrings.homeCompletedLabel,
                    visits: completedVisits,
                    markerType: HomeVisitMarkerType.completed,
                    addTopDivider: true,
                    sectionHeaderKey: _completedHeaderKey,
                    sectionAnchorKey: _completedAnchorKey,
                    onHeaderTap: () => _maybeScrollToSection(
                      _completedAnchorKey,
                      _completedHeaderKey,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(height: bottomBarHeight + 4),
                  ),
                ],
              ),
              if (bottomItems.isNotEmpty)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    height: bottomBarHeight,
                    color: AppColors.homeSectionHeaderBackground,
                    child: Column(
                      children: <Widget>[
                        for (
                          int i = 0;
                          i < bottomItems.length;
                          i++
                        ) ...<Widget>[
                          SizedBox(
                            height: 31,
                            child: InkWell(
                              onTap: bottomItems[i].onTap,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  child: Text(
                                    bottomItems[i].label,
                                    style: AppFonts.medium(
                                      12,
                                      AppColors.scheduleVisitAccent,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          if (i < bottomItems.length - 1)
                            const Divider(
                              height: 1,
                              color: AppColors.homeSectionDivider,
                            ),
                        ],
                      ],
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _buildSectionSlivers({
    required String title,
    required List<Map<String, dynamic>> visits,
    required HomeVisitMarkerType markerType,
    required GlobalKey sectionHeaderKey,
    required GlobalKey sectionAnchorKey,
    required VoidCallback onHeaderTap,
    bool addTopDivider = false,
  }) {
    return <Widget>[
      if (addTopDivider)
        const SliverToBoxAdapter(
          child: Divider(height: 1, color: AppColors.homeSectionDivider),
        ),
      SliverPersistentHeader(
        pinned: true,
        delegate: HomeSectionHeaderDelegate(
          headerKey: sectionHeaderKey,
          title: title,
          count: visits.length,
          height: 32,
          onTap: onHeaderTap,
        ),
      ),
      SliverToBoxAdapter(child: SizedBox(height: 1, key: sectionAnchorKey)),
      if (visits.isEmpty)
        const SliverToBoxAdapter(child: HomeSectionEmptyState())
      else
        SliverList.builder(
          itemCount: visits.length,
          itemBuilder: (BuildContext context, int index) {
            return HomeVisitRow(visit: visits[index], markerType: markerType);
          },
        ),
    ];
  }
}
