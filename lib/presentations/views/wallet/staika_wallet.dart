import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gaza_go/constants/routes.dart';
import 'package:gaza_go/platform/controllers/wallet_staika_controller.dart';
import 'package:gaza_go/presentations/components/view_solscan_button.dart';
import 'package:gaza_go/presentations/components/wallet/nft_asset_item.dart';
import 'package:gaza_go/presentations/components/wallet/staika_asset_item_coin.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/icons.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:gaza_go/theme/theme.g.dart';
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
              onTapButton: asset.symbol.toUpperCase() == 'STIK' ? () => controller.stikSwapWallet() : null,
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
                      padding: EdgeInsets.only(top: 15.0.sp),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0.sp),
                        child: SizedBox(
                            height: 50.sp,
                            child: Center(
                                child: FittedBox(
                              child: StyledText(
                                controller.userEmail.value,
                                fontWeight: 500,
                                fontSize: 16,
                              ),
                            ))),
                      ),
                    ),
                    // 프로필 사진
                    // Padding(
                    //   padding: EdgeInsets.only(top: 28.0.sp),
                    //   child: CircleAvatar(
                    //     radius: 23.sp,
                    //     foregroundImage: HiveStore.loadString(key: HiveKey.profileImageUrl.name) != null && HiveStore.loadString(key: HiveKey.profileImageUrl.name) != ''
                    //         ? CachedNetworkImageProvider(
                    //             HiveStore.loadString(key: HiveKey.profileImageUrl.name)!,
                    //             headers: imageNetworkHeader,
                    //           )
                    //         : Image.asset(
                    //             'assets/images/ic_launcher.png',
                    //             width: 23.sp,
                    //           ).image,
                    //   ),
                    // ),

                    if (controller.userWalletAddress.value != null && controller.userWalletAddress.value != '')
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
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      style: AppTextStyleData.regular().koBodyMediumLg.copyWith(
                                            color: AppColorData.regular().colorTextSecondary,
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
                                    padding: EdgeInsets.only(left: 4.0.sp, top: 3.sp),
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
                          ViewSolscanButton(onTap: () => controller.onOpenSolScanWallet()),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 26.0.sp, left: 26.0.sp, right: 26.0.sp),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            '디지털 자산',
                            style: AppTextStyleData.regular().koBodyMediumXl.copyWith(
                                  color: AppColorData.regular().colorTextPrimary,
                                ),
                          ),
                          GestureDetector(
                            onTap: () {
                              controller.setSwitchValue(!controller.isKRW.value);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(right: 5),
                                  child: Text(
                                    controller.isKRW.value ? 'KRW' : 'USD',
                                    textAlign: TextAlign.end,
                                    style: AppTextStyleData.regular().koBodyMediumSm.copyWith(
                                          color: AppColorData.regular().colorTextTertiary,
                                        ),
                                  ),
                                ),
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
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    controller.isFetching.value
                        ? Padding(
                            padding: EdgeInsets.only(top: 100.sp),
                            child: Center(child: SizedBox.square(dimension: 40, child: CircularProgressIndicator())),
                          )
                        : controller.coinAssetList.isNotEmpty && controller.coinAssetList != null
                            ? Column(
                                children: [
                                  ...renderCoinAssetList(controller),
                                  NftAssetItem(
                                    onTap: () => Get.toNamed(Routes.walletNftList, arguments: {'prevRoute': 'STAIKA_WALLET'}),
                                  ),
                                ],
                              )
                            : Container(),
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: EdgeInsets.only(top: 20.sp, bottom: 52.0.sp, left: 20.sp, right: 20.sp),
                          child: Text(
                            'Staika 지갑은 블록체인 지갑이에요.',
                            style: AppTextStyleData.regular().koCaptionMediumMd.copyWith(
                                  color: AppColorData.regular().colorTextTertiary,
                                ),
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
