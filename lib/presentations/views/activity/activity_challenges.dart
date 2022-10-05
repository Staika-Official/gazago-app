import 'package:flutter/material.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/platform/controllers/activity_controller.dart';
import 'package:gaza_go/presentations/components/default_container.dart';
import 'package:get/get.dart';

class ActivityChallenges extends StatelessWidget {
  const ActivityChallenges({Key? key}) : super(key: key);

  List<Widget> renderChallengeList(ActivityController controller) {
    return controller.doableChallenges
        .map(
          (challenge) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () => controller.loadExercise(ExerciseType.hiking, challenge),
              child: Card(
                color: Colors.blue[300],
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(challenge.firstName!),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    ActivityController controller = Get.find();

    return DefaultContainer(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ...renderChallengeList(controller),
          ],
        ),
      ),
    );
  }
}
