import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gaza_go/constants/config.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/platform/controllers/wallet_staika_controller.dart';
import 'package:gaza_go/platform/stores/hive_store.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/icons.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:gaza_go/presentations/views/wallet/staika_asset_item_coin.dart';
import 'package:get/get.dart';

class StaikaWallet extends StatelessWidget {
  const StaikaWallet({Key? key}) : super(key: key);

  List<Widget> renderCoinAssetList(StaikaWalletController controller) {
    return controller.coinAssetList
        .map(
          (asset) => Padding(
            padding: EdgeInsets.only(top: 14.sp, left: 21.sp, right: 21.sp),
            child: StaikaAssetItemCoin(
              asset: asset,
              onTapButton: asset.symbol.toUpperCase() == 'STIK' ? () => controller.moveToSendToGoWallet() : null,
              buttonText: asset.symbol.toUpperCase() == 'STIK' ? 'GO지갑으로 보내기' : '',
              showPrice: false,
            ),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    StaikaWalletController controller = Get.put(StaikaWalletController());

    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        backgroundColor: subBg01Color,
        resizeToAvoidBottomInset: false,
        body: Obx(() {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
                maxHeight: double.infinity,
              ),
              child: IntrinsicHeight(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 28.0.sp),
                      child: CircleAvatar(
                        radius: 23.sp,
                        foregroundImage: HiveStore.loadString(key: HiveKey.profileImageUrl.name) != null && HiveStore.loadString(key: HiveKey.profileImageUrl.name) != ''
                            ? CachedNetworkImageProvider(
                                HiveStore.loadString(key: HiveKey.profileImageUrl.name)!,
                                headers: imageNetworkHeader,
                              )
                            : Image.asset(
                                'assets/images/ic_launcher.png',
                                width: 23.sp,
                              ).image,
                      ),
                    ),
                    if (controller.userWalletAddress.value != '')
                      Padding(
                        padding: EdgeInsets.only(top: 10.0.sp),
                        child: SizedBox(
                          child: Container(
                            decoration: BoxDecoration(
                              color: popupBgColor,
                              borderRadius: BorderRadius.all(
                                Radius.circular(30.sp),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 11.0.sp, horizontal: 22.0.sp),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w500,
                                        height: (16 / 14).sp,
                                        letterSpacing: -0.2,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: controller.userWalletAddress.value.substring(0, 4),
                                        ),
                                        const TextSpan(
                                          text: '...',
                                        ),
                                        TextSpan(
                                          text: controller.userWalletAddress.value.substring(controller.userWalletAddress.value.length - 4),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 12.0.sp),
                                    child: InkWell(
                                      child: iconCopy,
                                      onTap: () => controller.handleCopyWalletAddress(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    Padding(
                      padding: EdgeInsets.only(top: 12.0.sp),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () => controller.onOpenSolScanWallet(),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                StyledText(
                                  '거래내역',
                                  fontSize: 14,
                                  lineHeight: 15,
                                  fontWeight: 500,
                                  color: lightGrayColor,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 3.0),
                                  child: iconTransactionHistory,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 26.0.sp, left: 26.0.sp, right: 26.0.sp),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const StyledText(
                            '디지털 자산',
                            fontWeight: 500,
                            fontSize: 16,
                            lineHeight: 18,
                          ),
                          GestureDetector(
                            onTap: () {
                              controller.setSwitchValue(!controller.isKRW.value);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Spin(
                                  spins: 0.5,
                                  duration: const Duration(milliseconds: 500),
                                  animate: true,
                                  manualTrigger: true,
                                  controller: (con) {
                                    print(con);
                                    controller.switchAnimation.value = con;
                                  },
                                  child: SizedBox(
                                    height: 14,
                                    child: iconSwitch,
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(left: 3),
                                  child: Text(
                                    controller.isKRW.value ? 'KRW' : 'USD',
                                    textAlign: TextAlign.end,
                                    style: const TextStyle(fontSize: 12, color: Color.fromARGB(255, 165, 165, 165), fontWeight: FontWeight.w500),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (controller.coinAssetList.isNotEmpty) ...renderCoinAssetList(controller),
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: EdgeInsets.only(top: 10.sp, bottom: 20.0.sp),
                          child: StyledText(
                            '· Staika 지갑은 블록체인 상에 기록되는 블록체인 지갑입니다.',
                            fontWeight: 500,
                            fontSize: 10,
                            letterSpacing: -.1,
                            color: deepGrayColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      );
    });
  }
}
