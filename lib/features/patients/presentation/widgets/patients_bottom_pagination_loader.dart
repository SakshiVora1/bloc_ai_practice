import 'package:flutter/material.dart';
import 'package:subqdocs_bloc/core/constants/app_colors.dart';

class PatientsBottomPaginationLoader extends StatelessWidget {
  const PatientsBottomPaginationLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: AppColors.primaryAction,
          ),
        ),
      ),
    );
  }
}
