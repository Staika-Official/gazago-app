import 'package:flutter/material.dart';

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
        children: const [
          IconButton(onPressed: null, icon: Icon(Icons.person)),
          Text(
            'StepGo',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          IconButton(onPressed: null, icon: Icon(Icons.wallet)),
        ],
      ),
    );
  }
}
