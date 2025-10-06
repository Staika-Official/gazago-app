import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AutoScaleText extends StatelessWidget {
  final String text;
  final Color color;
  final double baseFontSize;
  final FontWeight fontWeight;
  final double letterSpacing;
  final int maxLines;
  final TextOverflow overflow;
  final double minFontSizeFactor;

  const AutoScaleText({
    super.key,
    required this.text,
    required this.color,
    required this.baseFontSize,
    required this.fontWeight,
    this.letterSpacing = 0,
    this.maxLines = 1,
    this.overflow = TextOverflow.ellipsis,
    this.minFontSizeFactor = 0.8, // Can reduce to 80% of original size
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Start with the base font size
        double fontSize = baseFontSize;
        final minFontSize = baseFontSize * minFontSizeFactor;

        // Create a text painter to measure text
        TextPainter textPainter;
        TextStyle style;

        do {
          style = TextStyle(
            color: color,
            fontSize: fontSize,
            fontWeight: fontWeight,
            letterSpacing: letterSpacing,
            height: 1.0,
          );

          textPainter = TextPainter(
            text: TextSpan(text: text, style: style),
            textDirection: TextDirection.ltr,
            maxLines: maxLines,
          );

          textPainter.layout(maxWidth: constraints.maxWidth);

          // If text fits or we've reached minimum size, break
          if (!textPainter.didExceedMaxLines || fontSize <= minFontSize) {
            break;
          }

          // Reduce font size by 0.5sp steps
          fontSize -= 0.5.sp;
        } while (fontSize > minFontSize);

        return Text(
          text,
          style: style,
          maxLines: maxLines,
          overflow: overflow,
        );
      },
    );
  }
}
