import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/icons.dart';

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
  return gradePoorColor;
}

SvgPicture getItemGradeIcon(String itemGrade) {
  switch (itemGrade) {
    case 'POOR':
      return iconGradePoor;
    case 'COMMON':
      return iconGradeCommon;
    case 'UNCOMMON':
      return iconGradeUncommon;
    case 'RARE':
      return iconGradeRare;
    case 'EPIC':
      return iconGradeEpic;
    case 'LEGEND':
      return iconGradeLegend;
  }
  return iconGradePoor;
}

Widget getItemGradeCircleIcon(String itemGrade) {
  switch (itemGrade) {
    case 'POOR':
      return iconGradeCirclePoor;
    case 'COMMON':
      return iconGradeCircleCommon;
    case 'UNCOMMON':
      return iconGradeCircleUncommon;
    case 'RARE':
      return iconGradeCircleRare;
    case 'EPIC':
      return iconGradeCircleEpic;
    case 'LEGEND':
      return iconGradeCircleLegend;
  }
  return iconGradeCirclePoor;
}
