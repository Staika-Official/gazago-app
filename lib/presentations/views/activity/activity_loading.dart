import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gaza_go/platform/controllers/activity_controller.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:get/get.dart';
import 'package:simple_animations/animation_builder/custom_animation_builder.dart';

import '../../styles/styled_text.dart';

class ActivityLoading extends StatelessWidget {
  const ActivityLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ActivityController controller = Get.find();
    return WillPopScope(
      onWillPop: () async => false,
      child: Obx(() {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(children: [
            Center(
                child: CustomAnimationBuilder<double>(
              control: controller.activityLoadControl,
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOutCubic,
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: child,
                );
              },
              child: Padding(
                padding: EdgeInsets.all(20.sp),
                child: controller.loadingTime.value < 4 ? Image.asset('assets/images/activity/ico_loading_${controller.loadingTime.value}.png') : Container(),
              ),
            )),
            Positioned(
              left: 0,
              bottom: 50.sp,
              right: 0,
              child: Center(
                child: InkWell(
                  onTap: () => controller.passThrowActivityLoading(),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          // POINT
                          color: lightGrayColor,
                          width: 1.0,
                        ),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 4.0.sp),
                      child: StyledText(
                        '건너뛰기',
                        color: lightGrayColor,
                        fontSize: 18,
                        fontWeight: 500,
                      ),
                    ),
                  ),
                ),
              ),
            )
          ]),
        );
      }),
    );
  }
}
