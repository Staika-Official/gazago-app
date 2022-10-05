import 'package:flutter/material.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/platform/controllers/activity_controller.dart';
import 'package:gaza_go/presentations/components/default_container.dart';
import 'package:get/get.dart';

class ActivitySelect extends StatelessWidget {
  const ActivitySelect({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ActivityController controller = Get.find();

    return DefaultContainer(
      child: Column(
        children: [
          Obx(() {
            return Expanded(
              child: InkWell(
                onTap: controller.doableChallenges.isNotEmpty ? () => controller.moveToChallangeSelection() : null,
                child: Card(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('등산'),
                        controller.doableChallenges.isEmpty ? Text('챌린지 시작 존으로 이동해주세요') : Container(),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
          Expanded(
            child: InkWell(
              onTap: () => controller.loadExercise(ExerciseType.walking),
              child: Card(
                child: Center(
                  child: Text('일반'),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: ElevatedButton(
              onPressed: () => Get.back(),
              child: Text('취소'),
            ),
          )
        ],
      ),
    );
  }
}
