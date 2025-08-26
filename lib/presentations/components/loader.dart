import 'package:flutter/material.dart';
import 'package:gaza_go/presentations/styles/colors.dart';

class Loader extends StatelessWidget {
  const Loader({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(.3),
      body: const Stack(
        children: [
          Center(
            child: CircularProgressIndicator(color: skyBlueColor), //무지성 돌돌이~
          ),
        ],
      ),
    );
  }
}
