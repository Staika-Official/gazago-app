import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/platform/controllers/wallet_staika_controller.dart';
import 'package:gaza_go/platform/stores/hive_store.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/icons.dart';
import 'package:get/get.dart';

class StaikaWallet extends StatelessWidget {
  const StaikaWallet({Key? key}) : super(key: key);

  // List<Widget> renderCoinAssetList(AssetWalletController controller) {
  //   return controller.coinAssetList
  //       .map(
  //         (asset) => AssetItemCoin(
  //           asset: asset,
  //           onTap: () => controller.moveToWalletDetail(asset: asset, walletType: WalletType.asset, assetType: AssetType.coin),
  //         ),
  //       )
  //       .toList();
  // }

  @override
  Widget build(BuildContext context) {
    StaikaWalletController controller = Get.put(StaikaWalletController());

    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: Obx(() {
        return Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 28.0.sp),
              child: CircleAvatar(
                radius: 23.sp,
                foregroundImage: HiveStore.loadString(key: HiveKey.profileImageUrl.name) != null && HiveStore.loadString(key: HiveKey.profileImageUrl.name) != ''
                    ? CachedNetworkImageProvider(
                        HiveStore.loadString(key: HiveKey.profileImageUrl.name)!,
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
                                  text: '${controller.userWalletAddress.value.substring(0, 4)}',
                                ),
                                TextSpan(
                                  text: '...',
                                ),
                                TextSpan(
                                  text: '${controller.userWalletAddress.value.substring(controller.userWalletAddress.value.length - 4)}',
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 12.0.sp),
                            child: InkWell(
                              child: iconCopy,
                              onTap: () => controller.handleCopyWalletAddress,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            // ...renderCoinAssetList(controller),
          ],
        );
      }),
    );
  }
}
