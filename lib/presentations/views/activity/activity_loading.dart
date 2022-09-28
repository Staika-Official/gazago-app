import 'package:flutter/material.dart';
import 'package:gaza_go/presentations/components/default_container.dart';

class ActivityLoading extends StatelessWidget {
  const ActivityLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultContainer(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            Text('로딩중'),
          ],
        ),
      ),
    );
  }
}
