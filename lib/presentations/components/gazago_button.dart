import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';

class GazagoButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback? onTap;
  final Color textColor;
  final Color buttonColor;
  final Color borderColor;
  final bool disableButton;

  const GazagoButton({
    super.key,
    required this.buttonText,
    this.onTap,
    this.textColor = Colors.black,
    this.borderColor = Colors.black,
    this.buttonColor = skyBlueColor,
    this.disableButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: buttonColor,
        border: Border.all(
            width: 2.sp,
            color: borderColor,
            strokeAlign: BorderSide.strokeAlignOutside),
        borderRadius: BorderRadius.circular(8.sp),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.black,
        //     offset: Offset(0, 4.sp),
        //   )
        // ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8.sp),
        child: InkWell(
          onTap: disableButton ? null : onTap,
          borderRadius: BorderRadius.circular(8.sp),
          child: Center(
            child: disableButton
                ? SizedBox(
                    height: 18.sp,
                    width: 18.sp,
                    child: CircularProgressIndicator(
                      color: textColor,
                    ),
                  )
                : StyledText(
                    buttonText,
                    fontSize: 18,
                    lineHeight: 18,
                    fontWeight: 600,
                    color: textColor,
                  ),
          ),
        ),
      ),
    );
  }
}
