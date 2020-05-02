import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:plank/hive.dart';
import 'package:plank/models/counter.dart';
import 'package:rxdart/rxdart.dart';

class PlankViewModel {
  static const int _STEP_DURATION_MILLIS = 60;
  static const int _DEFAULT_ACTIVE_PERIOD = 30;
  static const int _DEFAULT_REST_PERIOD = 4;

  PlankViewModel()
      : this._count = BehaviorSubject.seeded(0),
        this._edit = BehaviorSubject.seeded(true),
        this._run = BehaviorSubject.seeded(false),
        this._activeDuration = _DEFAULT_ACTIVE_PERIOD,
        this._restDuration = _DEFAULT_REST_PERIOD
  ;

  StreamSubscription _subscription;

  final BehaviorSubject<int> _count;

  final BehaviorSubject<bool> _edit;

  final BehaviorSubject<bool> _run;

  int _activeDuration;

  int _restDuration;

  String image;

  void updateActive(String active) => HiveManager.updateActiveDuration(
      _duration(active, _DEFAULT_ACTIVE_PERIOD));

  void updateRest(String rest) =>
      HiveManager.updateRestDuration(_duration(rest, _DEFAULT_REST_PERIOD));

  void updateBackgroundImage(String path) =>
      HiveManager.updateBackgroundImage(path);

  Future<int> activePeriod()  =>
      HiveManager.activeDuration(defaultValue: _DEFAULT_ACTIVE_PERIOD);

  Future<int> restPeriod()  =>
      HiveManager.restDuration(defaultValue: _DEFAULT_REST_PERIOD);

  Future<String> backgroundImage()  => HiveManager.backgroundImage();

  Stream<bool> get isRunning => _run;

  Stream<bool> get isEditing => _edit;

  Stream<Counter> get counter => _count.map((count) => Counter(
            activeDurationSeconds: _activeDuration,
            restDurationSeconds: _restDuration,
            millis: count,
          ));

  void onButtonPressed(
      {@required String activeSeconds, @required String restSeconds}) {
    // stopped
    if (_count.value > 0 && !_run.value) {
      _start("$_activeDuration", "$_restDuration");
      // start state, edit duration
    } else if (_edit.value) {
      _start(activeSeconds, restSeconds);
      // running now
    } else {
      _stop();
    }
  }

  void dispose() {
    _edit.close();
    _run.close();
    _count.close();
  }

  void _start(String activeSeconds, String restSeconds) {
    print('start at: ${DateTime.now()}');
    this._activeDuration = _duration(activeSeconds, _DEFAULT_ACTIVE_PERIOD);
    this._restDuration = _duration(restSeconds, _DEFAULT_REST_PERIOD);
    _edit.add(false);
    _run.add(true);
    _subscription?.cancel();
    _subscription =
        Stream.periodic(Duration(milliseconds: _STEP_DURATION_MILLIS), (count) {
      return _STEP_DURATION_MILLIS;
    }).listen((count) {
      _count.add(count + _count.value);
    });
  }

  void _stop() {
    print('stop at: ${DateTime.now()}');
    _subscription?.cancel();
    _run.add(false);
  }

  void reset() {
    _count.add(0);
    _edit.add(true);
    _run.add(false);
  }

  int _duration(String input, int defaultValue) {
    int duration = input.isEmpty ? defaultValue : double.parse(input).toInt();
    return duration == 0 ? defaultValue : duration;
  }
}
