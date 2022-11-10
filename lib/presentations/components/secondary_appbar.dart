import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart' as SP;
import 'package:gaza_go/constants/routes.dart';
import 'package:gaza_go/platform/controllers/home_menu_controller.dart';
import 'package:gaza_go/platform/controllers/wallet_master_controller.dart';
import 'package:gaza_go/platform/helpers/base_helper.dart';
import 'package:gaza_go/presentations/styles/icons.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:get/get.dart';

class SecondaryAppbar extends StatelessWidget implements PreferredSizeWidget {
  SecondaryAppbar({Key? key}) : super(key: key);

  List<Widget> renderWalletItems(WalletMasterController walletMasterController) {
    return walletMasterController.spendingTokenUiList.map((token) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 6.sp),
        child: Row(
          children: [
            CircleAvatar(
              radius: 11.sp,
              foregroundImage: token.meta?.logoUrl != '' ? CachedNetworkImageProvider(token.meta!.logoUrl) : const SP.Svg('assets/images/common/ico_token_tik.svg') as ImageProvider,
            ),
            Padding(
              padding: EdgeInsets.only(left: 4.sp),
              child: StyledText(
                // token.uiAmountString!,
                token.meta?.symbol == 'STIK' ? formatDecimalPlaces((token.amount! / pow(10.0, 9)), 9) : formatDecimalPlaces(token.amount!, 1),
                color: Colors.white,
                fontSize: 12,
                fontWeight: 600,
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    HomeMenuController controller = Get.find();
    WalletMasterController walletMasterController = Get.find();

    return AppBar(
      backgroundColor: Color(0xFF1D1D26),
      automaticallyImplyLeading: false,
      bottomOpacity: 0.0,
      elevation: 0.0,
      title: Obx(() {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            controller.isBackButton()
                ? IconButton(
                    onPressed: () => Get.back(),
                    padding: EdgeInsets.symmetric(horizontal: 12.sp),
                    icon: const Icon(
                      Icons.chevron_left,
                      color: Colors.grey,
                    ),
                  )
                : IconButton(
                    onPressed: () => Get.toNamed(Routes.preferences),
                    padding: EdgeInsets.symmetric(horizontal: 12.sp),
                    icon: iconHeaderAvatar,
                    constraints: BoxConstraints(
                      minWidth: 24.sp,
                    ),
                  ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xFF363841),
                    border: Border.all(
                      width: 1,
                      color: Colors.black,
                    ),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(20),
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black,
                        offset: Offset(0, 2),
                        blurRadius: 0.0,
                        spreadRadius: 0.0,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 4.0,
                        bottom: 4.0,
                        left: 0,
                        right: 8,
                      ),
                      child: Row(
                        children: [
                          ...renderWalletItems(walletMasterController),
                        ],
                      ),
                    ),
                  ),
                ),
                IconButton(
                  padding: EdgeInsets.only(left: 12.sp),
                  onPressed: () => Get.toNamed(Routes.wallet),
                  icon: iconHeaderWallet,
                  constraints: BoxConstraints(
                    minWidth: 24.sp,
                  ),
                )
              ],
            ),
          ],
        );
      }),
    );
  }
}
