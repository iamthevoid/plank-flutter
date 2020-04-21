import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:plank/plank_event.dart';
import 'package:plank/plank_state.dart';

class PlankBloc extends Bloc<PlankEvent, PlankState> {
  static const int _STEP_DURATION_MILLIS = 40;
  static const int DEFAULT_ACTIVE_PERIOD = 30;
  static const int DEFAULT_REST_PERIOD = 4;

  int summaryDuration = 0;

  int activeDuration;
  int restDuration;

  StreamSubscription subscription;

  @override
  PlankState get initialState => PlankInitialState();

  @override
  Stream<PlankState> mapEventToState(PlankEvent event) async* {
    if (event is PlankResetEvent) {
      yield PlankInitialState();
    } else if (event is PlankStopEvent) {
      yield PlankStopState(
          activeDurationSeconds: activeDuration,
          restDurationSeconds: restDuration,
          millis: summaryDuration);
    } else if (event is PlankCounterEvent) {
      yield PlankCounterState(
          activeDurationSeconds: activeDuration,
          restDurationSeconds: restDuration,
          millis: event.millis);
    }
  }

  @override
  Future<Function> close() {
    super.close();
    subscription?.cancel();
  }

  void reset() {
    subscription?.cancel();
    summaryDuration = 0;
    add(PlankResetEvent());
  }

  void onButtonPressed(
      {@required String activeSeconds, @required String restSeconds}) {
    if (state is PlankStopState) {
      _start("$activeDuration", "$restDuration");
    } else if (state is PlankInitialState) {
      _start(activeSeconds, restSeconds);
    } else {
      _stop();
    }
  }

  void _start(String activeSeconds, String restSeconds) {
    this.activeDuration = duration(activeSeconds, DEFAULT_ACTIVE_PERIOD);
    this.restDuration = duration(restSeconds, DEFAULT_REST_PERIOD);
    subscription?.cancel();
    subscription =
        Stream.periodic(Duration(milliseconds: _STEP_DURATION_MILLIS), (count) {
      summaryDuration += _STEP_DURATION_MILLIS;
      return PlankCounterEvent(summaryDuration);
    }).listen((event) {
      add(event);
    });
  }

  void _stop() {
    subscription?.cancel();
    add(PlankStopEvent());
  }

  int duration(String input, int defaultValue) {
    int duration = input.isEmpty ? defaultValue : double.parse(input).toInt();
    return duration == 0 ? defaultValue : duration;
  }
}
