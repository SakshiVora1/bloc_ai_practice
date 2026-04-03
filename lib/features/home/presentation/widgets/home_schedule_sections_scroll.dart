import 'package:flutter/material.dart';
import 'package:subqdocs_bloc/features/home/presentation/widgets/home_visits_sections.dart';

/// Main visit list for the schedule body (current / upcoming / completed).
class HomeScheduleSectionsScroll extends StatelessWidget {
  const HomeScheduleSectionsScroll({super.key});

  @override
  Widget build(BuildContext context) {
    return const HomeVisitsSections();
  }
}
