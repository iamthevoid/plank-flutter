
import 'dart:io';

import 'package:meta/meta.dart';
import 'package:hive/hive.dart';

class HiveManager {

  static const SHARED_BOX = 'shared_box';

  static const KEY_ACTIVE_PERIOD_SECONDS = 'key_active_period_seconds';
  static const KEY_REST_PERIOD_SECONDS = 'key_rest_period_seconds';
  static const KEY_BACKGROUND_IMAGE = 'key_background_image';

  static void init() {
    Hive
      ..init(Directory.systemTemp.path);
  }

  static Future<Box> _shared() => Hive.openBox(SHARED_BOX);

  static Future<int> activeDuration({ @required int defaultValue })  =>
      _shared().then((it) => it.get(KEY_ACTIVE_PERIOD_SECONDS, defaultValue: defaultValue));

  static void updateActiveDuration(int activeDuration) =>
      _shared().then((it) => it.put(KEY_ACTIVE_PERIOD_SECONDS, activeDuration));

  static Future<int> restDuration({ @required int defaultValue }) =>
      _shared().then((it) => it.get(KEY_REST_PERIOD_SECONDS, defaultValue: defaultValue));

  static void updateRestDuration(int restDuration) =>
      _shared().then((value) => value.put(KEY_REST_PERIOD_SECONDS, restDuration));
}