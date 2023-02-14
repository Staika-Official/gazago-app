import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart' as sp;
import 'package:gaza_go/constants/routes.dart';
import 'package:gaza_go/platform/controllers/wallet_master_controller.dart';
import 'package:gaza_go/platform/helpers/base_helper.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/icons.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:get/get.dart';

class SecondaryAppbar extends StatelessWidget implements PreferredSizeWidget {
  final bool isShowBackButton;
  const SecondaryAppbar({Key? key, this.isShowBackButton = false}) : super(key: key);

  List<Widget> renderWalletItems(WalletMasterController walletMasterController) {
    return walletMasterController.spendingTokenUiList.map((token) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 6.sp),
        child: Row(
          children: [
            CircleAvatar(
              radius: 11.sp,
              foregroundImage: token.logoUrl != '' && token.logoUrl != null ? CachedNetworkImageProvider(token.logoUrl!) : const sp.Svg('assets/images/common/ico_token_tik.svg') as ImageProvider,
            ),
            Padding(
              padding: EdgeInsets.only(left: 4.sp),
              child: StyledText(
                token.symbol! == 'STIK' ? formatDecimalPlaces((token.amount! / pow(10.0, 9)), 9) : formatDecimalPlaces(token.amount!, 1),
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
    WalletMasterController walletMasterController = Get.find();
    return AppBar(
      backgroundColor: subBg01Color,
      automaticallyImplyLeading: false,
      bottomOpacity: 0.0,
      elevation: 0.0,
      title: Obx(() {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            isShowBackButton
                ? Container(
                    width: 20,
                    padding: EdgeInsets.zero,
                    child: IconButton(
                      onPressed: () => Get.back(),
                      padding: EdgeInsets.zero,
                      iconSize: 30,
                      splashRadius: 20.sp,
                      icon: const Icon(
                        Icons.chevron_left_sharp,
                        color: Colors.white,
                      ),
                    ),
                  )
                : Container(
                    padding: EdgeInsets.symmetric(vertical: 3.0.sp),
                    constraints: BoxConstraints(
                      minWidth: 100.sp,
                    ),
                    child: iconHeaderLogo,
                  ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: popupBgColor,
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
                    borderRadius: BorderRadius.all(
                      Radius.circular(20.sp),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: 4.0.sp,
                        bottom: 4.0.sp,
                        left: 0,
                        right: 8,
                      ),
                      child: InkWell(
                        onTap: () => Get.find<WalletMasterController>().moveToWallet(),
                        child: Row(
                          children: [
                            ...renderWalletItems(walletMasterController),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 4.sp),
                  child: IconButton(
                    onPressed: () => Get.toNamed(Routes.preferences),
                    icon: iconHeaderGear,
                    splashRadius: 20.sp,
                    iconSize: 30,
                    constraints: BoxConstraints(
                      minWidth: 30.sp,
                    ),
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
