import 'package:flutter_svg/svg.dart';
import 'package:gaza_go/presentations/styles/icons.dart';

SvgPicture getMypageLoginedButtonIcon(String loginType) {
  switch (loginType) {
    case 'APPLE':
      return iconApple;
    case 'GOOGLE':
      return iconGoogle;
  }
  return iconGoogle;
}
