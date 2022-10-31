import 'package:flutter/material.dart';
import 'package:gaza_go/platform/controllers/activity_controller.dart';
import 'package:get/get.dart';

class ActivityLoading extends StatelessWidget {
  const ActivityLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ActivityController controller = Get.find();

    return Obx(() {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Image.asset('assets/images/activity/ico_loading_${controller.loadingTime.value}.png'),
        ),
      );
    });
  }
}
