import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gaza_go/platform/controllers/wallet_master_controller.dart';
import 'package:gaza_go/presentations/components/default_container.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/views/wallet/go_wallet.dart';
import 'package:gaza_go/presentations/views/wallet/staika_wallet.dart';
import 'package:get/get.dart';

class WalletHome extends StatelessWidget {
  const WalletHome({super.key});

  @override
  Widget build(BuildContext context) {
    WalletMasterController walletMasterController = Get.isRegistered<WalletMasterController>() ? Get.find<WalletMasterController>() : Get.put(WalletMasterController());

    return DefaultContainer(
      backgroundColor: subBg01Color,
      titleText: '지갑',
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 20.0.sp, left: 20.sp, right: 20.sp),
            child: Container(
              height: 54,
              decoration: BoxDecoration(
                color: const Color(0xff0E0E0F),
                border: Border.all(
                  color: Colors.black,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(50),
              ),
              child: TabBar(
                controller: walletMasterController.tabController,
                padding: EdgeInsets.symmetric(horizontal: 6.sp, vertical: 5.sp),
                indicator: BoxDecoration(
                  color: popupBgColor,
                  borderRadius: BorderRadius.circular(60),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black,
                      offset: Offset(2, 2),
                      blurRadius: 0.0,
                      spreadRadius: 0.0,
                    ),
                  ],
                ),
                indicatorPadding: const EdgeInsets.only(bottom: 2),
                labelColor: Colors.white,
                unselectedLabelColor: const Color(0xFFA5A5A5),
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                  height: 20 / 18,
                  letterSpacing: 0.5,
                ),
                dividerColor: Colors.transparent,
                indicatorSize: TabBarIndicatorSize.tab,
                tabs: const [
                  Tab(
                    text: 'GO 지갑',
                  ),
                  Tab(
                    text: 'Staika 지갑',
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              physics: const NeverScrollableScrollPhysics(),
              controller: walletMasterController.tabController,
              children: const [
                GoWallet(),
                StaikaWallet(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
