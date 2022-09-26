import 'package:flutter/material.dart';
import 'package:gaza_go/platform/controllers/archive_controller.dart';
import 'package:gaza_go/platform/helpers/base_helper.dart';
import 'package:get/get.dart';

class ArchiveHome extends StatelessWidget {
  const ArchiveHome({Key? key}) : super(key: key);

  List<Widget> renderArchiveList(ArchiveController controller) {
    return controller.archiveList
        .map(
          (archive) => InkWell(
            onTap: () => controller.toDetail(archive.id!),
            child: Card(
              color: Colors.blueGrey,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        // TODO. api에서 운동타임 추가 필요.
                        // Icon(
                        //   archive.activityType == ActivityType.climbing ? Icons.nordic_walking : Icons.directions_walk,
                        // ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: 10,
                          ),
                          child: Text(
                            formatDate(archive.startedDate!),
                          ),
                        )
                      ],
                    ),
                    Divider(
                      color: Colors.grey,
                      thickness: 1,
                    ),
                    Text(
                      '${archive.startPoint} \u00B7 ${archive.time} \u00B7 ${archive.distance}km \u00B7 ${archive.rewardGo}GO',
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    ArchiveController controller = Get.put(ArchiveController());
    return Container(
      child: Obx(() {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: Icon(Icons.sort),
                onPressed: null,
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: ClampingScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ...renderArchiveList(controller),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
