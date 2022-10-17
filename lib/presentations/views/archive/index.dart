import 'package:flutter/material.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/platform/controllers/archive_controller.dart';
import 'package:gaza_go/platform/helpers/base_helper.dart';
import 'package:gaza_go/presentations/styles/icons.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:get/get.dart';

class ArchiveHome extends StatelessWidget {
  const ArchiveHome({Key? key}) : super(key: key);

  List<Widget> renderArchiveList(ArchiveController controller) {
    return controller.archiveList
        .map(
          (archive) => InkWell(
            onTap: () => controller.toDetail(archive.id!),
            child: Container(
              margin: const EdgeInsets.only(bottom: 15),
              decoration: BoxDecoration(
                color: const Color(0xFF363841),
                border: Border.all(
                  width: 1,
                  color: Colors.black,
                ),
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10), bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0xFF000000),
                    spreadRadius: 0,
                    blurRadius: 0,
                    offset: Offset(0, 4), // changes position of shadow
                  ),
                ],
              ),
              child: Card(
                elevation: 0,
                color: const Color(0xFF363841),
                child: Padding(
                  padding: const EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0, bottom: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Stack(
                            children: [
                              CircleAvatar(
                                radius: 21,
                                child: archive.type == ExerciseType.hiking.name.toUpperCase() ? iconArchiveHiking : iconArchiveWalking,
                              ),
                              if (archive.badgeIssueId != null)
                                Positioned(
                                  right: 0,
                                  bottom: 0,
                                  child: Image.asset('assets/images/archive/ico_badge.png', width: 15, height: 20),
                                ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 10,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                StyledText(formatDate(archive.startedDate!), fontSize: 16, fontWeight: 500),
                                if (archive.challengeName != null) StyledText(archive.challengeName!, fontSize: 12, lineHeight: 20, color: const Color(0xFF949494), fontWeight: 500),
                              ],
                            ),
                          )
                        ],
                      ),
                      const Divider(
                        color: Color(0xFF28292C),
                        thickness: 1,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 6.0),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 5.2),
                                  child: iconArchiveClock,
                                ),
                                StyledText(
                                  formatSeconds(archive.time!),
                                  fontWeight: 600,
                                )
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 5.2),
                                child: iconArchiveDistance,
                              ),
                              StyledText(
                                '${archive.distance} km',
                                fontWeight: 600,
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 6.0),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 5.2),
                                  child: iconArchiveSteps,
                                ),
                                StyledText(
                                  '${archive.steps}',
                                  fontWeight: 600,
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
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
    ArchiveController controller = Get.put(ArchiveController());

    return Container(
      color: const Color(0xFF1D1D26),
      child: Obx(() {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 25.0, horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: StyledText(
                  '운동 기록',
                  fontSize: 20,
                  fontWeight: 500,
                ),
              ),

              // Align(
              //   alignment: Alignment.centerRight,
              //   child: IconButton(
              //     icon: Icon(Icons.sort),
              //     onPressed: null,
              //   ),
              // ),

              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async => await controller.getArchiveList(),
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
              ),
            ],
          ),
        );
      }),
    );
  }
}
