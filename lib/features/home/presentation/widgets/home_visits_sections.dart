import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:subqdocs_bloc/core/constants/app_colors.dart';
import 'package:subqdocs_bloc/core/constants/app_fonts.dart';
import 'package:subqdocs_bloc/core/constants/app_strings.dart';
import 'package:subqdocs_bloc/data/models/visit_model.dart';
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
    _scrollController = ScrollController()..addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateBottomHeaders());
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    _updateBottomHeaders();
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

  bool _isHeaderBelowViewport(GlobalKey headerKey) {
    final BuildContext? viewportContext = _viewportKey.currentContext;
    final BuildContext? headerContext = headerKey.currentContext;
    
    if (viewportContext == null) return false;
    
    if (headerContext == null) {
      // If the header is not in the tree, we need to decide if it's below or above.
      // For "Upcoming" and "Recorded" labels:
      // If we are at the top of the scroll view (offset == 0), they are almost certainly below.
      if (!_scrollController.hasClients) return true;
      if (_scrollController.offset <= 0) return true;
      
      // If they are missing but we've scrolled far, they might be above.
      // But for the last sections, they stay "below" for a long time.
      // A safer bet: if we can't find them, and we are not near the bottom, they are below.
      return _scrollController.offset < _scrollController.position.maxScrollExtent * 0.8;
    }

    final RenderBox? viewportBox =
        viewportContext.findRenderObject() as RenderBox?;
    final RenderBox? headerBox = headerContext.findRenderObject() as RenderBox?;
    
    if (viewportBox == null || headerBox == null) return false;

    final Offset topLeft = viewportBox.globalToLocal(
      headerBox.localToGlobal(Offset.zero),
    );
    final double top = topLeft.dy;
    
    // Section is below if its top is greater than viewport height minus a small threshold
    // to ensure the label disappears exactly when the header starts entering.
    return top >= viewportBox.size.height - 2;
  }

  void _updateBottomHeaders() {
    if (!mounted) {
      return;
    }
    // Only show bottom label if the section is truly below the viewport
    final bool nextShowUpcoming = _isHeaderBelowViewport(_upcomingHeaderKey);
    final bool nextShowCompleted = _isHeaderBelowViewport(_completedHeaderKey);
    
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
    return BlocConsumer<HomeScreenBloc, HomeScreenState>(
      listenWhen: (HomeScreenState previous, HomeScreenState current) {
        if (previous is! HomeScreenReady || current is! HomeScreenReady) {
          return true;
        }
        return previous.currentVisits != current.currentVisits ||
            previous.upcomingVisits != current.upcomingVisits ||
            previous.recordedVisits != current.recordedVisits ||
            previous.filteredCountCurrent != current.filteredCountCurrent ||
            previous.filteredCountUpcoming != current.filteredCountUpcoming ||
            previous.filteredCountRecorded != current.filteredCountRecorded;
      },
      listener: (BuildContext context, HomeScreenState state) {
        // When data arrives or changes, re-evaluate bottom bar labels visibility
        WidgetsBinding.instance.addPostFrameCallback((_) => _updateBottomHeaders());
      },
      buildWhen: (HomeScreenState previous, HomeScreenState current) {
        if (previous is! HomeScreenReady || current is! HomeScreenReady) {
          return true;
        }
        return previous.searchQuery != current.searchQuery ||
            previous.currentVisits != current.currentVisits ||
            previous.upcomingVisits != current.upcomingVisits ||
            previous.recordedVisits != current.recordedVisits ||
            previous.filteredCountCurrent != current.filteredCountCurrent ||
            previous.filteredCountUpcoming != current.filteredCountUpcoming ||
            previous.filteredCountRecorded != current.filteredCountRecorded ||
            previous.isLoadingVisits != current.isLoadingVisits ||
            previous.isFetchingMoreCurrent != current.isFetchingMoreCurrent ||
            previous.isFetchingMoreUpcoming != current.isFetchingMoreUpcoming ||
            previous.isFetchingMoreRecorded != current.isFetchingMoreRecorded;
      },
      builder: (BuildContext context, HomeScreenState state) {
        if (state is! HomeScreenReady) {
          return const SizedBox.shrink();
        }

        final HomeScreenReady ready = state;
        final String query = ready.searchQuery;
        
        // Filter local lists by search query
        final List<VisitModel> currentVisits = filterHomeVisitModels(ready.currentVisits, query);
        final List<VisitModel> upcomingVisits = filterHomeVisitModels(ready.upcomingVisits, query);
        final List<VisitModel> recordedVisits = filterHomeVisitModels(ready.recordedVisits, query);

        final List<HomeVisitsBottomSectionItem> bottomItems = <HomeVisitsBottomSectionItem>[
          if (_showUpcomingBottom)
            HomeVisitsBottomSectionItem(
              label: '${AppStrings.homeUpcomingLabel} (${ready.filteredCountUpcoming})',
              onTap: () => _scrollToHeader(_upcomingHeaderKey),
            ),
          if (_showCompletedBottom)
            HomeVisitsBottomSectionItem(
              label: '${AppStrings.homeCompletedLabel} (${ready.filteredCountRecorded})',
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
                    count: ready.filteredCountCurrent,
                    isLoading: ready.isLoadingVisits && currentVisits.isEmpty,
                    isFetchingMore: ready.isFetchingMoreCurrent,
                    onPaginationTrigger: () => context.read<HomeScreenBloc>().add(
                      const HomeScreenCurrentVisitsRequested(isNextPage: true),
                    ),
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
                    count: ready.filteredCountUpcoming,
                    isLoading: ready.isLoadingVisits && upcomingVisits.isEmpty,
                    isFetchingMore: ready.isFetchingMoreUpcoming,
                    onPaginationTrigger: () => context.read<HomeScreenBloc>().add(
                      const HomeScreenUpcomingVisitsRequested(isNextPage: true),
                    ),
                    onHeaderTap: () => _scrollToAnchor(_upcomingAnchorKey, topInset: 64),
                  ),
                  ..._buildSectionSlivers(
                    title: AppStrings.homeCompletedLabel,
                    visits: recordedVisits,
                    markerType: HomeVisitMarkerType.completed,
                    addTopDivider: true,
                    sectionHeaderKey: _completedHeaderKey,
                    sectionAnchorKey: _completedAnchorKey,
                    count: ready.filteredCountRecorded,
                    isLoading: ready.isLoadingVisits && recordedVisits.isEmpty,
                    isFetchingMore: ready.isFetchingMoreRecorded,
                    onPaginationTrigger: () => context.read<HomeScreenBloc>().add(
                      const HomeScreenRecordedVisitsRequested(isNextPage: true),
                    ),
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
                        for (int i = 0; i < bottomItems.length; i++) ...<Widget>[
                          SizedBox(
                            height: 31,
                            child: InkWell(
                              onTap: bottomItems[i].onTap,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
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
    required List<VisitModel> visits,
    required HomeVisitMarkerType markerType,
    required GlobalKey sectionHeaderKey,
    required GlobalKey sectionAnchorKey,
    required VoidCallback onHeaderTap,
    required VoidCallback onPaginationTrigger,
    int? count,
    bool isLoading = false,
    bool isFetchingMore = false,
    bool addTopDivider = false,
  }) {
    final int displayCount = count ?? visits.length;
    
    if (isLoading) {
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
            count: 0,
            height: 32,
            onTap: onHeaderTap,
          ),
        ),
        SliverToBoxAdapter(child: SizedBox(height: 1, key: sectionAnchorKey)),
        SliverToBoxAdapter(
          child: Skeletonizer(
            enabled: true,
            child: Column(
              children: List.generate(3, (index) => _buildSkeletonRow(markerType)),
            ),
          ),
        ),
      ];
    }

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
          count: displayCount,
          height: 32,
          onTap: onHeaderTap,
        ),
      ),
      SliverToBoxAdapter(child: SizedBox(height: 1, key: sectionAnchorKey)),
      if (visits.isEmpty)
        const SliverToBoxAdapter(child: HomeSectionEmptyState())
      else
        SliverList.builder(
          itemCount: visits.length + (isFetchingMore ? 1 : 0),
          itemBuilder: (BuildContext context, int index) {
            if (index == visits.length) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
              );
            }
            
            // Check for pagination trigger
            if (index == visits.length - 1 && !isFetchingMore) {
              WidgetsBinding.instance.addPostFrameCallback((_) => onPaginationTrigger());
            }

            return HomeVisitRow(visit: visits[index], markerType: markerType);
          },
        ),
    ];
  }

  Widget _buildSkeletonRow(HomeVisitMarkerType markerType) {
    return HomeVisitRow(
      visit: VisitModel(
        patientId: 'loading',
        visitId: 0,
        visitStatus: 'Loading',
        firstName: 'Patient',
        lastName: 'Name',
        gender: 'Other',
        doctorName: 'Doctor Name',
        appointmentTime: '2026-01-01T10:00:00Z',
        visitTypeName: 'In-person',
        visitTypeDescription: 'Standard checkup',
        age: 30,
      ),
      markerType: markerType,
    );
  }
}
