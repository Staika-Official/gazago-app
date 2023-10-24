import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WalletAssetsButtonModel {
  String buttonText;
  VoidCallback? onTapButton;

  WalletAssetsButtonModel({
    required this.buttonText,
    this.onTapButton,
  });


}
