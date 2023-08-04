import 'package:flutter/material.dart';
import 'package:gaza_go/presentations/components/default_container.dart';
import 'package:gaza_go/presentations/components/fair_play_content.dart';

class FairPlayView extends StatelessWidget {
  const FairPlayView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultContainer(
      titleText: '경고 & 퇴장 카드 규정',
      child: FairPlayContent(),
    );
  }
}
