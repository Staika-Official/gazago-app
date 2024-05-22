import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';

class GazagoSnackbar extends StatelessWidget {
  final String message;

  const GazagoSnackbar({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return SnackBar(
      content: StyledText(
        message,
        fontSize: 18,
        lineHeight: 18,
        fontWeight: 500,
      ),
      padding: EdgeInsets.all(12.sp),
      margin: EdgeInsets.symmetric(horizontal: 40.sp),
      backgroundColor: const Color.fromRGBO(0, 0, 0, 0.9),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.sp),
      ),
    );
  }
}
