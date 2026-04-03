import 'package:flutter/material.dart';
import 'package:subqdocs_bloc/core/constants/app_colors.dart';

enum HomeVisitMarkerType { active, upcoming, completed }

class HomeVisitMarker extends StatelessWidget {
  const HomeVisitMarker({super.key, required this.type});

  final HomeVisitMarkerType type;

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case HomeVisitMarkerType.active:
        return Container(
          width: 8,
          height: 8,
          decoration: const BoxDecoration(
            color: AppColors.homeVisitMarkerActive,
            shape: BoxShape.circle,
          ),
        );
      case HomeVisitMarkerType.upcoming:
        return Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.homeVisitMarkerUpcoming),
            shape: BoxShape.circle,
          ),
        );
      case HomeVisitMarkerType.completed:
        return Container(
          width: 8,
          height: 8,
          decoration: const BoxDecoration(
            color: AppColors.homeVisitMarkerCompleted,
            shape: BoxShape.circle,
          ),
        );
    }
  }
}
