import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:subqdocs_bloc/core/constants/app_colors.dart';
import 'package:subqdocs_bloc/core/constants/app_fonts.dart';
import 'package:subqdocs_bloc/core/constants/app_strings.dart';
import 'package:subqdocs_bloc/features/home/presentation/bloc/home_screen_bloc.dart';
import 'package:subqdocs_bloc/widgets/common_text_form_field.dart';

class FilterDateSelector extends StatelessWidget {
  const FilterDateSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeScreenBloc, HomeScreenState>(
      builder: (context, state) {
        if (state is! HomeScreenReady) return const SizedBox.shrink();

        final String dateText = _formatDateRange(state.draftStartDate, state.draftEndDate);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              AppStrings.visitDateLabel,
              style: AppFonts.medium(14, AppColors.primaryText),
            ),
            const SizedBox(height: 8),
            CommonTextFormField(
              readOnly: true,
              hintText: AppStrings.settingsHintLicenseExpiry,
              controller: TextEditingController(text: dateText),
              suffixIcon: const Icon(Icons.calendar_today_outlined, size: 20),
              fillColor: AppColors.white,
              onTap: () {
                context.read<HomeScreenBloc>().add(
                  const HomeScreenFilterCalendarVisibilityToggled(),
                );
              },
            ),
            const SizedBox(height: 16),
            _buildChips(context, state),
            if (state.isCalendarVisible) ...[
              const SizedBox(height: 16),
              _buildCalendar(context, state),
            ],
          ],
        );
      },
    );
  }

  String _formatDateRange(DateTime? start, DateTime? end) {
    if (start == null) return '';
    final DateFormat formatter = DateFormat('MM/dd/yyyy');
    if (end == null || _isSameDay(start, end)) {
      return formatter.format(start);
    }
    return '${formatter.format(start)} - ${formatter.format(end)}';
  }

  bool _isSameDay(DateTime d1, DateTime d2) {
    return d1.year == d2.year && d1.month == d2.month && d1.day == d2.day;
  }

  Widget _buildCalendar(BuildContext context, HomeScreenReady state) {
    return CalendarDatePicker2(
      config: CalendarDatePicker2Config(
        calendarType: CalendarDatePicker2Type.range,
        selectedDayHighlightColor: const Color(0xFF4A4ADE),
      ),
      value: [
        state.draftStartDate,
        if (state.draftEndDate != null) state.draftEndDate,
      ],
      onValueChanged: (dates) {
        if (dates.isNotEmpty) {
          context.read<HomeScreenBloc>().add(
            HomeScreenDateSelected(
              start: dates[0],
              end: dates.length > 1 ? dates[1] : null,
            ),
          );
        }
      },
    );
  }

  Widget _buildChips(BuildContext context, HomeScreenReady state) {
    final List<String> chipLabels = [
      AppStrings.homeScheduleDateToday,
      AppStrings.dateShortcutTomorrow,
      AppStrings.dateShortcutYesterday,
      AppStrings.dateShortcutNext7Days,
      AppStrings.dateShortcutPast7Days,
      AppStrings.dateShortcutThisMonth,
      AppStrings.dateShortcutLastMonth,
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: chipLabels.map((label) {
        final bool isSelected = _isChipSelected(label, state);
        return InkWell(
          onTap: () => _onChipTap(context, label),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primaryAction.withAlpha((0.2 * 255).toInt())
                  : AppColors.secondaryText.withAlpha((0.2 * 255).toInt()),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              label,
              style: AppFonts.medium(
                12,
                isSelected ? AppColors.primaryAction : AppColors.secondaryText,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  bool _isChipSelected(String label, HomeScreenReady state) {
    if (state.draftStartDate == null) return false;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final s = DateTime(state.draftStartDate!.year, state.draftStartDate!.month,
        state.draftStartDate!.day);
    final e = state.draftEndDate != null
        ? DateTime(state.draftEndDate!.year, state.draftEndDate!.month,
            state.draftEndDate!.day)
        : null;

    if (label == AppStrings.homeScheduleDateToday) {
      return s == today && (e == null || e == s);
    } else if (label == AppStrings.dateShortcutTomorrow) {
      return s == today.add(const Duration(days: 1)) && (e == null || e == s);
    } else if (label == AppStrings.dateShortcutYesterday) {
      return s == today.subtract(const Duration(days: 1)) && (e == null || e == s);
    } else if (label == AppStrings.dateShortcutNext7Days) {
      return s == today && e == today.add(const Duration(days: 6));
    } else if (label == AppStrings.dateShortcutPast7Days) {
      return s == today.subtract(const Duration(days: 6)) && e == today;
    } else if (label == AppStrings.dateShortcutThisMonth) {
      return s == DateTime(today.year, today.month, 1) &&
          e == DateTime(today.year, today.month + 1, 0);
    } else if (label == AppStrings.dateShortcutLastMonth) {
      return s == DateTime(today.year, today.month - 1, 1) &&
          e == DateTime(today.year, today.month, 0);
    }
    return false;
  }

  void _onChipTap(BuildContext context, String label) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    DateTime start;
    DateTime? end;

    if (label == AppStrings.homeScheduleDateToday) {
      start = today;
    } else if (label == AppStrings.dateShortcutTomorrow) {
      start = today.add(const Duration(days: 1));
    } else if (label == AppStrings.dateShortcutYesterday) {
      start = today.subtract(const Duration(days: 1));
    } else if (label == AppStrings.dateShortcutNext7Days) {
      start = today;
      end = today.add(const Duration(days: 6));
    } else if (label == AppStrings.dateShortcutPast7Days) {
      start = today.subtract(const Duration(days: 6));
      end = today;
    } else if (label == AppStrings.dateShortcutThisMonth) {
      start = DateTime(today.year, today.month, 1);
      end = DateTime(today.year, today.month + 1, 0);
    } else if (label == AppStrings.dateShortcutLastMonth) {
      start = DateTime(today.year, today.month - 1, 1);
      end = DateTime(today.year, today.month, 0);
    } else {
      return;
    }

    context.read<HomeScreenBloc>().add(
          HomeScreenDateSelected(start: start, end: end),
        );
  }
}
