import 'package:flutter/material.dart';
import 'package:gaza_go/platform/controllers/admob_rewarded_interstitial_controller.dart';
import 'package:get/get.dart';

class AdmobRewardedInterstitial extends StatelessWidget {
  const AdmobRewardedInterstitial({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AdmobRewardedInterstitialController controller = Get.put(AdmobRewardedInterstitialController());
    return MaterialApp(
      home: Builder(builder: (BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('AdMob Plugin example app'),
          ),
          body: SafeArea(
            child: Container(),
          ),
        );
      }),
    );
  }
}
