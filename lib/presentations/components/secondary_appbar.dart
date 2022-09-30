import 'package:flutter/material.dart';
import 'package:gaza_go/constants/routes.dart';
import 'package:gaza_go/platform/controllers/home_menu_controller.dart';
import 'package:gaza_go/platform/controllers/wallet_master_controller.dart';
import 'package:get/get.dart';

class SecondaryAppbar extends StatelessWidget implements PreferredSizeWidget {
  SecondaryAppbar({Key? key}) : super(key: key);

  List<Widget> renderWalletItems(WalletMasterController walletMasterController) {
    return walletMasterController.walletList.map((wallet) {
      return Padding(
        padding: const EdgeInsets.only(left: 10),
        child: Row(
          children: [
            CircleAvatar(
              radius: 10,
              foregroundImage: NetworkImage(wallet.tokenImageUrl),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 4),
              child: Text(
                wallet.balance.toString(),
                style: const TextStyle(color: Colors.black, fontSize: 12),
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
      backgroundColor: Colors.white,
      automaticallyImplyLeading: false,
      title: Obx(() {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            controller.isBackButton()
                ? IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(
                      Icons.chevron_left,
                      color: Colors.grey,
                    ),
                  )
                : IconButton(
                    onPressed: () => Get.toNamed(Routes.preferences),
                    icon: const Icon(
                      Icons.person,
                      color: Colors.grey,
                    ),
                  ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ...renderWalletItems(walletMasterController),
                IconButton(
                  onPressed: () => Get.toNamed(Routes.wallet),
                  icon: const Icon(
                    Icons.wallet,
                    color: Colors.grey,
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
