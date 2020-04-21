import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class PlankState implements Equatable {
  @override
  bool get stringify => true;
}

class PlankInitialState extends PlankState {
  @override
  List<Object> get props => [];
}

class PlankStopState extends _CounterState {
  PlankStopState(
      {@required int activeDurationSeconds,
      @required int restDurationSeconds,
      @required int millis})
      : super(
            activeDurationSeconds: activeDurationSeconds,
            restDurationSeconds: restDurationSeconds,
            millis: millis);
}

class PlankCounterState extends _CounterState {
  PlankCounterState(
      {@required int activeDurationSeconds,
      @required int restDurationSeconds,
      @required int millis})
      : super(
            activeDurationSeconds: activeDurationSeconds,
            restDurationSeconds: restDurationSeconds,
            millis: millis);
}

class _CounterState extends PlankState {
  final _Counter _counter;

  _CounterState(
      {@required int activeDurationSeconds,
      @required int restDurationSeconds,
      @required int millis})
      : _counter = _Counter(
            activeDurationSeconds: activeDurationSeconds,
            restDurationSeconds: restDurationSeconds,
            millis: millis);

  String currentToString() =>
      _counter.durationToString(_counter.currentStateDuration);

  String plankSummaryToString() => _counter.durationToString(
      _counter.fullActivePeriods * _counter.activeDurationSeconds * 1000 +
          (isActive() ? _counter.currentStateDuration : 0));

  bool isActive() => _counter.isActive;

  int restDurationSeconds() => _counter.restDurationSeconds;

  int activeDurationSeconds() => _counter.activeDurationSeconds;

  int fullRestPeriods() => _counter.fullRestPeriods;

  int fullPlankPeriods() => _counter.fullActivePeriods;

  @override
  List<Object> get props => [
        _counter.isRest,
        _counter.isActive,
        _counter.fullRestPeriods,
        _counter.fullActivePeriods,
        _counter.currentStateDuration,
        _counter.activeDurationSeconds,
        _counter.restDurationSeconds
      ];
}

class _Counter {
  final int activeDurationSeconds;
  final int restDurationSeconds;
  final int currentStateDuration;
  final int fullActivePeriods;
  final int fullRestPeriods;
  final bool isActive;
  final bool isRest;

  _Counter._(
      this.activeDurationSeconds,
      this.restDurationSeconds,
      this.currentStateDuration,
      this.fullActivePeriods,
      this.fullRestPeriods,
      this.isActive,
      this.isRest);

  factory _Counter(
      {@required int activeDurationSeconds,
      @required int restDurationSeconds,
      @required int millis}) {
    int activeMillis = activeDurationSeconds * 1000;
    int restMillis = restDurationSeconds * 1000;
    int tempMillis = millis;
    int last = tempMillis;
    int activeCounter = 0;
    int restCounter = 0;
    bool isActive = true;
    while (tempMillis > 0) {
      tempMillis -= (isActive ? activeMillis : restMillis);
      if (tempMillis >= 0) {
        last = tempMillis;
        activeCounter = activeCounter + (isActive ? 1 : 0);
        restCounter = restCounter + (!isActive ? 1 : 0);
        isActive = !isActive;
      }
    }

    int currentStateDuration = last;
    bool isRest = !isActive;

    return _Counter._(activeDurationSeconds, restDurationSeconds,
        currentStateDuration, activeCounter, restCounter, isActive, isRest);
  }

  String durationToString(int duration) {
    int secondsAll = duration ~/ 1000;
    int afterColon = (duration - secondsAll * 1000) ~/ 10;
    int minutesAll = secondsAll ~/ 60;
    if (minutesAll >= 60) {
      return "${completeWithZeroes(minutesAll ~/ 60, 2)}:${completeWithZeroes(minutesAll % 60, 2)}:${completeWithZeroes(secondsAll - minutesAll * 60, 2)}.${completeWithZeroes(afterColon, 2)}";
    } else if (minutesAll > 0) {
      return "${completeWithZeroes(minutesAll % 60, 2)}:${completeWithZeroes(secondsAll - minutesAll * 60, 2)}.${completeWithZeroes(afterColon, 2)}";
    } else {
      return "${completeWithZeroes(secondsAll - minutesAll * 60, 2)}.${completeWithZeroes(afterColon, 2)}";
    }
  }

  String completeWithZeroes(int what, int len) {
    int pivot = pow(10, len - 1);
    var whatString = "$what";
    if (what >= pivot) {
      return whatString;
    }

    int zeroesNeedCount = "$pivot".length - whatString.length;
    String result = whatString;
    for (int i = 0; i < zeroesNeedCount; i++) {
      result = "0$result";
    }

    return result;
  }
}
