import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:step_go/constants/enums.dart';
import 'package:step_go/platform/controllers/archive_controller.dart';
import 'package:step_go/presentations/components/default_container.dart';

class ArchiveDetail extends StatelessWidget {
  const ArchiveDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ArchiveController controller = Get.find();

    return DefaultContainer(
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      controller.selectedItem.value.activityType ==
                              ActivityType.climbing
                          ? Icons.nordic_walking
                          : Icons.directions_walk,
                    ),
                    Text(
                      controller.selectedItem.value.startTime,
                    )
                  ],
                ),
                Positioned(
                  right: 0,
                  child: IconButton(
                    onPressed: null,
                    icon: Icon(Icons.restore_from_trash),
                  ),
                )
              ],
            ),
          ),
          Container(
            width: double.infinity,
            height: 400,
            color: Colors.grey,
            child: Text('Map'),
          ),
          Text('시작 시간: ${controller.selectedItem.value.startTime}'),
          Text('종료 시간: ${controller.selectedItem.value.endTime}'),
          Text('시작점: ${controller.selectedItem.value.startLocationFull}'),
          Text('획득 뱃지: ${controller.selectedItem.value.acquiredBadge}'),
          Text('운동 시간: ${controller.selectedItem.value.activityDuration}'),
          Text('운동 거리: ${controller.selectedItem.value.activityDistance}'),
          Text('걸음 수: ${controller.selectedItem.value.stepCount}'),
          Text('평균 속도: ${controller.selectedItem.value.avgSpeed}'),
          Text('최고 고도: ${controller.selectedItem.value.highestClimbed}'),
          Text('획득 STEP: ${controller.selectedItem.value.acquiredGo}'),
          Text('소비 체력: ${controller.selectedItem.value.staminaUsed}'),
          Text('소비 내구도: ${controller.selectedItem.value.durabilityConsumed}'),
        ],
      ),
    );
  }
}
