import 'package:flutter/material.dart';

class StyledText extends StatelessWidget {
  final String text;
  final String fontFamily;
  final double fontSize;
  final Color color;
  final Color backgroundColor;
  final int fontWeight;
  final double lineHeight;
  final double letterSpacing;
  const StyledText(
    this.text, {
    Key? key,
    this.fontFamily = 'Pretendard',
    this.fontSize = 12,
    this.lineHeight = 12,
    this.color = Colors.white,
    this.fontWeight = 400,
    this.backgroundColor = Colors.transparent,
    this.letterSpacing = 1,
  }) : super(key: key);

  FontWeight get getFontWeight {
    FontWeight _fontWeight = FontWeight.w400;
    switch (fontWeight) {
      case 100:
        _fontWeight = FontWeight.w100;
        break;
      case 200:
        _fontWeight = FontWeight.w200;
        break;
      case 300:
        _fontWeight = FontWeight.w300;
        break;
      case 400:
        _fontWeight = FontWeight.w400;
        break;
      case 500:
        _fontWeight = FontWeight.w500;
        break;
      case 600:
        _fontWeight = FontWeight.w600;
        break;
      case 700:
        _fontWeight = FontWeight.w700;
        break;
      case 800:
        _fontWeight = FontWeight.w800;
        break;
    }
    return _fontWeight;
  }

  double get getLineHeight {
    return lineHeight / fontSize;
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        fontFamily: fontFamily,
        color: color,
        fontWeight: getFontWeight,
        height: getLineHeight,
        backgroundColor: backgroundColor,
        letterSpacing: letterSpacing,
      ),
    );
  }
}
