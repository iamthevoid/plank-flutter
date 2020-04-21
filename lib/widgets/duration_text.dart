import 'package:flutter/material.dart';
import 'package:plank/utils.dart';

class DurationText extends StatelessWidget {
  final String text;

  DurationText(this.text);

  @override
  Widget build(BuildContext context) => RichText(
        text: spanned(
          text,
          separator: ":",
          style: TextStyle(
              color: Colors.amber[200].withOpacity(0.7),
              fontWeight: FontWeight.bold,
              fontSize: 18),
        ),
      );
}
