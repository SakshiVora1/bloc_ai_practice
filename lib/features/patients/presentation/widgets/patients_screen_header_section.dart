import 'package:flutter/material.dart';
import 'package:subqdocs_bloc/features/patients/presentation/widgets/patients_page_header_row.dart';

/// Padded [PatientsPageHeaderRow] for the patients screen (search + add).
///
/// [outerPadding] defaults to the spacing used above the table; use
/// [PatientsScreenHeaderSection.compactOuterPadding] for the load-failure
/// layout so spacing matches the previous implementation.
class PatientsScreenHeaderSection extends StatelessWidget {
  const PatientsScreenHeaderSection({
    required this.searchController,
    required this.onSearchChanged,
    required this.onSearchClear,
    required this.onAddPatient,
    this.outerPadding = const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 10,
    ),
    super.key,
  });

  static const EdgeInsets compactOuterPadding = EdgeInsets.symmetric(
    horizontal: 16,
  );

  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onSearchClear;
  final VoidCallback onAddPatient;
  final EdgeInsetsGeometry outerPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: outerPadding,
      child: PatientsPageHeaderRow(
        searchController: searchController,
        onSearchChanged: onSearchChanged,
        onSearchClear: onSearchClear,
        onAddPatient: onAddPatient,
      ),
    );
  }
}
