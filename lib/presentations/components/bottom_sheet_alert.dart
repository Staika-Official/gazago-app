import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
        padding: EdgeInsets.only(top: 30.0.sp, left: 20.sp, right: 20.sp, bottom: 40.sp),
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
                  padding: EdgeInsets.only(top: 12.0.sp, bottom: 30.sp),
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
