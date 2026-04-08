import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subqdocs_bloc/core/constants/app_colors.dart';
import 'package:subqdocs_bloc/core/constants/app_fonts.dart';
import 'package:subqdocs_bloc/core/constants/app_strings.dart';
import 'package:subqdocs_bloc/features/settings/data/models/settings_office_location_response.dart';
import 'package:subqdocs_bloc/features/settings/presentation/bloc/settings_bloc.dart';

class EditPanelOfficeSelector extends StatelessWidget {
  const EditPanelOfficeSelector({
    super.key,
    required this.ready,
    this.validationError,
    required this.onClearError,
  });

  final SettingsReady ready;
  final String? validationError;
  final VoidCallback onClearError;

  void _toggleOfficeLocationSelection(SettingsBloc bloc, int officeLocationId) {
    onClearError();
    bloc.add(
      SettingsOfficeLocationSelectionToggled(
        officeLocationId: officeLocationId,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final SettingsBloc bloc = context.read<SettingsBloc>();
    final Map<int, String> namesById = <int, String>{
      for (final SettingsOfficeLocation location in ready.officeLocations)
        if (location.id != null && (location.name ?? '').trim().isNotEmpty)
          location.id!: location.name!.trim(),
    };
    final List<int> selectedIds = ready.selectedOfficeLocationIds;
    final List<int> selectedNamedIds = selectedIds
        .where((int id) => namesById.containsKey(id))
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            bloc.add(
              SettingsOfficeLocationDropdownToggled(
                isOpen: !ready.isOfficeLocationDropdownOpen,
              ),
            );
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.textFieldBorder),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: selectedNamedIds.isEmpty
                      ? Text(
                          AppStrings.settingsHintOfficeLocations,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppFonts.regular(14, AppColors.primaryText),
                        )
                      : Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: selectedNamedIds.map((int id) {
                            final String label = namesById[id]!;
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.drawerItemSelected.withValues(
                                  alpha: 0.1,
                                ),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text(
                                    label,
                                    style: AppFonts.medium(
                                      14,
                                      AppColors.drawerItemSelected,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      _toggleOfficeLocationSelection(bloc, id);
                                    },
                                    child: const Padding(
                                      padding: EdgeInsets.only(left: 6),
                                      child: Icon(
                                        Icons.close,
                                        size: 16,
                                        color: AppColors.drawerItemSelected,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                ),
                if (selectedIds.isNotEmpty)
                  InkWell(
                    onTap: () {
                      onClearError();
                      bloc.add(const SettingsOfficeLocationSelectionCleared());
                    },
                    child: const Padding(
                      padding: EdgeInsets.only(left: 8, right: 8),
                      child: Icon(
                        Icons.close,
                        size: 18,
                        color: AppColors.drawerItemUnselected,
                      ),
                    ),
                  ),
                Icon(
                  ready.isOfficeLocationDropdownOpen
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: AppColors.drawerItemUnselected,
                ),
              ],
            ),
          ),
        ),
        if (ready.isOfficeLocationDropdownOpen) ...<Widget>[
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.textFieldBorder),
            ),
            child: ready.isOfficeLocationsLoading
                ? const Padding(
                    padding: EdgeInsets.all(12),
                    child: Center(child: CircularProgressIndicator()),
                  )
                : Column(
                    children: ready.officeLocations.map((
                      SettingsOfficeLocation item,
                    ) {
                      final int? officeId = item.id;
                      if (officeId == null) {
                        return const SizedBox.shrink();
                      }
                      final String officeName = (item.name ?? '').trim();
                      if (officeName.isEmpty) {
                        return const SizedBox.shrink();
                      }
                      final bool selected = ready.selectedOfficeLocationIds
                          .contains(officeId);
                      return InkWell(
                        onTap: () {
                          _toggleOfficeLocationSelection(bloc, officeId);
                        },
                        child: Row(
                          children: <Widget>[
                            Checkbox(
                              visualDensity: const VisualDensity(
                                horizontal: -0.4,
                                vertical: -0.4,
                              ),
                              value: selected,
                              onChanged: (_) {
                                _toggleOfficeLocationSelection(bloc, officeId);
                              },
                            ),
                            Expanded(
                              child: Text(
                                officeName,
                                style: AppFonts.regular(
                                  14,
                                  AppColors.primaryText,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
          ),
        ],
        if ((ready.officeLocationsErrorMessage ?? '').trim().isNotEmpty) ...[
          const SizedBox(height: 6),
          Text(
            ready.officeLocationsErrorMessage!.trim(),
            style: AppFonts.regular(12, AppColors.error),
          ),
        ],
        if ((validationError ?? '').trim().isNotEmpty) ...[
          const SizedBox(height: 6),
          Text(validationError!, style: AppFonts.regular(12, AppColors.error)),
        ],
      ],
    );
  }
}
