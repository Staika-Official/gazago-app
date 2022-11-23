import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gaza_go/platform/controllers/activity_controller.dart';
import 'package:get/get.dart';
import 'package:simple_animations/animation_builder/custom_animation_builder.dart';

class ActivityLoading extends StatelessWidget {
  const ActivityLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ActivityController controller = Get.find();
    return Obx(() {
      return Center(
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
          child: Image.asset('assets/images/activity/ico_loading_${controller.loadingTime.value}.png'),
        ),
      ));
    });
  }
}
