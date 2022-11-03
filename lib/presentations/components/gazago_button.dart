import 'package:flutter/material.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';

class GazagoButton extends StatelessWidget {
  String buttonText;
  VoidCallback onTap;
  Color textColor;
  Color buttonColor;

  GazagoButton({
    Key? key,
    required this.buttonText,
    required this.onTap,
    this.textColor = Colors.black,
    this.buttonColor = const Color(0xFF0EE6F3),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        margin: EdgeInsets.only(bottom: 3),
        child: Ink(
          decoration: BoxDecoration(
            color: buttonColor,
            border: Border.all(width: 2, color: Colors.black),
            borderRadius: BorderRadius.circular(8),
            boxShadow: const [
              BoxShadow(
                color: Colors.black,
                offset: Offset(0, 3),
              )
            ],
          ),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
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
