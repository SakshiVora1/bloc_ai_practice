import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:subqdocs_bloc/features/home/domain/home_date_display.dart';
import 'package:subqdocs_bloc/features/home/presentation/bloc/home_screen_bloc.dart';

void main() {
  blocTest<HomeScreenBloc, HomeScreenState>(
    'emits HomeScreenReady when HomeScreenStarted is added',
    build: HomeScreenBloc.new,
    act: (HomeScreenBloc b) => b.add(const HomeScreenStarted()),
    verify: (HomeScreenBloc b) {
      final HomeScreenState state = b.state;
      expect(state, isA<HomeScreenReady>());
      final HomeScreenReady ready = state as HomeScreenReady;
      final DateTime today = todayDateOnly(() => DateTime.now());
      expect(ready.startDate, today);
      expect(ready.endDate, isNull);
      expect(ready.displayLabel, isNotEmpty);
    },
  );
}
