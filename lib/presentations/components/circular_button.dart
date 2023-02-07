import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CircularButton extends StatelessWidget {
  final double radius;
  final Color color;
  final VoidCallback? onTap;
  final Function? onTapDown;
  final Function? onTapUp;
  final Widget child;

  const CircularButton({
    Key? key,
    required this.radius,
    required this.color,
    this.onTap,
    this.onTapDown,
    this.onTapUp,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onTapDown: onTapDown != null ? (tapDownDetail) => onTapDown!(tapDownDetail) : null,
      onTapUp: onTapUp != null ? (tapUpDetail) => onTapUp!(tapUpDetail) : null,
      child: Container(
        width: radius,
        height: radius,
        padding: EdgeInsets.symmetric(vertical: 10.sp, horizontal: 12.sp),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          color: color,
          border: Border.all(
            width: 2,
            style: BorderStyle.solid,
            color: Colors.black,
          ),
          boxShadow: [
            BoxShadow(offset: Offset(2.sp, 4.sp), color: Colors.black),
          ],
        ),
        child: child,
      ),
    );
  }
}
