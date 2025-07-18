import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/constants/routes.dart';
import 'package:gaza_go/platform/controllers/wallet_go_controller.dart';
import 'package:gaza_go/platform/controllers/wallet_master_controller.dart';
import 'package:gaza_go/platform/models/wallet_assets_button_model.dart';
import 'package:gaza_go/presentations/components/wallet/go_asset_item_coin.dart';
import 'package:gaza_go/presentations/components/wallet/nft_asset_item.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:gaza_go/theme/theme.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:get/get.dart' hide Trans;

class GoWallet extends StatelessWidget {
  const GoWallet({Key? key}) : super(key: key);

  List<Widget> renderAssetsList(WalletMasterController walletMasterController,
      GoWalletController goWalletController) {
    return walletMasterController.spendingTokenUiList
        .map(
          (asset) => Padding(
            padding: EdgeInsets.only(top: 14.sp, left: 21.sp, right: 21.sp),
            child: GoAssetItemCoin(
              onTap: () => walletMasterController.moveToWalletDetail(
                  asset: asset,
                  walletType: WalletType.inventory,
                  assetType: asset.name!.toUpperCase() == 'TAIKA'
                      ? AssetType.token
                      : AssetType.coin),
              asset: asset,
              actions: asset.name!.toUpperCase() == 'TAIKA'
                  ? [
                      // WalletAssetsButtonModel(
                      //   buttonText: 'charge_tik'.tr(),
                      //   onTapButton: () => goWalletController.showProductDialog(),
                      // ),
                      WalletAssetsButtonModel(
                        buttonText: 'buy_stik'.tr(),
                        onTapButton: () => goWalletController
                            .showProductStikDialog(asset.name!.toUpperCase()),
                      ),
                      // WalletAssetsButtonModel(
                      //   buttonText: 'exchange_gift_icon'.tr(),
                      //   onTapButton: () => walletMasterController.onClickMoveToTaikaPay(),
                      // ),
                    ]
                  : [
                      // WalletAssetsButtonModel(
                      //   buttonText: 'exchange_to_tik_1'.tr(),
                      //   onTapButton: () => goWalletController.showProductStikDialog(asset.name!.toUpperCase()),
                      // ),
                      WalletAssetsButtonModel(
                        buttonText: 'send_to_staika_wallet'.tr(),
                        onTapButton: () => goWalletController.checkUserVerified(
                            goWalletController.stikSwapWallet),
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
                    // GazagoButton(buttonText: 'ad_load'.tr(), onTap: ()=> controller.loadRewardedAd()),
                    SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: EdgeInsets.only(left: 25.sp, right: 33.sp),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            StyledText(
                              'digital_assets'.tr(),
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
                    NftAssetItem(
                      onTap: () => Get.toNamed(Routes.walletNftList,
                          arguments: {'prevRoute': 'GO_WALLET'}),
                    ),

                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: 20.sp,
                            bottom: 52.0.sp,
                            left: 20.sp,
                            right: 20.sp),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Text(
                            'go_wallet_description'.tr(),
                            style: AppTextStyleData.regular()
                                .koCaptionMediumMd
                                .copyWith(
                                  color:
                                      AppColorData.regular().colorTextTertiary,
                                ),
                            textAlign: TextAlign.center,
                          ),
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
