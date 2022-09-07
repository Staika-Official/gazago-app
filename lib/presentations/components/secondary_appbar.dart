import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:step_go/platform/controllers/home_menu_controller.dart';

class SecondaryAppbar extends StatelessWidget implements PreferredSizeWidget {
  SecondaryAppbar({Key? key}) : super(key: key);

  List<Widget> renderWalletItems(HomeMenuController controller) {
    return controller.walletList.map((wallet) {
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
                style: TextStyle(color: Colors.black, fontSize: 12),
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

    return AppBar(
      backgroundColor: Colors.white,
      automaticallyImplyLeading: false,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(onPressed: null, icon: Icon(Icons.person)),
          Obx(() {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ...renderWalletItems(controller),
                IconButton(
                  onPressed: null,
                  icon: Icon(
                    Icons.wallet,
                  ),
                )
              ],
            );
          })
        ],
      ),
    );
  }
}
