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

String removeSerialNumberString(String nftName) {
  // 정규 표현식 패턴 생성
  RegExp regExp = RegExp(r"(.+)\s+#\d+");

  // 패턴에 맞는 첫 번째 문자열 추출
  Match? match = regExp.firstMatch(nftName);

  if (match != null) {
    return match.group(1)!;
  } else {
    return nftName;
  }
}

String extractSerialNumberString(String nftName) {
  // 정규 표현식 패턴 생성
  RegExp regExp = RegExp(r"#\d+");

  // 패턴에 맞는 첫 번째 문자열 추출
  Match? match = regExp.firstMatch(nftName);

  if (match != null) {
    return match.group(0)!;
  } else {
    return nftName;
  }
}
