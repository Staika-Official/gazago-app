import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StyledText extends StatelessWidget {
  final String text;
  final String fontFamily;
  final double fontSize;
  final Color color;
  final Color backgroundColor;
  final int fontWeight;
  final double lineHeight;
  final double letterSpacing;
  final TextAlign textAlign;
  final bool overflowEllipsis;
  final bool softWrap;

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
    this.textAlign = TextAlign.start,
    this.overflowEllipsis = false,
    this.softWrap = true,
  }) : super(key: key);

  FontWeight get getFontWeight {
    FontWeight fw = FontWeight.w400;
    switch (fontWeight) {
      case 100:
        fw = FontWeight.w100;
        break;
      case 200:
        fw = FontWeight.w200;
        break;
      case 300:
        fw = FontWeight.w300;
        break;
      case 400:
        fw = FontWeight.w400;
        break;
      case 500:
        fw = FontWeight.w500;
        break;
      case 600:
        fw = FontWeight.w600;
        break;
      case 700:
        fw = FontWeight.w700;
        break;
      case 800:
        fw = FontWeight.w800;
        break;
    }
    return fw;
  }

  double get getLineHeight {
    return lineHeight / fontSize;
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      softWrap: softWrap,
      style: TextStyle(
        fontSize: fontSize.sp,
        fontFamily: fontFamily,
        color: color,
        fontWeight: getFontWeight,
        height: getLineHeight,
        backgroundColor: backgroundColor,
        letterSpacing: letterSpacing.sp,
        overflow: overflowEllipsis ? TextOverflow.ellipsis : TextOverflow.visible,
      ),
    );
  }
}
