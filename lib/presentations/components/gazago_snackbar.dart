import 'package:flutter/material.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';

class GazagoSnackbar extends StatelessWidget {
  String message;

  GazagoSnackbar({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SnackBar(
      content: StyledText(
        message,
        fontSize: 18,
        lineHeight: 18,
        fontWeight: 500,
      ),
      padding: EdgeInsets.all(12),
      margin: EdgeInsets.symmetric(horizontal: 40),
      backgroundColor: Color.fromRGBO(0, 0, 0, 0.9),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
