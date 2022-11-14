import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gaza_go/presentations/styles/icons.dart';

Color getLoginButtonColor(String loginType) {
  switch (loginType) {
    case 'apple':
      return const Color(0xFF1E1E1C);
    case 'google':
      return Colors.white;
  }
  return const Color(0xFFffffff);
}

String getLoginButtonText(String loginType) {
  switch (loginType) {
    case 'apple':
      return 'Apple';
    case 'google':
      return 'Google';
  }
  return '이메일';
}

SvgPicture getLoginButtonIcon(String loginType) {
  switch (loginType) {
    case 'apple':
      return iconLoginApple;
    case 'google':
      return iconLoginGoogle;
  }
  return iconLoginGoogle;
}
