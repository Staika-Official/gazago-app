import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gaza_go/platform/controllers/archive_controller.dart';
import 'package:gaza_go/platform/helpers/activity_helper.dart';
import 'package:gaza_go/platform/helpers/base_helper.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/icons.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:get/get.dart';

class ArchiveHome extends StatelessWidget {
  const ArchiveHome({Key? key}) : super(key: key);

  List<Widget> renderArchiveList(ArchiveController controller) {
    return controller.archiveList
        .map(
          (archive) => InkWell(
            onTap: () => controller.dataGetLoading.value ? null : controller.toDetail(archive.id!),
            child: Container(
              margin: EdgeInsets.only(bottom: 15.sp),
              decoration: BoxDecoration(
                color: popupBgColor,
                border: Border.all(
                  width: 1,
                  color: Colors.black,
                ),
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10), bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF000000),
                    spreadRadius: 0,
                    blurRadius: 0,
                    offset: Offset(0, 4.sp), // changes position of shadow
                  ),
                ],
              ),
              child: Card(
                elevation: 0,
                color: popupBgColor,
                child: Padding(
                  padding: EdgeInsets.only(top: 15.0.sp, left: 18.0.sp, right: 18.0.sp, bottom: 10.0.sp),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              CircleAvatar(
                                radius: 21.sp,
                                backgroundColor: Colors.transparent,
                                foregroundImage: controller.getArchiveTypeImage(archive),
                                // foregroundImage: archive.type == ExerciseType.hiking.name.toUpperCase()
                                // const sp.Svg('assets/images/archive/ico_archive_hiking.svg')
                                //     : const sp.Svg('assets/images/archive/ico_archive_walking.svg'),
                              ),
                              if (archive.badgeIssueId != null)
                                Positioned(
                                  right: -5,
                                  bottom: -5,
                                  child: Image.network(archive.badgeImageUrl!, width: 20.sp, height: 20.sp),
                                ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              left: 16.sp,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                StyledText(formatDateUntilDay(archive.startedDate!), fontSize: 16, fontWeight: 500),
                                if (archive.challengeTitle != null) StyledText(archive.challengeTitle!, fontSize: 12, lineHeight: 20, color: deepGrayColor, fontWeight: 600),
                              ],
                            ),
                          )
                        ],
                      ),
                      Divider(
                        color: subBg02Color,
                        height: 25.sp,
                        thickness: 1,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 6.0.sp),
                            child: Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(right: 5.2.sp),
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
                                padding: EdgeInsets.only(right: 5.2.sp),
                                child: iconArchiveDistance,
                              ),
                              StyledText(
                                '${formatDecimalPlaces(convertMetersToKm(archive.distance!), 2)} km',
                                fontWeight: 600,
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 6.0.sp),
                            child: Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(right: 5.2.sp),
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
      color: subBg01Color,
      child: Obx(() {
        return Padding(
          padding: EdgeInsets.only(top: 0.sp, left: 20.sp, right: 20.sp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Align(
              //   alignment: Alignment.centerRight,
              //   child: IconButton(
              //     icon: Icon(Icons.sort),
              //     onPressed: null,
              //   ),
              // ),

              controller.archiveList.isEmpty
                  ? controller.dataGetLoading.value
                      ? Padding(
                          padding: EdgeInsets.symmetric(vertical: 20.0.sp),
                          child: const Center(child: CircularProgressIndicator()),
                        )
                      : Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(vertical: 50.sp),
                          decoration: BoxDecoration(
                            color: popupBgColor,
                            borderRadius: BorderRadius.circular(12.sp),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              iconEmpty,
                              Padding(
                                padding: EdgeInsets.only(top: 20.sp),
                                child: const StyledText(
                                  '운동 기록이 없습니다.',
                                  color: Color(0xff7b7b7b),
                                  fontSize: 16,
                                  lineHeight: 10,
                                  fontWeight: 500,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 13.sp),
                                child: const StyledText(
                                  '운동하고 GO를 쌓아보세요!',
                                  color: Color(0xff7b7b7b),
                                  fontSize: 16,
                                  lineHeight: 10,
                                  fontWeight: 500,
                                ),
                              ),
                            ],
                          ),
                        )
                  : Expanded(
                      child: SingleChildScrollView(
                        controller: controller.scroll,
                        physics: const ClampingScrollPhysics(),
                        child: Padding(
                          padding: EdgeInsets.only(top: 20.0.sp),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ...renderArchiveList(controller),
                              if (controller.dataGetLoading.value)
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 20.0.sp),
                                  child: const Center(child: CircularProgressIndicator()),
                                )
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
