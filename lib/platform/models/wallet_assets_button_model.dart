import 'package:flutter/cupertino.dart';

class WalletAssetsButtonModel {
  String buttonText;
  VoidCallback? onTapButton;

  WalletAssetsButtonModel({
    required this.buttonText,
    this.onTapButton,
  });
}
