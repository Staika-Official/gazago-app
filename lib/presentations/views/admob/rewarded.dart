import 'package:flutter/material.dart';
import 'package:gaza_go/platform/controllers/admob_rewarded_controller.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:get/get.dart';

class AdmobRewarded extends StatelessWidget {
  const AdmobRewarded({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AdmobRewardedController controller = Get.put(AdmobRewardedController());
    return MaterialApp(
      home: Builder(builder: (BuildContext context) {
        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(38.0),
              child: InkWell(
                onTap: () => controller.showRewardedAd(),
                child: Container(
                  color: mainBg01Color,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: StyledText('광고 보기'),
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
