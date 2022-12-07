import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final Function function;
  final bool stopped;

  const ActionButton(
      {Key key,
      @required this.function,
      @required this.stopped})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 160,
        height: 160,
        child: ElevatedButton(
          style: ButtonStyle(
            overlayColor: MaterialStateProperty.resolveWith((states) => Colors.grey[800]),
            backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.grey[900]),
            elevation: MaterialStateProperty.resolveWith<double>((states) => 8.0),
            shape: MaterialStateProperty.resolveWith((states) => RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(80))))
          ),
          onPressed: function,
          child: AnimatedSwitcher(
            duration: Duration(milliseconds: 10000),
            child: stopped
                ? Icon(
                    Icons.play_arrow,
                    color: Colors.green[800],
                    size: 80,
                  )
                : Icon(
                    Icons.stop,
                    color: Colors.redAccent[700],
                    size: 80,
                  ),
          ),
        )
    );
  }
}
