import 'package:flutter/material.dart';
import 'package:gaza_go/constants/routes.dart';
import 'package:gaza_go/presentations/styles/icons.dart';
import 'package:get/get.dart';

class MainAppbar extends StatelessWidget implements PreferredSizeWidget {
  const MainAppbar({Key? key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Color(0xFF1D1D26),
      bottomOpacity: 0.0,
      elevation: 0.0,
      automaticallyImplyLeading: false,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: null,
            icon: iconHeaderLogo,
            constraints: const BoxConstraints(
              minWidth: 100,
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: () => Get.toNamed(Routes.preferences),
                icon: iconHeaderAvatar,
                constraints: const BoxConstraints(
                  minWidth: 24,
                ),
              ),
              IconButton(
                onPressed: () => Get.toNamed(Routes.wallet),
                icon: iconHeaderWallet,
                constraints: const BoxConstraints(
                  minWidth: 24,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
