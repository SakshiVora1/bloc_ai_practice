import 'package:flutter/material.dart';
import 'package:subqdocs_bloc/core/constants/app_colors.dart';
import 'package:subqdocs_bloc/core/constants/app_fonts.dart';
import 'package:subqdocs_bloc/core/constants/app_strings.dart';
import 'package:subqdocs_bloc/features/patients/presentation/widgets/patients_header_add_patient_control.dart';
import 'package:subqdocs_bloc/features/patients/presentation/widgets/patients_search_bar.dart';

class PatientsPageHeaderRow extends StatelessWidget {
  const PatientsPageHeaderRow({
    required this.searchController,
    required this.onSearchChanged,
    required this.onSearchClear,
    required this.onAddPatient,
    super.key,
  });

  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onSearchClear;
  final VoidCallback onAddPatient;

  static final TextStyle _titleStyle = AppFonts.medium(16, AppColors.black);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Text(
              AppStrings.patientsScreenTitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: _titleStyle,
            ),
          ),
          PatientsSearchBar(
            controller: searchController,
            onChanged: onSearchChanged,
            onClear: onSearchClear,
          ),
          const SizedBox(width: 8),
          PatientsHeaderAddPatientControl(onPressed: onAddPatient),
        ],
      ),
    );
  }
}
