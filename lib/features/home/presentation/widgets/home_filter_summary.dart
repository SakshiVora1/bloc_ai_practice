import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subqdocs_bloc/core/constants/app_colors.dart';
import 'package:subqdocs_bloc/core/constants/app_fonts.dart';
import 'package:subqdocs_bloc/core/constants/app_strings.dart';
import 'package:subqdocs_bloc/core/utils/date_formatters.dart';
import 'package:subqdocs_bloc/features/home/presentation/bloc/home_screen_bloc.dart';

class HomeFilterSummary extends StatelessWidget {
  const HomeFilterSummary({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeScreenBloc, HomeScreenState>(
      builder: (context, state) {
        if (state is! HomeScreenReady) return const SizedBox.shrink();

        final hasStatus = state.selectedStatuses.isNotEmpty;
        final hasDoctors = state.selectedProviders.isNotEmpty;
        final hasMAs = state.selectedMedicalAssistants.isNotEmpty;
        final hasLocations = state.selectedOfficeLocations.isNotEmpty;
        final hasDateRange = state.endDate != null;

        if (!hasStatus &&
            !hasDoctors &&
            // !hasMAs &&
            !hasLocations &&
            !hasDateRange) {
          return const SizedBox.shrink();
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                AppStrings.homeFilterSummaryLabel,
                style: AppFonts.medium(14, AppColors.primaryText),
              ),
              if (hasStatus)
                _FilterChip(
                  label:
                      '${AppStrings.homeFilterStatusPrefix} ${state.selectedStatuses.join(', ')}',
                  onDelete: () => context.read<HomeScreenBloc>().add(
                        const HomeScreenFilterStatusChanged([]),
                      ),
                ),
              if (hasDoctors)
                _FilterChip(
                  label:
                      '${AppStrings.homeFilterProviderPrefix} ${state.selectedProviders.map((s) => s.name).join(', ')}',
                  onDelete: () => context.read<HomeScreenBloc>().add(
                        const HomeScreenFilterProviderChanged([]),
                      ),
                ),
              // if (hasMAs)
              //   _FilterChip(
              //     label:
              //         '${AppStrings.homeFilterMedicalAssistantPrefix} ${state.selectedMedicalAssistants.map((s) => s.name).join(', ')}',
              //     onDelete: () => context.read<HomeScreenBloc>().add(
              //           const HomeScreenFilterMedicalAssistantChanged([]),
              //         ),
              //   ),
              if (hasDateRange)
                _FilterChip(
                  label:
                      '${AppStrings.homeFilterVisitDatePrefix} ${_formatRange(state.startDate, state.endDate)}',
                  onDelete: () {
                    final today = DateTime(
                      DateTime.now().year,
                      DateTime.now().month,
                      DateTime.now().day,
                    );
                    context.read<HomeScreenBloc>().add(
                          HomeScreenDateSelected(start: today, end: null),
                        );
                  },
                ),
              if (hasLocations)
                _FilterChip(
                  label:
                      '${AppStrings.homeFilterOfficePrefix} ${state.selectedOfficeLocations.map((e) => e.name).join(', ')}',
                  onDelete: () => context.read<HomeScreenBloc>().add(
                        const HomeScreenFilterOfficeLocationChanged([]),
                      ),
                ),
              TextButton(
                onPressed: () => context.read<HomeScreenBloc>().add(
                      const HomeScreenFilterClearAll(),
                    ),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  AppStrings.homeFilterClearAll,
                  style: AppFonts.medium(14, AppColors.primaryAction)
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatRange(DateTime? start, DateTime? end) {
    if (start == null) return '';
    if (end == null) return formatDateMmDdYyyy(start);
    return '${formatDateMmDdYyyy(start)} - ${formatDateMmDdYyyy(end)}';
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.onDelete,
  });

  final String label;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final parts = label.split(':');
    final String prefix = parts.length > 1 ? '${parts[0]}:' : '';
    final String value = parts.length > 1 ? label.substring(prefix.length) : label;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.chipSelectedBackground,
        border: Border.all(color: AppColors.homeSectionDivider),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text.rich(
              TextSpan(
                children: [
                  if (prefix.isNotEmpty)
                    TextSpan(
                      text: prefix,
                      style: AppFonts.medium(12, AppColors.black),
                    ),
                  TextSpan(
                    text: value,
                    style: AppFonts.medium(12, AppColors.primaryAction),
                  ),
                ],
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          InkWell(
            onTap: onDelete,
            child: const Icon(
              Icons.cancel,
              size: 16,
              color: AppColors.secondaryText,
            ),
          ),
        ],
      ),
    );
  }
}
