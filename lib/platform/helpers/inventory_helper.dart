import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/icons.dart';
import 'package:gaza_go/theme/theme.g.dart';

Color getItemGradeColor(String itemGrade) {
  switch (itemGrade) {
    case 'POOR':
      return AppColorData.regular().colorTextTertiary;
    case 'COMMON':
      return AppColorData.regular().colorPointBluegray;
    case 'UNCOMMON':
      return AppColorData.regular().colorPointGreen;
    case 'RARE':
      return AppColorData.regular().colorPointCyan;
    case 'EPIC':
      return AppColorData.regular().colorPointPurple;
    case 'LEGEND':
      return AppColorData.regular().colorPointYellow;
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
