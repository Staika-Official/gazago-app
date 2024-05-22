import 'package:flutter/material.dart';
import 'package:gaza_go/platform/controllers/crew_detail_controller.dart';
import 'package:gaza_go/presentations/components/share_appbar.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/views/challenges/crew_info.dart';
import 'package:get/get.dart';

class CrewDetail extends StatelessWidget {
  const CrewDetail({super.key});
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    CrewDetailController controller = Get.put(CrewDetailController());

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
          preferredSize: preferredSize, // here the desired height
          child: const ShareAppbar(
            titleText: '나의 크루 기록',
            isBeta: false,
            isLockButton: true,
          )),
      backgroundColor: subBg01Color,
      body: const CrewInfo(),
    );
  }
}
