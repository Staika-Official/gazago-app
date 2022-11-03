import 'package:flutter/material.dart';
import 'package:gaza_go/platform/controllers/activity_controller.dart';
import 'package:get/get.dart';
import 'package:simple_animations/animation_builder/loop_animation_builder.dart';

class ActivityLoading extends StatelessWidget {
  const ActivityLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ActivityController controller = Get.find();

    return Obx(() {
      return Center(
        child: LoopAnimationBuilder<double>(
          tween: Tween(begin: 0.1, end: 1.1),
          duration: const Duration(seconds: 1),
          curve: Curves.easeOut,
          builder: (context, value, child) {
            return Transform.scale(
              scale: value,
              child: child,
            );
          },
          child: Image.asset('assets/images/activity/ico_loading_${controller.loadingTime.value}.png'),
        )
        /*child: Padding(
          padding: const EdgeInsets.all(20),
          child: Image.asset('assets/images/activity/ico_loading_${controller.loadingTime.value}.png'),
        ),*/
      );
    });
  }
}
