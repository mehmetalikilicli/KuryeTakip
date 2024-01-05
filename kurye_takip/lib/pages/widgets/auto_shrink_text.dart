import 'package:flutter/material.dart';

class AutoShrinkText extends StatelessWidget {
  final String text;
  final double fontSize;

  const AutoShrinkText({
    Key? key,
    required this.text,
    required this.fontSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final textPainter = TextPainter(
          text: TextSpan(text: text, style: TextStyle(fontSize: fontSize)),
          maxLines: 1,
          textDirection: TextDirection.ltr,
        )..layout(maxWidth: constraints.maxWidth);

        if (textPainter.didExceedMaxLines) {
          final shrinkedFontSize = fontSize * constraints.maxWidth / textPainter.width;
          return Text(
            text,
            style: TextStyle(fontSize: shrinkedFontSize),
            overflow: TextOverflow.ellipsis,
          );
        } else {
          return Text(
            text,
            style: TextStyle(fontSize: fontSize),
            overflow: TextOverflow.ellipsis,
          );
        }
      },
    );
  }
}
