import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gaza_go/constants/config.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/platform/controllers/activity_controller.dart';
import 'package:gaza_go/platform/helpers/alert_helper.dart';
import 'package:gaza_go/platform/models/challenge_course_model.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/icons.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:get/get.dart';

class ActivityChallengeCourses extends StatelessWidget {
  const ActivityChallengeCourses({Key? key}) : super(key: key);

  List<CircleOverlay> renderStartPoint(ActivityController controller) {
    if (controller.selectedCourse.value != null) {
      CircleOverlay centerCircle = CircleOverlay(
        overlayId: 'ChallengeStartCenter${controller.selectedCourse.value!.id!}',
        center: LatLng(controller.selectedCourse.value!.startLat!, controller.selectedCourse.value!.startLon!),
        radius: 9,
        color: skyBlueColor,
      );

      CircleOverlay outerCircle = CircleOverlay(
        overlayId: 'ChallengeStart${controller.selectedCourse.value!.id!}',
        center: LatLng(controller.selectedCourse.value!.startLat!, controller.selectedCourse.value!.startLon!),
        radius: controller.selectedCourse.value!.startRadius!,
        color: const Color.fromRGBO(14, 230, 243, 0.3),
      );

      return [centerCircle, outerCircle];

    } else {
      return List.empty();
    }
  }

  List<CircleOverlay> renderEndPoint(ActivityController controller) {
    if (controller.selectedCourse.value != null) {
      CircleOverlay centerCircle = CircleOverlay(
        overlayId: 'ChallengeEndCenter${controller.selectedCourse.value!.id!}',
        center: LatLng(controller.selectedCourse.value!.endLat!, controller.selectedCourse.value!.endLon!),
        radius: 9,
        color: Colors.red,
      );

      CircleOverlay outerCircle = CircleOverlay(
        overlayId: 'ChallengeEnd${controller.selectedCourse.value!.id!}',
        center: LatLng(controller.selectedCourse.value!.endLat!, controller.selectedCourse.value!.endLon!),
        radius: controller.selectedCourse.value!.endRadius!,
        color: Colors.red[300]?.withOpacity(0.3),
      );

      return [centerCircle, outerCircle];
    } else {
      return List.empty();
    }
  }

  List<Marker> renderMakers(ActivityController controller) {
    if (controller.selectedCourse.value != null) {
      ChallengeCourseModel course = controller.selectedCourse.value!;
      Marker startMaker = Marker(
        markerId: course.id!.toString(),
        position: LatLng(course.startLat!, course.startLon!),
        captionText: '시작: ${course.startPointName}',
        captionColor: skyBlueColor,
        captionHaloColor: Colors.black,
        captionTextSize: 16.0.sp,
        subCaptionTextSize: 14.sp,
        subCaptionText: course.secondName,
        subCaptionColor: (Platform.isAndroid) ? Colors.white : Colors.black,
        subCaptionHaloColor: (Platform.isAndroid) ? Colors.black : Colors.white,
        captionOffset: 5,
        icon: controller.startMarker,
        width: 20,
        height: 20,
      );

      Marker endMaker = Marker(
        markerId: 'end_${course.id!.toString()}',
        position: LatLng(course.endLat!, course.endLon!),
        captionText: '도착: ${course.endPointName}',
        captionColor: const Color(0xFFFF6F75),
        captionHaloColor: Colors.black,
        captionTextSize: 16.0.sp,
        captionOffset: 5,
        subCaptionText: course.secondName,
        subCaptionTextSize: 14.sp,
        subCaptionColor: (Platform.isAndroid) ? Colors.white : Colors.black,
        subCaptionHaloColor: (Platform.isAndroid) ? Colors.black : Colors.white,
        icon: controller.endMarker,
        width: 20,
        height: 20,
      );

      List<Marker> checkpointMarker() {
        if (course.checkpoints != null && course.checkpoints!.isNotEmpty) {
          return course.checkpoints!
              .map((checkpoint) => Marker(
                    markerId: 'checkpoint_${checkpoint.id!.toString()}',
                    position: LatLng(checkpoint.lat!, checkpoint.lon!),
                    captionText: checkpoint.name,
                    captionColor: skyBlueColor,
                    captionHaloColor: Colors.black,
                    captionTextSize: 12.0.sp,
                    captionOffset: 5,
                    // subCaptionText: course.secondName,
                    // subCaptionTextSize: 14.sp,
                    // subCaptionColor: (Platform.isAndroid) ? Colors.white : Colors.black,
                    // subCaptionHaloColor: (Platform.isAndroid) ? Colors.black : Colors.white,
                    icon: controller.checkpointMarker,
                    width: 30,
                    height: 30,
                  ))
              .toList();
        } else {
          return List.empty();
        }
      }

      return [startMaker, endMaker, ...checkpointMarker()];
    } else {
      return [];
    }
  }

  List<Widget> renderCourseList(ActivityController controller) {
    if (controller.doableCoursesByChallenge.isNotEmpty) {
      return controller.doableCoursesByChallenge.map((ChallengeCourseModel course) {
        bool isSelected = course.id == controller.selectedCourse.value?.id;

        return InkWell(
          onTap: () => controller.selectCourse(course),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.sp, vertical: 15.sp),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SvgPicture.asset(
                  isSelected ? 'assets/images/activity/ico_challenge_checked.svg' : 'assets/images/activity/ico_challenge_unchecked.svg',
                  width: 16.sp,
                  height: 11.sp,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 11.sp),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      StyledText(
                        course.secondName!,
                        fontSize: 18,
                        fontWeight: 500,
                        lineHeight: 18,
                        color: isSelected ? skyBlueColor : Colors.white,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: 7.sp,
                        ),
                        child: StyledText(
                          course.startPointName != null ? '시작: ${course.startPointName!} - 도착: ${course.endPointName!}' : course.firstName!,
                          fontSize: 14,
                          fontWeight: 500,
                          lineHeight: 14,
                          color: isSelected ? skyBlueColor : deepGrayColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList();
    } else {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    ActivityController controller = Get.find();

    return Scaffold(
      body: Obx(() {
        return Stack(
          fit: StackFit.expand,
          alignment: Alignment.topCenter,
          children: [
            NaverMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(controller.currentLocation.value.latitude, controller.currentLocation.value.longitude),
                zoom: 14,
              ),
              circles: [
                if (controller.selectedCourse.value != null) ...renderStartPoint(controller),
                if (controller.selectedCourse.value != null) ...renderEndPoint(controller),
              ],
              markers: [
                if (controller.selectedCourse.value != null) ...renderMakers(controller),
              ],
              mapType: MapType.Basic,
              activeLayers: const [MapLayer.LAYER_GROUP_MOUNTAIN],
              nightModeEnable: true,
              tiltGestureEnable: false,
              onMapCreated: controller.onChallengeMapCreated,
            ),
            Positioned(
              bottom: controller.listHeight.value + 14,
              right: 20,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(72),
                child: GestureDetector(
                  onTap: () => controller.moveToChallengeDetail(controller.selectedChallenge.value!, true),
                  child: controller.selectedChallenge.value!.thumbnailImageUrl.contains('.svg')
                      ? SvgPicture.network(
                          controller.selectedChallenge.value!.thumbnailImageUrl,
                          fit: BoxFit.fitHeight,
                          width: 72.sp,
                          height: 72.sp,
                          placeholderBuilder: (BuildContext context) => const Center(child: SizedBox.square(dimension: 30, child: CircularProgressIndicator())),
                          headers: imageNetworkHeader,
                        )
                      : CachedNetworkImage(
                          fit: BoxFit.fitHeight,
                          width: 72.sp,
                          height: 72.sp,
                          imageUrl: controller.selectedChallenge.value!.thumbnailImageUrl,
                          placeholder: (context, url) => const Center(child: SizedBox.square(dimension: 30, child: CircularProgressIndicator())),
                          httpHeaders: imageNetworkHeader,
                        ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              child: Container(
                key: controller.listKey,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: popupBgColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15.sp),
                    topRight: Radius.circular(15.sp),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        top: 30.sp,
                        bottom: 15.sp,
                      ),
                      child: Text(
                        '도전할 챌린지를 선택해주세요.',
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w500,
                          height: (18 / 25).sp,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: 250.sp),
                      child: SingleChildScrollView(
                        physics: const ClampingScrollPhysics(),
                        child: Column(
                          children: [
                            ...renderCourseList(controller),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: 36.sp,
                        left: 30.sp,
                        right: 30.sp,
                        bottom: 30.sp,
                      ),
                      child: InkWell(
                        onTap: controller.doableCoursesByChallenge.isNotEmpty
                            ? () {
                                if (controller.selectedCourse.value != null && controller.selectedChallenge.value != null) {
                                  ExerciseType type = ExerciseType.values.singleWhere((type) => type.value == controller.selectedChallenge.value?.exerciseTypes[0]);
                                  controller.selectExerciseType(type);
                                } else {
                                  showToastPopup('도전할 챌린지를 선택해주세요.');
                                }
                              }
                            : null,
                        child: Container(
                          padding: EdgeInsets.all(20.sp),
                          width: double.infinity.sp,
                          decoration: BoxDecoration(
                            color: controller.selectedCourse.value != null && controller.doableCoursesByChallenge.isNotEmpty ? skyBlueColor : popupBgColor,
                            borderRadius: BorderRadius.circular(12.sp),
                            border: Border.all(
                              width: 2.sp,
                              style: BorderStyle.solid,
                              color: Colors.black,
                            ),
                            boxShadow: [
                              BoxShadow(
                                offset: Offset(0, 4.sp),
                                blurRadius: 0,
                                spreadRadius: 0,
                                color: Colors.black,
                              ),
                            ],
                          ),
                          child: Text(
                            '가자GO',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
                              height: (16 / 18).sp,
                              color: controller.selectedCourse.value != null && controller.doableCoursesByChallenge.isNotEmpty ? Colors.black : lightGrayColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 48.sp,
              left: 20.sp,
              child: InkWell(
                onTap: () {
                  controller.selectedCourse.value = null;
                  Get.back();
                },
                child: iconChallengeScreenBack,
              ),
            ),
            Positioned(
              top: 50.sp,
              child: Container(
                padding: EdgeInsets.only(top: 10.sp, bottom: 10.sp, right: 20.sp, left: 20.sp),
                decoration: BoxDecoration(
                  color: popupBgColor,
                  borderRadius: BorderRadius.circular(14.sp),
                  border: Border.all(color: Colors.black, width: 2.sp),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black,
                      spreadRadius: 0,
                      blurRadius: 0,
                      offset: Offset(0, 4), // changes position of shadow
                    ),
                  ],
                ),
                child: const StyledText(
                  '챌린지 고르기',
                  fontSize: 16,
                  fontWeight: 500,
                  lineHeight: 22,
                  color: Colors.white,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
