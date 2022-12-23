import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';

class BottomSheetAlert extends StatelessWidget {
  final String? title;
  final String? contentText;
  final Widget? contentWidget;
  final List<Widget> actions;
  final bool? isDangerTitle;
  final bool? isNonePaddingOuter;

  const BottomSheetAlert({Key? key, this.title, this.contentText, this.contentWidget, this.isDangerTitle, this.isNonePaddingOuter, required this.actions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: popupBgColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12.sp),
          topRight: Radius.circular(12.sp),
        ),
      ),
      child: Padding(
        padding: isNonePaddingOuter! ? EdgeInsets.all(0)  : EdgeInsets.only(top: 30.0.sp, left: 20.sp, right: 20.sp, bottom: 40.sp),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (title != null)
              Padding(
                padding: EdgeInsets.only(top: 8.0.sp),
                child: StyledText(
                  title!,
                  fontSize: 22,
                  lineHeight: 24,
                  fontWeight: 500,
                  letterSpacing: .2,
                  color: isDangerTitle! ? dangerColor : Colors.white,
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
                    color: lightGrayColor,
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
