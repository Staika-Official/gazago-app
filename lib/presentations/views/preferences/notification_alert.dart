import 'package:flutter/material.dart';
import 'package:gaza_go/presentations/components/default_container.dart';

class NotificationAlert extends StatelessWidget {
  const NotificationAlert({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const DefaultContainer(
      child: Center(
        child: Text('알림'),
      ),
    );
  }
}
