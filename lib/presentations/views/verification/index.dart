import 'package:flutter/material.dart';
import 'package:gaza_go/presentations/components/default_container.dart';

class Verification extends StatelessWidget {
  const Verification({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultContainer(
      child: Center(
        child: Text('본인 인증'),
      ),
    );
  }
}
