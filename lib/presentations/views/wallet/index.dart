import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gaza_go/platform/controllers/wallet_master_controller.dart';
import 'package:gaza_go/presentations/components/default_container.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/views/wallet/go_wallet.dart';
import 'package:gaza_go/presentations/views/wallet/staika_wallet.dart';
import 'package:get/get.dart';

class WalletHome extends StatelessWidget {
  const WalletHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    WalletMasterController walletMasterController = Get.find<WalletMasterController>();

    return DefaultContainer(
      backgroundColor: subBg01Color,
      titleText: '지갑',
      resizeToAvoidBottomInset: false,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 28.0.sp),
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
                indicatorPadding: EdgeInsets.only(bottom: 2),
                labelColor: Colors.white,
                unselectedLabelColor: const Color(0xFFA5A5A5),
                labelStyle: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                  height: 20 / 18,
                  letterSpacing: 0.5,
                ),
                tabs: [
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
              physics: NeverScrollableScrollPhysics(),
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
