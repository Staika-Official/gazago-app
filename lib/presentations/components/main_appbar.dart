import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:step_go/constants/routes.dart';

class MainAppbar extends StatelessWidget implements PreferredSizeWidget {
  const MainAppbar({Key? key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      automaticallyImplyLeading: false,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => Get.toNamed(Routes.preferences),
            icon: const Icon(
              Icons.person,
              color: Colors.grey,
            ),
          ),
          const Text(
            'StepGo',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          IconButton(
            onPressed: () => Get.toNamed(Routes.wallet),
            icon: const Icon(
              Icons.wallet,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
