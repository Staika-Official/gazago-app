import 'package:flutter/material.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';

class BottomSheetAlert extends StatelessWidget {
  String title;
  String? contentText;
  Widget? contentWidget;
  List<Widget> actions;

  BottomSheetAlert({Key? key, required this.title, this.contentText, this.contentWidget, required this.actions}) : super(key: key);

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
        padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 20),
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
                    color: Color(0xffbfbfbf),
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
