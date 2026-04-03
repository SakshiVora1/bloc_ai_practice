import 'package:flutter/material.dart';
import 'package:subqdocs_bloc/features/home/presentation/widgets/home_section_header.dart';

class HomeSectionHeaderDelegate extends SliverPersistentHeaderDelegate {
  const HomeSectionHeaderDelegate({
    required this.headerKey,
    required this.title,
    required this.count,
    required this.height,
    required this.onTap,
  });

  final Key headerKey;
  final String title;
  final int count;
  final double height;
  final VoidCallback onTap;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return HomeSectionHeader(
      key: headerKey,
      title: title,
      count: count,
      onTap: onTap,
    );
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(covariant HomeSectionHeaderDelegate oldDelegate) {
    return oldDelegate.title != title ||
        oldDelegate.count != count ||
        oldDelegate.height != height ||
        oldDelegate.headerKey != headerKey ||
        oldDelegate.onTap != onTap;
  }
}
