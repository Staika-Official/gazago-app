import 'package:flutter/material.dart';

class BaseCard extends StatelessWidget {
  const BaseCard({
    super.key,
    this.child,
    this.backgroundColor = const Color(0xff222222),
    this.borderRadius = 0,
    this.padding,
  });

  final Widget? child;
  final Color backgroundColor;
  final double borderRadius;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        color: backgroundColor,
      ),
      child: child,
    );
  }
}
