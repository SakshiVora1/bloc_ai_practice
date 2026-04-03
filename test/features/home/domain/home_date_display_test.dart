import 'package:flutter_test/flutter_test.dart';
import 'package:subqdocs_bloc/features/home/domain/home_date_display.dart';

void main() {
  final DateTime fixedNow = DateTime(2026, 3, 31, 15, 30);

  String format({DateTime? start, DateTime? end}) {
    return formatDisplayDate(
      start,
      end,
      now: () => fixedNow,
      todayLabel: 'Today',
      yesterdayLabel: 'Yesterday',
      tomorrowLabel: 'Tomorrow',
    );
  }

  group('formatDisplayDate', () {
    test('returns empty when start is null', () {
      expect(format(start: null, end: null), '');
    });

    test('single date uses smart labels', () {
      expect(format(start: DateTime(2026, 3, 31)), 'Today');
      expect(format(start: DateTime(2026, 3, 30)), 'Yesterday');
      expect(format(start: DateTime(2026, 4, 1)), 'Tomorrow');
    });

    test('single date uses MM/dd/yyyy with zero padding', () {
      expect(format(start: DateTime(2026, 3, 5)), '03/05/2026');
    });

    test('range always uses formatted dates, never smart labels', () {
      expect(
        format(start: DateTime(2026, 3, 31), end: DateTime(2026, 3, 31)),
        '03/31/2026 - 03/31/2026',
      );
      expect(
        format(start: DateTime(2026, 3, 28), end: DateTime(2026, 3, 31)),
        '03/28/2026 - 03/31/2026',
      );
    });

    test('range orders endpoints when start is after end', () {
      expect(
        format(start: DateTime(2026, 3, 31), end: DateTime(2026, 3, 28)),
        '03/28/2026 - 03/31/2026',
      );
    });
  });

  group('todayDateOnly', () {
    test('strips time', () {
      final DateTime n = DateTime(2026, 7, 4, 23, 59);
      expect(todayDateOnly(() => n), DateTime(2026, 7, 4));
    });
  });
}
