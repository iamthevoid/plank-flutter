import 'package:flutter/material.dart';
import 'package:plank/widgets/duration_text.dart';
import 'package:plank/widgets/duration_text_field.dart';

class DurationBox extends StatelessWidget {
  final bool editable;

  final String editableHint;
  final String nonEditableText;

  final TextEditingController controller;
  final Function(String) onTextChange;

  DurationBox({
    @required this.editable,
    @required this.editableHint,
    @required this.nonEditableText,
    @required this.controller,
    @required this.onTextChange,
  });

  @override
  Widget build(BuildContext context) => Container(
        width: 168,
        height: 64,
        alignment: Alignment.center,
        child: AnimatedSwitcher(
          duration: Duration(milliseconds: 150),
          child: editable
              ? DurationTextField(
                  hint: editableHint,
                  onTextChange: onTextChange,
                  controller: controller,
                )
              : DurationText(nonEditableText),
        ),
      );
}
