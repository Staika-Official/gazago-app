import 'package:flutter/material.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';

class BottomSheetAlert extends StatelessWidget {
  final String title;
  final String? contentText;
  final Widget? contentWidget;
  final List<Widget> actions;

  const BottomSheetAlert({Key? key, required this.title, this.contentText, this.contentWidget, required this.actions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xff363841),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 30.0, left: 20, right: 20, bottom: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: StyledText(
                title,
                fontSize: 22,
                lineHeight: 24,
                fontWeight: 500,
                letterSpacing: .2,
              ),
            ),
            contentWidget ??
                Padding(
                  padding: const EdgeInsets.only(top: 12.0, bottom: 30),
                  child: StyledText(
                    contentText!,
                    fontSize: 18,
                    lineHeight: 24,
                    fontWeight: 500,
                    letterSpacing: .2,
                    color: const Color(0xffbfbfbf),
                    textAlign: TextAlign.center,
                  ),
                ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: actions,
            )
          ],
        ),
      ),
    );
  }
}
