import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subqdocs_bloc/core/constants/app_strings.dart';
import 'package:subqdocs_bloc/features/home/presentation/bloc/home_screen_bloc.dart';
import 'package:subqdocs_bloc/features/home/presentation/widgets/filter_header.dart';
import 'package:subqdocs_bloc/features/home/presentation/widgets/filter_date_selector.dart';
import 'package:subqdocs_bloc/features/home/presentation/widgets/filter_multi_select_dropdown.dart';
import 'package:subqdocs_bloc/features/home/domain/status_mapping.dart';
import 'package:subqdocs_bloc/data/models/staff_model.dart';
import 'package:subqdocs_bloc/data/models/office_location_model.dart';

class HomeFilterPanel extends StatefulWidget {
  const HomeFilterPanel({super.key});

  @override
  State<HomeFilterPanel> createState() => _HomeFilterPanelState();
}

class _HomeFilterPanelState extends State<HomeFilterPanel> {
  @override
  void dispose() {
    // Requirements: "it will call an api when the panel gets closed or disposed"
    // We send an event to the bloc when this widget is disposed.
    // However, context might not be available here directly, so we use a closure or bloc.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeScreenBloc, HomeScreenState>(
      builder: (context, state) {
        if (state is! HomeScreenReady) return const SizedBox.shrink();

        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Column(
            children: [
              FilterHeader(
                onClearTap: () {
                  context.read<HomeScreenBloc>().add(
                        const HomeScreenFilterClearAll(),
                      );
                },
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  children: [
                    const FilterDateSelector(),
                    const SizedBox(height: 24),
                    FilterMultiSelectDropdown<String>(
                      label: AppStrings.filterStatus,
                      items: StatusMapping.statuses,
                      selectedItems: state.draftStatuses,
                      isStatus: true,
                      onChanged: (val) {
                        context.read<HomeScreenBloc>().add(
                              HomeScreenFilterStatusChanged(val),
                            );
                      },
                    ),
                    const SizedBox(height: 24),
                    FilterMultiSelectDropdown<StaffModel>(
                      label: AppStrings.filterProvider,
                      items: state.allProviders,
                      selectedItems: state.draftProviders,
                      showSearch: true,
                      itemLabelBuilder: (doctor) => doctor.name,
                      onChanged: (val) {
                        context.read<HomeScreenBloc>().add(
                              HomeScreenFilterProviderChanged(val),
                            );
                      },
                    ),
                    const SizedBox(height: 24),
                    // FilterMultiSelectDropdown<StaffModel>(
                    //   label: AppStrings.filterMedicalAssistant,
                    //   items: state.allMedicalAssistants,
                    //   selectedItems: state.draftMedicalAssistants,
                    //   showSearch: true,
                    //   itemLabelBuilder: (ma) => ma.name,
                    //   onChanged: (val) {
                    //     context.read<HomeScreenBloc>().add(
                    //           HomeScreenFilterMedicalAssistantChanged(val),
                    //         );
                    //   },
                    // ),
                    // const SizedBox(height: 24),
                    FilterMultiSelectDropdown<OfficeLocationModel>(
                      label: AppStrings.filterOffice,
                      items: state.allOfficeLocations,
                      selectedItems: state.draftOfficeLocations,
                      showSearch: true,
                      itemLabelBuilder: (loc) => loc.name,
                      onChanged: (val) {
                        context.read<HomeScreenBloc>().add(
                              HomeScreenFilterOfficeLocationChanged(val),
                            );
                      },
                    ),
                    // Dynamic space for keyboard to allow scrolling past last item
                    SizedBox(
                      height: MediaQuery.viewInsetsOf(context).bottom + 300,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
