import 'package:flutter/material.dart';
import 'package:gaza_go/platform/controllers/crew_detail_controller.dart';
import 'package:gaza_go/presentations/components/share_appbar.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/views/challenges/crew_info.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';

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
          child: ShareAppbar(
            titleText: 'my_crew_record'.tr(),
            isBeta: false,
            isLockButton: true,
          )),
      backgroundColor: subBg01Color,
      body: const CrewInfo(),
    );
  }
}
