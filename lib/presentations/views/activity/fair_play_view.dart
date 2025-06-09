import 'package:flutter/material.dart';
import 'package:gaza_go/presentations/components/default_container.dart';
import 'package:gaza_go/presentations/components/fair_play_content.dart';
import 'package:easy_localization/easy_localization.dart';

class FairPlayView extends StatelessWidget {
  const FairPlayView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultContainer(
      titleText: 'warning_ejection_rules'.tr(),
      child: FairPlayContent(),
    );
  }
}
