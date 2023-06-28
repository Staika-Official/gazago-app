import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gaza_go/platform/controllers/activity_controller.dart';
import 'package:gaza_go/platform/controllers/loading_controller.dart';
import 'package:gaza_go/platform/controllers/wallet_master_controller.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/icons.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:get/get.dart';

class Loading extends StatelessWidget {
  const Loading({Key? key}) : super(key: key);

  List<Widget> renderGauge(LoadingController controller, elWidth) {
    List<Widget> gaugeList = List.empty(growable: true);
    int colored = (controller.progress.value * 26).toInt();

    for (int i = 0; i < 26; i++) {
      //15km / 0.25 = 60

      Widget? gauge;
      gauge = Container(
        width: 6.sp,
        height: 16.sp,
        color: i <= colored ? skyBlueColor : Colors.black,
      );

      gaugeList.add(gauge);
    }

    return gaugeList;
  }

  @override
  Widget build(BuildContext context) {
    LoadingController loadingController = Get.find<LoadingController>();
    Get.put(WalletMasterController(), permanent: true);
    Get.put(ActivityController(), permanent: true);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage('assets/images/common/bg_loading.png'), alignment: Alignment(0, 0), fit: BoxFit.cover),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.0.sp),
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Positioned.fill(
                top: -((MediaQuery.of(context).size.height / 2) - 20).sp,
                left: 40.sp,
                right: 40.sp,
                child: Padding(
                  padding: const EdgeInsets.only(left: 0.0, right: 0.0, top: 0.0),
                  child: iconSplashLogo,
                ),
              ),
              Positioned(
                left: 0,
                bottom: 0,
                right: 0,
                child: Padding(
                    padding: EdgeInsets.all(8.0.sp),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return Obx(() {
                          return Column(
                            children: [
                              StyledText(
                                'LOADING...',
                                color: skyBlueColor,
                                fontWeight: 900,
                                fontFamily: 'Montserrat',
                                fontSize: 20,
                                lineHeight: 22,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 14.0.sp, horizontal: 13.0.sp),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    border: Border.all(
                                      width: 2.sp,
                                      color: const Color(0xFF37B7BF).withOpacity(.5),
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(6.sp),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(10.0.sp),
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
                                    padding: EdgeInsets.only(bottom: 40.0.sp),
                                    child: StyledText(
                                      loadingController.progressMessage.value,
                                      color: skyBlueColor,
                                      fontWeight: 500,
                                      fontSize: 13,
                                      lineHeight: 15,
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
      ),
    );
  }
}
