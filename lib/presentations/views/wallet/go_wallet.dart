import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/platform/controllers/wallet_go_controller.dart';
import 'package:gaza_go/platform/controllers/wallet_master_controller.dart';
import 'package:gaza_go/platform/models/wallet_assets_button_model.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:gaza_go/presentations/views/wallet/go_asset_item_coin.dart';
import 'package:get/get.dart';

class GoWallet extends StatelessWidget {
  const GoWallet({Key? key}) : super(key: key);

  List<Widget> renderAssetsList(WalletMasterController walletMasterController, GoWalletController goWalletController) {
    return walletMasterController.spendingTokenUiList
        .map(
          (asset) => Padding(
            padding: EdgeInsets.only(top: 14.sp, left: 21.sp, right: 21.sp),
            child: GoAssetItemCoin(
              onTap: () =>
                  walletMasterController.moveToWalletDetail(asset: asset, walletType: WalletType.inventory, assetType: asset.name!.toUpperCase() == 'TAIKA' ? AssetType.token : AssetType.coin),
              asset: asset,
              actions: asset.name!.toUpperCase() == 'TAIKA'
                  ? [
                      // WalletAssetsButtonModel(
                      //   buttonText: 'TIK 충전하기',
                      //   onTapButton: () => goWalletController.showProductDialog(),
                      // ),
                      WalletAssetsButtonModel(
                        buttonText: 'STIK으로 교환하기',
                        onTapButton: () => goWalletController.showProductStikDialog(asset.name!.toUpperCase()),
                      ),
                    ]
                  : [
                      // WalletAssetsButtonModel(
                      //   buttonText: 'TIK으로 교환하기',
                      //   onTapButton: () => goWalletController.showProductStikDialog(asset.name!.toUpperCase()),
                      // ),
                      WalletAssetsButtonModel(
                        buttonText: 'Staika 지갑으로 송금하기',
                        onTapButton: () => goWalletController.checkUserVerified(goWalletController.stikSwapWallet),
                      ),
                    ],
              showPrice: false,
            ),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    WalletMasterController controller = Get.find();
    GoWalletController goWalletController = Get.put(GoWalletController());
    // StaikaWalletController staikaController = Get.put(StaikaWalletController());
    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        backgroundColor: subBg01Color,
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
              maxHeight: double.infinity,
            ),
            child: IntrinsicHeight(
              child: Obx(() {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // GazagoButton(buttonText: '광고로드', onTap: ()=> controller.loadRewardedAd()),
                    SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: EdgeInsets.only(left: 25.sp, right: 33.sp),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            StyledText(
                              '디지털 자산',
                              fontSize: 16,
                              fontWeight: 600,
                              lineHeight: 20,
                              letterSpacing: -0.5,
                            ),
                          ],
                        ),
                      ),
                    ),
                    ...renderAssetsList(controller, goWalletController),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(left: 25.sp, right: 33.sp, top: 28.sp),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          StyledText(
                            '디지털 자산 사용',
                            fontSize: 16,
                            fontWeight: 500,
                            lineHeight: 20,
                            letterSpacing: -0.5,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 12.sp, left: 21.sp, right: 21.sp),
                      child: Ink(
                        decoration: BoxDecoration(
                          color: subBg02Color,
                          border: Border.all(width: 2.sp, color: Colors.black),
                          borderRadius: BorderRadius.circular(12.sp),
                        ),
                        child: InkWell(
                          onTap: () => controller.onClickMoveToTaikaPay(),
                          borderRadius: BorderRadius.circular(12.sp),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                  top: 20.sp,
                                  left: 16.sp,
                                  right: 16.sp,
                                  bottom: 20.sp,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    CircleAvatar(
                                      radius: 30.sp,
                                      foregroundImage: Image.asset('assets/images/wallet/ico_coupon.png').image,
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 16.0.sp),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const StyledText(
                                              'TIK 사용하기',
                                              fontSize: 14,
                                              lineHeight: 14,
                                              fontWeight: 600,
                                              color: deepGrayColor,
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(top: 2.0.sp),
                                              child: const StyledText(
                                                'TIK으로 기프티콘 교환',
                                                fontSize: 16,
                                                lineHeight: 24,
                                                fontWeight: 500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(top: 20.sp, bottom: 20.0.sp, left: 20.sp, right: 20.sp),
                        child: const Align(
                          alignment: Alignment.bottomCenter,
                          child: StyledText('· GO 지갑은 가자고 내에서 TIK과 STIK을 관리하는 지갑입니다.', fontWeight: 500, fontSize: 10, letterSpacing: -.1, color: deepGrayColor, textAlign: TextAlign.center),
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        ),
      );
    });
  }
}
