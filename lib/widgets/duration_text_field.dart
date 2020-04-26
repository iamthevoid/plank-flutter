import 'package:flutter/material.dart';

class DurationTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final Function(String) onTextChange;

  DurationTextField({
    @required this.hint,
    @required this.onTextChange,
    @required this.controller
  });

  @override
  Widget build(BuildContext context) => TextField(
    onChanged: onTextChange,
    style: TextStyle(color: Colors.grey[400]),
    cursorColor: Colors.grey[600],
    keyboardType: TextInputType.number,
    controller: this.controller,
    decoration: InputDecoration(
      fillColor: Colors.amber[400].withOpacity(0.7),
      hintStyle: TextStyle(color: Colors.grey[200]),
      labelStyle: TextStyle(color: Colors.grey[200]),
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 0.5,
            color: Colors.amber[400].withOpacity(0.7),
          )),
      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.amber[400].withOpacity(0.7),
          )),
      labelText: hint,
    ),
  );
}
