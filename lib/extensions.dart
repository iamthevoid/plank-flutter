
import 'package:flutter/material.dart';

extension GlobalExtension<T> on T {
  T also(void act(T)) {
    act(this);
    return this;
  }

  R let<R>(R transform(T)) {
    return transform(this);
  }

}

extension BuildContextExtensions on BuildContext {

  double get statusBarHeight => MediaQuery.of(this).padding.top;

  double get screenHeight => MediaQuery.of(this).size.height;

  double get screenWidth => MediaQuery.of(this).size.width;

}