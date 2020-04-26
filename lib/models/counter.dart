import 'dart:math';
import 'package:meta/meta.dart';

class Counter {
  final int activeDurationSeconds;
  final int restDurationSeconds;
  final int currentStateDuration;
  final int fullActivePeriods;
  final int fullRestPeriods;
  final bool isActive;
  final bool isRest;

  Counter._(
      this.activeDurationSeconds,
      this.restDurationSeconds,
      this.currentStateDuration,
      this.fullActivePeriods,
      this.fullRestPeriods,
      this.isActive,
      this.isRest);

  factory Counter({
    @required int activeDurationSeconds,
    @required int restDurationSeconds,
    @required int millis,
  }) {
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

    return Counter._(activeDurationSeconds, restDurationSeconds,
        currentStateDuration, activeCounter, restCounter, isActive, isRest);
  }


  @override
  String toString() => 'now: ${isActive ? 'Plank' : 'Rest'}, active period: $activeDurationSeconds, rest period: $restDurationSeconds, current state duration: ${currentToString()}, full active periods: $fullActivePeriods, full rest periods $fullRestPeriods';

  String currentToString() =>
      durationToString(currentStateDuration);

  String plankSummaryToString() => durationToString(
      fullActivePeriods * activeDurationSeconds * 1000 +
          (isActive ? currentStateDuration : 0));

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
