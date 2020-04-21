

import 'package:plank/widgets/optional.dart';

TextSpan spanned(String text, {@required String separator, @required TextStyle style}) {
  final parts = text.split(separator);
  assert(parts.length == 2);
  return TextSpan(
    text: '${parts.first.toUpperCase()}$separator',
    style: style,
    children: <TextSpan>[
      TextSpan(
        text: parts.last,
        style: style.apply(
          color: Colors.white.withOpacity(style.color.opacity < 0.7 ? style.color.opacity : 0.7),
          fontSizeFactor: 0.9,
          fontWeightDelta: -5
        )
      )
    ]
  );
}

