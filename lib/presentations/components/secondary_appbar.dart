import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gaza_go/constants/routes.dart';
import 'package:gaza_go/platform/controllers/home_menu_controller.dart';
import 'package:gaza_go/platform/controllers/wallet_master_controller.dart';
import 'package:gaza_go/presentations/styles/icons.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:get/get.dart';

class SecondaryAppbar extends StatelessWidget implements PreferredSizeWidget {
  SecondaryAppbar({Key? key}) : super(key: key);

  List<Widget> renderWalletItems(WalletMasterController walletMasterController) {
    return walletMasterController.walletList.map((wallet) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: Row(
          children: [
            CircleAvatar(
              radius: 11,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: SvgPicture.asset(wallet.tokenImageUrl, width: 22, height: 22),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 4),
              child: StyledText(
                wallet.balance.toString(),
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
                    padding: const EdgeInsets.all(12),
                    icon: const Icon(
                      Icons.chevron_left,
                      color: Colors.grey,
                    ),
                  )
                : IconButton(
                    onPressed: () => Get.toNamed(Routes.preferences),
                    icon: iconHeaderAvatar,
                    constraints: const BoxConstraints(
                      minWidth: 24,
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
                  padding: const EdgeInsets.only(left: 12),
                  onPressed: () => Get.toNamed(Routes.wallet),
                  icon: iconHeaderWallet,
                  constraints: const BoxConstraints(
                    minWidth: 24,
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
