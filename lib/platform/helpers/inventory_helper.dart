import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gaza_go/presentations/styles/colors.dart';

Color getItemGradeColor(String itemGrade) {
  switch (itemGrade) {
    case 'POOR':
      return gradePoorColor;
    case 'COMMON':
      return gradeCommonColor;
    case 'UNCOMMON':
      return gradeUncommonColor;
    case 'RARE':
      return gradeRareColor;
    case 'EPIC':
      return gradeEpicColor;
    case 'LEGEND':
      return gradeLegendColor;
  }
  return Colors.white;
}
