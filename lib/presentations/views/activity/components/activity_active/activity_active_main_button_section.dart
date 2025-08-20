import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/constants/routes.dart';
import 'package:gaza_go/platform/controllers/activity_controller.dart';
import 'package:gaza_go/presentations/components/circular_button.dart';
import 'package:gaza_go/theme/theme.g.dart';
import 'package:get/get.dart';

class ActivityActiveMainButtonSection extends GetWidget<ActivityController> {
  const ActivityActiveMainButtonSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            /// Map button
            CircularButton(
              radius: 48,
              color: Colors.white,
              onTap: controller.moveMapToMyLocation,
              padding: const EdgeInsets.all(8),
              child: SvgPicture.asset(
                'assets/images/activity/ico_exercise_location.svg',
              ),
            ),
            const SizedBox(width: 16),

            /// play - stop button
            [ExerciseState.ongoing]
                    .any((state) => controller.exerciseState.value == state)
                ? Row(
                    children: [
                      CircularButton(
                        onTapDown: (tapDownDetail) => controller.onTapDownStop(
                            tapDownDetail, controller.selectedCourse.value,
                            controller: controller),
                        onTapUp: (tapUpDetail) =>
                            controller.onTapUpStop(tapUpDetail),
                        padding: EdgeInsets.zero,
                        radius: 64,
                        color: Colors.white,
                        child: SizedBox(
                          child: SvgPicture.asset(
                            'assets/images/activity/ico_exercise_stop.svg',
                            width: 15,
                            height: 15,
                            fit: BoxFit.scaleDown,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      CircularButton(
                        radius: 64,
                        padding: EdgeInsets.zero,
                        color: AppColorData.regular().colorBgWarning,
                        onTap: () => controller.pauseExercise(),
                        child: SvgPicture.asset(
                          'assets/images/activity/ico_pause.svg',
                          width: 15,
                          height: 15,
                          fit: BoxFit.scaleDown,
                        ),
                      )
                    ],
                  )
                : CircularButton(
                    radius: 64,
                    padding: EdgeInsets.zero,
                    color: AppColorData.regular().colorBgWarning,
                    onTap: () {
                      if (controller.exerciseState.value ==
                          ExerciseState.paused) {
                        controller.exerciseUpdateThr
                            .throttle(() => controller.continueExercise());
                      } else {
                        controller.exerciseStartThr.throttle(() =>
                            controller.startExercise(
                                controller.selectedExerciseType.value,
                                controller.selectedCourse.value));
                      }
                    },
                    child: SvgPicture.asset(
                      'assets/images/activity/ico_play.svg',
                    ),
                  ),
            const SizedBox(width: 16),

            /// equipped items button
            CircularButton(
              radius: 48,
              color: Colors.white,
              onTap: () => Get.toNamed(Routes.equippedItems),
              padding: const EdgeInsets.all(8),
              child: SvgPicture.asset(
                'assets/images/activity/ico_exercise_shoe.svg',
              ),
            ),
          ],
        );
      },
    );
  }
}
