import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:plank/hive.dart';
import 'package:plank/pages/plank_page.dart';

void main() {
  HiveManager.init();
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarBrightness: Brightness.dark));
  runApp(MaterialApp(
    title: 'Plank',
    initialRoute: PlankPage.route,
    routes: {
      PlankPage.route : (context) => PlankPage()
    },
  ));
}

final TextTheme mainTheme = TextTheme(

  headline1: TextStyle(
    color: Colors.amber[400],
  )
);