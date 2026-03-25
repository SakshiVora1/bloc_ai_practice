import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'splash_screen_event.dart';
part 'splash_screen_state.dart';

class SplashScreenBloc extends Bloc<SplashScreenEvent, SplashScreenState> {
  SplashScreenBloc() : super(const SplashScreenInitial()) {
    on<SplashScreenStarted>(_onStarted);
    on<SplashScreenTimerFinished>(_onTimerFinished);
  }

  static const Duration _splashDisplayDuration = Duration(seconds: 2);

  Timer? _timer;
  bool _started = false;

  void _onStarted(SplashScreenStarted event, Emitter<SplashScreenState> emit) {
    if (_started) {
      return;
    }
    _started = true;
    _timer?.cancel();
    _timer = Timer(_splashDisplayDuration, () {
      if (!isClosed) {
        add(const SplashScreenTimerFinished());
      }
    });
  }

  void _onTimerFinished(
    SplashScreenTimerFinished event,
    Emitter<SplashScreenState> emit,
  ) {
    emit(const SplashScreenReadyForLogin());
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
