import 'package:flutter/material.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';

class BetaTag extends StatelessWidget {
  const BetaTag({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 8),
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
      decoration: BoxDecoration(
        color: skyBlueColor,
        borderRadius: BorderRadius.circular(9),
      ),
      child: const StyledText(
        'Beta',
        fontSize: 12,
        fontWeight: 600,
        color: Colors.black,
        letterSpacing: -0.1,
      ),
    );
  }
}
