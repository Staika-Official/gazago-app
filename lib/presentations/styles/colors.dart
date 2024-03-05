import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// 각 색상 변수 정의
late Color pointPink;
late Color textPrimary;

class FigmaTokenService {
  static Future<Map<String, dynamic>> loadFigmaToken() async {
    // Figma에서 내보낸 JSON 파일 로드
    String jsonString = await rootBundle.loadString('assets/design/tokens.json');
    // JSON 파싱
    Map<String, dynamic> figmaToken = json.decode(jsonString);
    return figmaToken;
  }
}
String resolveColorToken(Map<String, dynamic> json, String token) {
  // 토큰을 해석하여 색상 값 가져오기
  String colorValue = '';
  if (token.startsWith('{') && token.endsWith('}')) {
    List<String> tokens = token.substring(1, token.length - 1).split('.');
    if (tokens.length == 3 && tokens[0] == 'color') {
      String category = tokens[1];
      String colorName = tokens[2];
      if (json.containsKey('primitive/v1') && json['primitive/v1']['color'][category] != null &&
          json['primitive/v1']['color'][category][colorName] != null) {
        colorValue = json['primitive/v1']['color'][category][colorName]['value'];
      }
    }
  }
  return colorValue;
}

Color parseColor(String colorValue) {
  // # 제거 후 Color로 변환
  String hex = colorValue.replaceAll('#', '');
  return Color(int.parse('0xFF$hex'));
}
Color getColorFromFigmaToken(Map<String, dynamic> figmaToken, String colorType, String colorKey) {
  String varColorType = figmaToken['sementic/v1']['color'][colorType][colorKey]['value'];

  print(parseColor(resolveColorToken(figmaToken, varColorType)));
  return parseColor(resolveColorToken(figmaToken, varColorType));
}




Future<void> initializeColors() async {
  // Figma design token 로드
  Map<String, dynamic> figmaToken = await FigmaTokenService.loadFigmaToken();

  // 각 색상 변수에 figmaToken에서 가져온 값 적용
  pointPink = getColorFromFigmaToken(figmaToken, 'point', 'pink');
  textPrimary = getColorFromFigmaToken(figmaToken, 'text', 'primary');

}
// Color(0xFF191921)
const Color mainBg01Color = Color(0xFF191921);
const Color mainBg02Color = Color(0xFF32333C);
const Color subBg01Color = Color(0xFF1D1D26);
const Color subBg02Color = Color(0xFF2A2B33);
const Color popupBgColor = Color(0xFF363841);
const Color lightGreenColor = Color(0xFFCDFF41);
const Color purpleColor = Color(0xFFB85DFF);
const Color lightPurpleColor = Color(0xFFB0A3FF);
const Color skyBlueColor = Color(0xFF0EE6F3);
const Color lightGrayColor = Color(0xFFBFBFBF);
const Color deepGrayColor = Color(0xFF8A8A8A);
// const Color pointPink = Color(0xFFFF74B7);
const Color numberedBoxGrayColor = Color(0xFF484A54);

const Color textRedColor = Color(0xffFF2525);
const Color textYellowColor = Color(0xffFBCB24);
const Color textGreenColor = Color(0xff18FF82);
const Color speedRedColor = Color(0xffFF2222);
const Color speedYellowColor = Color(0xffFACA24);
const Color speedGreenColor = Color(0xff0EF393);
const Color speedGrayColor = Color(0xff585858);
const Color speedBlackColor = Color(0xff1F2129);

const Color gaugeGrayColor = Color(0xFF606167);
const Color sliderGrayColor = Color(0xFF494954);

const Color gradePoorColor = Color(0xFF96A3A5);
const Color gradeCommonColor = Color(0xFFEEF4F4);
const Color gradeUncommonColor = Color(0xFF1CFFBB);
const Color gradeRareColor = Color(0xFF3EDCFF);
const Color gradeEpicColor = Color(0xFFB163FF);
const Color gradeLegendColor = Color(0xFFFCFF5C);

const Color deepBlackColor = Color(0xFF08080B);
const Color dangerColor = Color(0xFFFF4D4D);
const Color stikColor = Color(0xFFFF8A43);
const Color tikColor = Color(0xFFFF8FB4);
const Color bonusTikColor = Color(0xFFFFB6CE);
