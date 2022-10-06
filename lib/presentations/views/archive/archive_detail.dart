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
              initialCameraPosition: CameraPosition(
                target: controller.locations.first,
              ),
              pathOverlays: {
                PathOverlay(
                  PathOverlayId('detail path'),
                  controller.locations.length > 1 ? controller.locations : [controller.locations.first, controller.locations.first],
                  width: 3,
                  color: Colors.red,
                  outlineColor: Colors.white,
                )
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('시작 시간: ${formatDate(controller.selectedItem.value.startedDate!)}'),
          ),
          controller.selectedItem.value.challengeTitle != null
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('도전한 첼린지: ${controller.selectedItem.value.challengeTitle}'),
                )
              : Container(),
          controller.selectedItem.value.badgeName != null
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('획득 뱃지: ${controller.selectedItem.value.badgeName}'),
                )
              : Container(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('운동 시간: ${formatSeconds(controller.selectedItem.value.time!)}'),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('운동 거리: ${controller.selectedItem.value.distance}km'),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('걸음 수: ${controller.selectedItem.value.steps}'),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('평균 속도: ${controller.selectedItem.value.speed}km/h'),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('획득 STEP: ${controller.selectedItem.value.rewardGo}GO'),
          ),
        ],
      ),
    );
  }
}
