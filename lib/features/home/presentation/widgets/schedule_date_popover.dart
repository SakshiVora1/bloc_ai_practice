import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:subqdocs_bloc/core/constants/app_colors.dart';
import 'package:subqdocs_bloc/core/constants/app_fonts.dart';
import 'package:subqdocs_bloc/core/constants/app_strings.dart';
import 'package:subqdocs_bloc/core/routing/app_router.dart';
import 'package:subqdocs_bloc/features/home/domain/home_date_display.dart'
    show dateOnly;

/// Builds popup menu entry content for the schedule calendar picker.
PopupMenuEntry<void> buildScheduleDatePopupMenuEntry({
  required DateTime initialStart,
  required DateTime? initialEnd,
  required void Function(DateTime start, DateTime? end) onCommitted,
}) {
  final DateTime now = DateTime.now();
  final DateTime firstDate = DateTime(now.year - 5);
  final DateTime lastDate = DateTime(now.year + 5, 12, 31);

  return PopupMenuItem<void>(
    enabled: false,
    height: 0,
    padding: EdgeInsets.zero,
    child: SizedBox(
      height: 300,
      width: 500,
      child: _ScheduleDatePopoverCard(
        firstDate: firstDate,
        lastDate: lastDate,
        initialStart: initialStart,
        initialEnd: initialEnd,
        onCommitted: onCommitted,
      ),
    ),
  );
}

class _ScheduleDatePopoverCard extends StatefulWidget {
  const _ScheduleDatePopoverCard({
    required this.firstDate,
    required this.lastDate,
    required this.initialStart,
    required this.initialEnd,
    required this.onCommitted,
  });

  final DateTime firstDate;
  final DateTime lastDate;
  final DateTime initialStart;
  final DateTime? initialEnd;
  final void Function(DateTime start, DateTime? end) onCommitted;

  @override
  State<_ScheduleDatePopoverCard> createState() =>
      _ScheduleDatePopoverCardState();
}

class _ScheduleDatePopoverCardState extends State<_ScheduleDatePopoverCard> {
  late final ValueNotifier<List<DateTime?>> _rangeValues;

  @override
  void initState() {
    super.initState();
    final DateTime start = dateOnly(widget.initialStart);
    _rangeValues = ValueNotifier<List<DateTime?>>(<DateTime?>[
      start,
      widget.initialEnd != null ? dateOnly(widget.initialEnd!) : null,
    ]);
  }

  @override
  void dispose() {
    _rangeValues.dispose();
    super.dispose();
  }

  CalendarDatePicker2Config _pickerConfig() {
    return CalendarDatePicker2Config(
      calendarType: CalendarDatePicker2Type.range,
      firstDate: widget.firstDate,
      lastDate: widget.lastDate,
      currentDate: dateOnly(DateTime.now()),
      firstDayOfWeek: 0,
      controlsHeight: 36,
      lastMonthIcon: const Icon(
        Icons.chevron_left_rounded,
        size: 18,
        color: AppColors.secondaryText,
      ),
      nextMonthIcon: const Icon(
        Icons.chevron_right_rounded,
        size: 18,
        color: AppColors.secondaryText,
      ),
      disableMonthPicker: true,
      disableModePicker: true,
      centerAlignModePicker: true,
      customModePickerIcon: const SizedBox.shrink(),
      controlsTextStyle: AppFonts.semiBold(16, AppColors.primaryText),
      weekdayLabels: AppStrings.calendarWeekdayShort,
      weekdayLabelTextStyle: AppFonts.medium(14, AppColors.secondaryText),
      dayTextStyle: AppFonts.regular(14, AppColors.primaryText),
      dayBorderRadius: BorderRadius.circular(999),
      dayMaxWidth: 30,
      selectedDayHighlightColor: AppColors.scheduleVisitAccent,
      selectedRangeHighlightColor: AppColors.scheduleVisitAccent.withValues(
        alpha: 0.12,
      ),
      selectedDayTextStyle: AppFonts.medium(12, AppColors.white),
      selectedRangeDayTextStyle: AppFonts.medium(12, AppColors.primaryText),
      todayTextStyle: AppFonts.medium(12, AppColors.primaryText),
      daySplashColor: Colors.transparent,
    );
  }

  void _onCalendarValuesChanged(List<DateTime> dates) {
    if (dates.isEmpty) {
      return;
    }

    if (dates.length == 1) {
      final DateTime start = dateOnly(dates.first);
      _rangeValues.value = <DateTime?>[start, null];
      widget.onCommitted(start, null);
      return;
    }

    final DateTime a = dateOnly(dates[0]);
    final DateTime b = dateOnly(dates[1]);
    _rangeValues.value = <DateTime?>[a, b];
    widget.onCommitted(a, _isSameDay(a, b) ? null : b);
  }

  bool _isSameDay(DateTime x, DateTime y) =>
      x.year == y.year && x.month == y.month && x.day == y.day;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<DateTime?>>(
      valueListenable: _rangeValues,
      builder: (BuildContext context, List<DateTime?> values, Widget? child) {
        final List<DateTime?> pickerValue = <DateTime?>[
          values.first,
          values.length > 1 ? values[1] : null,
        ];

        return Material(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          clipBehavior: Clip.antiAlias,
          child: SizedBox(
            height: 300,
            width: 500,
            child: CalendarDatePicker2(
              config: _pickerConfig(),
              value: pickerValue,
              onValueChanged: _onCalendarValuesChanged,
            ),
          ),
        );
      },
    );
  }
}

/// Bottom sheet calendar for the schedule header date control.
Future<void> showScheduleDatePopover({
  required BuildContext context,
  required DateTime initialStart,
  required DateTime? initialEnd,
  required void Function(DateTime start, DateTime? end) onCommitted,
}) async {
  final DateTime now = DateTime.now();
  final DateTime firstDate = DateTime(now.year - 5);
  final DateTime lastDate = DateTime(now.year + 5, 12, 31);

  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (BuildContext sheetContext) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(
                    AppStrings.calendarPickerTitle,
                    style: AppFonts.semiBold(16, AppColors.primaryText),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => AppRouter.pop(sheetContext),
                    child: Text(AppStrings.calendarApply),
                  ),
                ],
              ),
              SizedBox(
                height: 320,
                child: _ScheduleDatePopoverCard(
                  firstDate: firstDate,
                  lastDate: lastDate,
                  initialStart: initialStart,
                  initialEnd: initialEnd,
                  onCommitted: onCommitted,
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
