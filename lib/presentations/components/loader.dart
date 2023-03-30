import 'package:flutter/material.dart';

class Loader extends StatelessWidget {
  const Loader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(.3),
      body: Stack(
        children: const [
          Center(
            child: CircularProgressIndicator(), //무지성 돌돌이~
          ),
        ],
      ),
    );
  }
}
