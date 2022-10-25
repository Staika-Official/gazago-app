import 'package:flutter/material.dart';
import 'package:gaza_go/platform/controllers/activity_controller.dart';
import 'package:gaza_go/platform/controllers/loading_controller.dart';
import 'package:gaza_go/platform/controllers/wallet_master_controller.dart';
import 'package:gaza_go/presentations/components/default_container.dart';
import 'package:gaza_go/presentations/styles/icons.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:get/get.dart';

class Loading extends StatelessWidget {
  const Loading({Key? key}) : super(key: key);

  List<Widget> renderGauge(LoadingController controller, elWidth) {
    List<Widget> gaugeList = List.empty(growable: true);
    int colored = (controller.progress.value * 43).toInt();

    for (int i = 0; i < 26; i++) {
      //15km / 0.25 = 60

      Widget? gauge;
      gauge = Container(
        width: 6,
        height: 16,
        color: i <= colored ? Color(0xFF0EE6F3) : Colors.black,
      );

      gaugeList.add(gauge);
    }

    return gaugeList;
  }

  @override
  Widget build(BuildContext context) {
    LoadingController loadingController = Get.put(LoadingController());
    Get.put(WalletMasterController(), permanent: true);
    Get.put(ActivityController(), permanent: true);

    return DefaultContainer(
      isLeadingShow: false,
      backgroundColor: const Color(0xFF0EE6F3),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.only(left: 40.0, right: 40.0, bottom: 80.0),
                child: iconSplashLogo,
              ),
            ),
            Positioned(
              left: 0,
              bottom: 0,
              right: 0,
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return Obx(() {
                        return Column(
                          children: [
                            const StyledText(
                              'LOADING...',
                              color: Colors.black,
                              fontWeight: 900,
                              fontFamily: 'Montserrat',
                              fontSize: 20,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 13.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  border: Border.all(
                                    width: 1,
                                    color: const Color(0xFF54F5FF),
                                  ),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(6),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      ...renderGauge(loadingController, constraints.maxWidth),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 40.0),
                                  child: StyledText(
                                    loadingController.progressMessage.value,
                                    color: Colors.black,
                                    fontWeight: 500,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      });
                    },
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
