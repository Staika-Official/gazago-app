import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:gaza_go/platform/controllers/archive_controller.dart';
import 'package:gaza_go/platform/helpers/base_helper.dart';
import 'package:gaza_go/presentations/components/default_container.dart';
import 'package:get/get.dart';

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
                    // Icon(
                    //   controller.selectedItem.value.activityType == ActivityType.climbing ? Icons.nordic_walking : Icons.directions_walk,
                    // ),
                    Text(
                      formatDate(controller.selectedItem.value.startedDate!),
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
            child: NaverMap(
                // initialCameraPosition: CameraPosition(
                //   target: controller.locations.value.first,
                // ),
                ),
          ),
          Text('시작 시간: ${formatDate(controller.selectedItem.value.startedDate!)}'),
          Text('종료 시간: ${formatDate(controller.selectedItem.value.endedDate)}'),
          Text('시작점: ${controller.selectedItem.value.startPoint}'),
          Text('획득 뱃지: ${controller.selectedItem.value.badgeIssueId}'), //TODO. 뱃지 네임 필요
          Text('운동 시간: ${controller.selectedItem.value.time}'),
          Text('운동 거리: ${controller.selectedItem.value.distance}'),
          Text('걸음 수: ${controller.selectedItem.value.steps}'),
          Text('평균 속도: ${controller.selectedItem.value.speed}'),
          Text('최고 고도: ${controller.selectedItem.value.altitude}'),
          Text('획득 STEP: ${controller.selectedItem.value.rewardGo}'),
          Text('소비 체력: ${controller.selectedItem.value.spendStamina}'),
          Text('소비 내구도: ${controller.selectedItem.value.spendDurability}'),
        ],
      ),
    );
  }
}
