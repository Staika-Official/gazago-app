import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/platform/controllers/activity_controller.dart';
import 'package:gaza_go/platform/helpers/alert_helper.dart';
import 'package:gaza_go/platform/models/challenge_model.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/icons.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:get/get.dart';

class ActivityChallenges extends StatelessWidget {
  const ActivityChallenges({Key? key}) : super(key: key);

  List<CircleOverlay> renderStartPoint(ActivityController controller) {
    // List<CircleOverlay> centerCircles = controller.doableChallenges
    //     .map(
    //       (challenge) => CircleOverlay(
    //         overlayId: 'ChallengeStartCenter' + challenge.id!.toString(),
    //         center: LatLng(challenge.startLat!, challenge.startLon!),
    //         radius: 9,
    //         color: skyBlueColor,
    //       ),
    //     )
    //     .toList();
    //
    // List<CircleOverlay> outerCircles = controller.doableChallenges
    //     .map(
    //       (challenge) => CircleOverlay(
    //         overlayId: 'ChallengeStart' + challenge.id!.toString(),
    //         center: LatLng(challenge.startLat!, challenge.startLon!),
    //         radius: challenge.startRadius!,
    //         color: Color.fromRGBO(14, 230, 243, 0.3),
    //       ),
    //     )
    //     .toList();
    CircleOverlay centerCircle = CircleOverlay(
      overlayId: 'ChallengeStartCenter${controller.selectedChallenge.value.id!}',
      center: LatLng(controller.selectedChallenge.value.startLat!, controller.selectedChallenge.value.startLon!),
      radius: 9,
      color: skyBlueColor,
    );

    CircleOverlay outerCircle = CircleOverlay(
      overlayId: 'ChallengeStart${controller.selectedChallenge.value.id!}',
      center: LatLng(controller.selectedChallenge.value.startLat!, controller.selectedChallenge.value.startLon!),
      radius: controller.selectedChallenge.value.startRadius!,
      color: const Color.fromRGBO(14, 230, 243, 0.3),
    );

    return [centerCircle, outerCircle];
  }

  List<CircleOverlay> renderEndPoint(ActivityController controller) {
    // List<CircleOverlay> centerCircles = controller.doableChallenges
    //     .map(
    //       (challenge) => CircleOverlay(
    //         overlayId: 'ChallengeEndCenter' + challenge.id!.toString(),
    //         center: LatLng(challenge.endLat!, challenge.endLon!),
    //         radius: 9,
    //         color: Colors.red,
    //       ),
    //     )
    //     .toList();
    //
    // List<CircleOverlay> outerCircles = controller.doableChallenges
    //     .map(
    //       (challenge) => CircleOverlay(
    //         overlayId: 'ChallengeStart' + challenge.id!.toString(),
    //         center: LatLng(challenge.endLat!, challenge.endLon!),
    //         radius: challenge.startRadius!,
    //         color: Colors.red[100],
    //       ),
    //     )
    //     .toList();
    //
    // return [...outerCircles, ...centerCircles];

    CircleOverlay centerCircle = CircleOverlay(
      overlayId: 'ChallengeEndCenter${controller.selectedChallenge.value.id!}',
      center: LatLng(controller.selectedChallenge.value.endLat!, controller.selectedChallenge.value.endLon!),
      radius: 9,
      color: Colors.red,
    );

    CircleOverlay outerCircle = CircleOverlay(
      overlayId: 'ChallengeEnd${controller.selectedChallenge.value.id!}',
      center: LatLng(controller.selectedChallenge.value.endLat!, controller.selectedChallenge.value.endLon!),
      radius: controller.selectedChallenge.value.endRadius!,
      color: Colors.red[300]?.withOpacity(0.3),
    );

    return [centerCircle, outerCircle];
  }

  List<Marker> renderMaker(ActivityController controller) {
    ChallengeModel course = controller.selectedChallenge.value;
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
        icon: controller.startMaker,
        width: 20,
        height: 20);

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
      icon: controller.endMaker,
      width: 20,
      height: 20,
    );
    return [startMaker, endMaker];
  }

  List<Widget> renderChallengeList(ActivityController controller) {
    return controller.doableChallenges.map((challenge) {
      bool isSelected = challenge.id == controller.selectedChallenge.value.id;
      return InkWell(
        onTap: () => controller.selectChallenge(challenge),
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
                      challenge.secondName!,
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
                        challenge.startPointName != null ? '시작: ${challenge.startPointName!} - 도착: ${challenge.endPointName!}' : challenge.firstName!,
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
                if (controller.selectedChallenge.value.id != null) ...renderStartPoint(controller),
                if (controller.selectedChallenge.value.id != null) ...renderEndPoint(controller),
              ],
              markers: [
                if (controller.selectedChallenge.value.id != null) ...renderMaker(controller),
              ],
              mapType: MapType.Basic,
              activeLayers: const [MapLayer.LAYER_GROUP_MOUNTAIN],
              nightModeEnable: true,
              tiltGestureEnable: false,
              onMapCreated: controller.onChallengeMapCreated,
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
                            ...renderChallengeList(controller),
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
                        onTap: () {
                          if (controller.selectedChallenge.value.id != null) {
                            controller.selectExerciseType(ExerciseType.hiking);
                          } else {
                            showToastPopup('도전할 챌린지를 선택해주세요.');
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.all(20.sp),
                          width: double.infinity.sp,
                          decoration: BoxDecoration(
                            color: controller.selectedChallenge.value.id != null ? skyBlueColor : popupBgColor,
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
                            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600, height: (16 / 18).sp, color: controller.selectedChallenge.value.id != null ? Colors.black : lightGrayColor),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Padding(
            //   padding: EdgeInsets.only(top: 70.sp),
            //   child: Container(
            //       padding: EdgeInsets.only(top: 10.sp, bottom: 10.sp, right: 20.sp, left: 20.sp),
            //       decoration: BoxDecoration(
            //         color: popupBgColor,
            //         borderRadius: BorderRadius.circular(14.sp),
            //         border: Border.all(color: Colors.black, width: 2.sp),
            //         boxShadow: const [
            //           BoxShadow(
            //             color: Colors.black,
            //             spreadRadius: 0,
            //             blurRadius: 0,
            //             offset: Offset(0, 4), // changes position of shadow
            //           ),
            //         ],
            //       ),
            //       child: const StyledText(
            //         '첼린지 리스트',
            //         fontSize: 16,
            //         fontWeight: 500,
            //         lineHeight: 22,
            //         color: Colors.white,
            //         textAlign: TextAlign.center,
            //       )),
            // ),
            Positioned(
              top: 46.sp,
              left: 20.sp,
              child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: iconChallengeScreenBack),
            ),
            Positioned(
              left: MediaQuery.of(context).size.width / 2 - 76,
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
                  )),
            ),
          ],
        );
      }),
    );
  }
}
