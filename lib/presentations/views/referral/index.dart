import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gaza_go/platform/controllers/referral_controller.dart';
import 'package:gaza_go/presentations/components/default_container.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:get/get.dart' hide Trans;

class ReferralPage extends StatelessWidget {
  const ReferralPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ReferralController());
    return DefaultContainer(
      titleText: 'referral'.tr(),
      backgroundColor: subBg01Color,
      headerBackgroundColor: const Color(0xFF23232D),
      child: Text('ssss'),
    );
  }
}
