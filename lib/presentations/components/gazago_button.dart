import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';

class GazagoButton extends StatelessWidget {
  String buttonText;
  VoidCallback onTap;
  Color textColor;
  Color buttonColor;
  bool disableButton;

  GazagoButton({
    Key? key,
    required this.buttonText,
    required this.onTap,
    this.textColor = Colors.black,
    this.buttonColor = const Color(0xFF0EE6F3),
    this.disableButton = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(8.sp),
      child: Container(
        margin: EdgeInsets.only(bottom: 3.sp),
        child: Ink(
          decoration: BoxDecoration(
            color: buttonColor,
            border: Border.all(width: 2.sp, color: Colors.black),
            borderRadius: BorderRadius.circular(8.sp),
            boxShadow: [
              BoxShadow(
                color: Colors.black,
                offset: Offset(0, 3.sp),
              )
            ],
          ),
          child: InkWell(
            onTap: disableButton ? null : onTap,
            borderRadius: BorderRadius.circular(8.sp),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 12.0.sp),
              child: Center(
                child: StyledText(
                  buttonText,
                  fontSize: 18,
                  lineHeight: 18,
                  fontWeight: 600,
                  color: textColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
