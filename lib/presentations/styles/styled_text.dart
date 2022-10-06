import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StyledText extends StatelessWidget {
  String text;
  double fontSize;
  Color color;
  int fontWeight;
  double lineHeight;
  StyledText(this.text, {Key? key, this.fontSize = 12, this.lineHeight = 12, this.color = Colors.white, this.fontWeight = 400}) : super(key: key);

  Rx<FontWeight> get getFontWeight {
    switch (fontWeight) {
      case 100:
        return Rx(FontWeight.w100);
      case 200:
        return Rx(FontWeight.w200);
      case 300:
        return Rx(FontWeight.w300);
      case 400:
        return Rx(FontWeight.w400);
      case 500:
        return Rx(FontWeight.w500);
      case 600:
        return Rx(FontWeight.w600);
      case 700:
        return Rx(FontWeight.w700);
      case 800:
        return Rx(FontWeight.w800);
    }
    return Rx(FontWeight.w400);
  }

  double get getLineHeight {
    return lineHeight / fontSize;
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(fontSize: fontSize, color: color, fontWeight: getFontWeight.value, height: getLineHeight),
    );
  }
}
