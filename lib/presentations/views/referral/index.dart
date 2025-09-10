import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gaza_go/platform/controllers/referral_controller.dart';
import 'package:gaza_go/presentations/components/default_container.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/views/referral/components/redeem_code_button.dart';
import 'package:gaza_go/presentations/views/referral/components/referral_code_section.dart';
import 'package:gaza_go/presentations/views/referral/components/referral_history_list.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';

class ReferralPage extends StatefulWidget {
  const ReferralPage({super.key});

  @override
  State<ReferralPage> createState() => _ReferralPageState();
}

class _ReferralPageState extends State<ReferralPage> {
  @override
  void initState() {
    Get.put(ReferralController()).init();
    super.initState();
  }

  @override
  void dispose() {
    Get.delete<ReferralController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultContainer(
      titleText: 'referral'.tr(),
      backgroundColor: subBg01Color,
      headerBackgroundColor: mainBg03Color,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.5.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 18.h),
            const ReferralCodeSection(),
            SizedBox(height: 18.h),
            const RedeemCodeButton(),
            SizedBox(height: 32.h),
            const ReferralHistoryList(),
          ],
        ),
      ),
    );
  }
}
