import 'package:flutter/material.dart';
import 'package:step_go/presentations/components/default_header.dart';

class DefaultContainer extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  final bool disableSafeArea;
  final Widget? customHeader;

  //default header settings
  final bool isLeadingShow;
  final Widget? trailingChild;
  final String? titleText;
  final Function? onBackButtonTap;
  final Color? headerBackgroundColor;

  const DefaultContainer({
    Key? key,
    required this.child,
    this.backgroundColor = Colors.white,
    this.disableSafeArea = false,
    this.customHeader,
    this.isLeadingShow = true,
    this.trailingChild,
    this.titleText,
    this.headerBackgroundColor,
    this.onBackButtonTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: headerBackgroundColor ?? backgroundColor,
        elevation: 0,
        titleSpacing: 0,
        title: customHeader ??
            DefaultHeader(
              isLeadingShow: isLeadingShow,
              trailingChild: trailingChild,
              titleText: titleText,
              onBackButtonTap: onBackButtonTap,
            ),
      ),
      body: disableSafeArea
          ? Container(
              child: child,
            )
          : SafeArea(
              child: child,
            ),
    );
  }
}
