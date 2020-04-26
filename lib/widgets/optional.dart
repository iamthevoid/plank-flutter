import 'package:flutter/material.dart';

class Optional extends StatelessWidget {
  final Widget Function(BuildContext context) create;
  final bool condition;

  Optional({this.condition = true, this.create});

  @override
  Widget build(BuildContext context) {
    return condition ? create(context) : SizedBox.shrink();
  }
}
