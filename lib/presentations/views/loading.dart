import 'package:flutter/material.dart';
import 'package:gaza_go/platform/controllers/activity_controller.dart';
import 'package:gaza_go/platform/controllers/global_controller.dart';
import 'package:gaza_go/platform/controllers/loading_controller.dart';
import 'package:gaza_go/platform/controllers/wallet_master_controller.dart';
import 'package:gaza_go/presentations/components/default_container.dart';
import 'package:get/get.dart';

class Loading extends StatelessWidget {
  const Loading({Key? key}) : super(key: key);

  List<Widget> renderGauge(LoadingController controller, elWidth) {
    List<Widget> gaugeList = List.empty(growable: true);

    if (controller.progress.value <= 1) {
      for (int i = 0; i < elWidth / 14 / 5 * controller.progress.value * 5; i++) {
        //15km / 0.25 = 60

        Widget? gauge;
        gauge = Padding(
          padding: const EdgeInsets.all(4.0),
          child: Container(
            width: 6,
            height: 16,
            color: Color(0xFF0EE6F3),
          ),
        );
        gaugeList.add(gauge);
      }
    }

    print(elWidth / 14);
    return gaugeList;
  }

  @override
  Widget build(BuildContext context) {
    LoadingController loadingController = Get.put(LoadingController());
    Get.put(GlobalController(), permanent: true);
    Get.put(WalletMasterController(), permanent: true);
    Get.put(ActivityController(), permanent: true);

    return DefaultContainer(
      isLeadingShow: false,
      child: Flexible(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return Obx(() {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            ...renderGauge(loadingController, constraints.maxWidth),
                          ],
                        );
                      });
                    },
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
