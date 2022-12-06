import 'dart:ui';

import 'package:another_xlider/another_xlider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gaza_go/platform/controllers/activity_controller.dart';
import 'package:gaza_go/platform/controllers/archive_controller.dart';
import 'package:gaza_go/platform/controllers/inventory_controller.dart';
import 'package:gaza_go/platform/controllers/loading_controller.dart';
import 'package:gaza_go/platform/controllers/preference_controller.dart';
import 'package:gaza_go/platform/controllers/withdraw_confirm_controller.dart';
import 'package:gaza_go/platform/helpers/activity_mixin.dart';
import 'package:gaza_go/platform/helpers/alert_helper.dart';
import 'package:gaza_go/platform/helpers/base_helper.dart';
import 'package:gaza_go/platform/models/challenge_model.dart';
import 'package:gaza_go/platform/models/inventory_badge_model.dart';
import 'package:gaza_go/platform/models/stat_model.dart';
import 'package:gaza_go/presentations/components/circular_button.dart';
import 'package:gaza_go/presentations/components/gazago_button.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/icons.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:get/get.dart';

void showRetryAlert(LoadingController controller) {
  showAlert(
    title: '로딩 중 오류가 발생했습니다',
    contentText: '재시도 후에도 오류가 발생할 경우\n잠시 후 다시 시도해 주세요',
    actions: [
      Expanded(
        child: GazagoButton(
          onTap: () => controller.handleRefreshApp(),
          buttonText: '재시도하기',
          buttonColor: skyBlueColor,
        ),
      ),
    ],
  );
}

void showShoeRepairSlider(InventoryController controller, int feeTikDurability) {
  showAlert(
    title: '내구도 충전하기',
    contentWidget: Obx(() {
      return Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 12.0.sp),
            child: StyledText(
              '현재 신발 내구도 ${controller.equippedShoe.value.durability.toInt()}',
              fontSize: 16,
              lineHeight: 22,
              fontWeight: 500,
              color: deepGrayColor,
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 15.sp),
            child: FlutterSlider(
              values: [controller.currentSliderValue.value],
              max: 100,
              min: 0,
              handlerHeight: 32.0,
              ignoreSteps: [
                FlutterSliderIgnoreSteps(from: 0, to: 0),
              ],
              trackBar: FlutterSliderTrackBar(
                inactiveTrackBarHeight: 16,
                activeTrackBarHeight: 15,
                inactiveTrackBar: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.sp),
                  color: sliderGrayColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      offset: Offset(2.sp, 3.sp),
                    )
                  ],
                ),
                activeTrackBar: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.sp),
                  color: purpleColor,
                ),
              ),
              onDragging: (handlerIndex, lowerValue, upperValue) {
                controller.currentSliderValue.value = lowerValue;
                controller.costTik.value = controller.currentSliderValue.value.toInt() * feeTikDurability;
              },
              handler: FlutterSliderHandler(
                decoration: BoxDecoration(
                  color: purpleColor,
                  border: Border.all(width: 2.sp, color: Colors.white),
                  borderRadius: BorderRadius.circular(30.sp),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      offset: Offset(2.sp, 3.sp),
                    )
                  ],
                ),
                child: iconSliderShoe,
              ),
              tooltip: FlutterSliderTooltip(
                textStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w500,
                  height: 1.sp,
                ),
                format: (label) => '+ ${formatDecimalPlaces(double.parse(label), 0)}',
                boxStyle: FlutterSliderTooltipBox(
                  decoration: BoxDecoration(
                    color: purpleColor,
                    borderRadius: BorderRadius.circular(50.sp),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 40.0.sp),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const StyledText(
                  '신발 내구도 충전 비용 :',
                  fontSize: 22,
                  fontWeight: 500,
                  color: Color(0xFFA7A7A7),
                ),
                StyledText(
                  ' ${controller.costTik.value} TIK',
                  fontSize: 22,
                  fontWeight: 500,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ],
      );
    }),
    actions: [
      Expanded(
        child: GazagoButton(
          onTap: () => controller.closeRepairPopup(),
          buttonText: '취소',
          textColor: Colors.white,
          buttonColor: popupBgColor,
        ),
      ),
      SizedBox(
        width: 9.sp,
      ),
      Expanded(
        child: GazagoButton(
          onTap: () => controller.fetchRepairShoes(controller.equippedShoe.value.id),
          buttonText: '네',
          buttonColor: skyBlueColor,
        ),
      ),
    ],
  );
}

void showRepairStatSlider(ActivityController controller, StatModel stat, int feeTikStamina, int feeTikDurability) {
  showAlert(
    title: stat.type == 'STAMINA' ? '체력 충전하기' : '내구도 충전하기',
    contentWidget: Obx(() {
      return Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 12.0.sp),
            child: stat.type == 'STAMINA'
                ? StyledText(
                    '현재 체력 ${stat.currentStat}',
                    fontSize: 16,
                    lineHeight: 22,
                    fontWeight: 500,
                    color: deepGrayColor,
                  )
                : StyledText(
                    '현재 신발 내구도 ${stat.currentStat}',
                    fontSize: 16,
                    lineHeight: 22,
                    fontWeight: 500,
                    color: deepGrayColor,
                  ),
          ),
          Container(
            margin: EdgeInsets.only(top: 15.sp),
            child: FlutterSlider(
              values: [controller.currentSliderValue.value],
              max: 100,
              min: 0,
              step: const FlutterSliderStep(
                step: 1, // default
              ),
              handlerHeight: 32.0,
              ignoreSteps: [
                FlutterSliderIgnoreSteps(from: 0, to: 0),
              ],
              trackBar: FlutterSliderTrackBar(
                inactiveTrackBarHeight: 16,
                activeTrackBarHeight: 15,
                inactiveTrackBar: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.sp),
                  color: const Color(0xFF494954),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      offset: Offset(2.sp, 3.sp),
                    )
                  ],
                ),
                activeTrackBar: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.sp),
                  color: stat.type == 'STAMINA' ? lightGreenColor : purpleColor,
                ),
              ),
              onDragging: (handlerIndex, lowerValue, upperValue) {
                controller.currentSliderValue.value = lowerValue;
                controller.costTik.value = controller.currentSliderValue.value.toInt() * (stat.type == 'STAMINA' ? feeTikStamina : feeTikDurability);
              },
              handler: FlutterSliderHandler(
                decoration: BoxDecoration(
                  color: stat.type == 'STAMINA' ? lightGreenColor : purpleColor,
                  border: Border.all(width: 2.sp, color: Colors.white),
                  borderRadius: BorderRadius.circular(30.sp),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      offset: Offset(2.sp, 3.sp),
                    )
                  ],
                ),
                child: stat.type == 'STAMINA' ? iconSliderStamina : iconSliderShoe,
              ),
              tooltip: FlutterSliderTooltip(
                textStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w500,
                  height: 1.sp,
                ),
                format: (label) => '+ ${formatDecimalPlaces(double.parse(label), 0)}',
                boxStyle: FlutterSliderTooltipBox(
                  decoration: BoxDecoration(
                    color: stat.type == 'STAMINA' ? lightGreenColor : purpleColor,
                    borderRadius: BorderRadius.circular(50.sp),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 40.0.sp),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                StyledText(
                  '${stat.type == 'STAMINA' ? '체력 충전 ' : '신발 내구도 충전 '}비용 :',
                  fontSize: 22,
                  fontWeight: 500,
                  color: lightGrayColor,
                ),
                StyledText(
                  ' ${controller.costTik.value} TIK',
                  fontSize: 22,
                  fontWeight: 500,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ],
      );
    }),
    actions: [
      Expanded(
        child: GazagoButton(
          onTap: () => controller.closeRepairPopup(),
          buttonText: '취소',
          textColor: Colors.white,
          buttonColor: popupBgColor,
        ),
      ),
      SizedBox(
        width: 9.sp,
      ),
      Expanded(
        child: GazagoButton(
          onTap: () => stat.type == 'STAMINA' ? controller.fetchRechargeStamina(stat.type) : controller.fetchRepairShoes(),
          disableButton: controller.disableButton.value,
          buttonText: '네',
          buttonColor: skyBlueColor,
        ),
      ),
    ],
  );
}

void showNotEnoughTaikaAlert() {
  showAlert(
    title: '잔고 부족',
    contentText: 'Taika 가 부족하여 진행할 수 없습니다.\n GO지갑에 Taika를 충전해 주세요.',
    actions: [
      Expanded(
        child: GazagoButton(
          onTap: () => Get.back(),
          buttonText: '확인',
          buttonColor: skyBlueColor,
        ),
      ),
    ],
  );
}

Future<void> showLocationAlert(ActivityController controller) async {
  await showAlert(
    title: '알림',
    contentWidget: Padding(
      padding: EdgeInsets.only(top: 30.sp, bottom: 50.sp),
      child: Text.rich(
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 18.sp,
          height: 24.sp / 18.sp,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
        TextSpan(
          text: '정확한 운동기록을 위해서 ',
          children: [
            TextSpan(text: '위치', style: TextStyle(color: skyBlueColor)),
            const TextSpan(text: '엑세스 \n권한을 허용해 주세요'),
          ],
        ),
      ),
    ),
    actions: [
      Expanded(
        child: GazagoButton(
          buttonText: '확인',
          onTap: () async {
            Get.back();
            await controller.requestLocationPermission();
          },
        ),
      ),
    ],
  );
}

Future<void> showActivityAlert(ActivityController controller) async {
  await showAlert(
    title: '알림',
    contentWidget: Padding(
      padding: EdgeInsets.only(top: 30.sp, bottom: 50.sp),
      child: Text.rich(
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 18.sp,
          height: 24.sp / 18.sp,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
        TextSpan(
          text: '정확한 운동기록을 위해서 ',
          children: [
            TextSpan(text: '신체 활동\n', style: TextStyle(color: skyBlueColor)),
            const TextSpan(text: '엑세스 권한을 허용해 주세요.'),
          ],
        ),
      ),
    ),
    actions: [
      Expanded(
        child: GazagoButton(
          buttonText: '확인',
          onTap: () async {
            Get.back();
            await controller.requestActivityPermission();
          },
        ),
      ),
    ],
  );
}

Future<void> showGpsAlert() async {
  await showAlert(
    title: '알림',
    contentWidget: Padding(
      padding: EdgeInsets.only(top: 30.sp, bottom: 50.sp),
      child: Text.rich(
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 18.sp,
          height: 24.sp / 18.sp,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
        TextSpan(
          text: '정상적인 gazaGO 이용을 위하여 디바이스의 ',
          children: [
            TextSpan(text: 'GPS', style: TextStyle(color: skyBlueColor)),
            const TextSpan(text: ' 기능을 활성화 시켜주세요.'),
          ],
        ),
      ),
    ),
    actions: [
      Expanded(
        child: GazagoButton(
          buttonText: '확인',
          onTap: () {
            Get.back();
          },
        ),
      ),
    ],
  );
}

void showEndExerciseAlert(ActivityMixin mixin, ChallengeModel challenge) {
  showAlert(
    title: '운동 종료',
    contentText: '지금까지의 기록만 저장됩니다.',
    actions: [
      Expanded(
        child: GazagoButton(
          onTap: () => Get.back(),
          buttonText: '취소',
          textColor: Colors.white,
          buttonColor: popupBgColor,
        ),
      ),
      SizedBox(
        width: 9.sp,
      ),
      Expanded(
        child: GazagoButton(
          onTap: () => mixin.endExercise(challenge, source: 'showEndExerciseAlert'),
          buttonText: '운동종료',
          buttonColor: skyBlueColor,
        ),
      ),
    ],
  );
}

void showBadgeAcquisitionAlert(InventoryBadgeModel badge, ChallengeModel selectedChallenge) {
  showAlert(
    isScrollControlled: true,
    title: '챌린지 뱃지 발급',
    contentWidget: Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 30.sp, bottom: 30.sp),
          child: CachedNetworkImage(
            imageUrl: badge.badge.imageUrl,
            placeholder: (context, url) => const CircularProgressIndicator(),
            fit: BoxFit.contain,
            width: 150.sp,
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 25.sp, vertical: 14.sp),
          decoration: BoxDecoration(
            color: subBg01Color,
            borderRadius: BorderRadius.circular(11.sp),
          ),
          child: StyledText(
            '${selectedChallenge.firstName} | ${selectedChallenge.secondName}',
            fontSize: 18,
            lineHeight: 18,
            fontWeight: 500,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 20.sp, bottom: 30.sp),
          child: Text.rich(
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14.sp,
              height: 20.sp / 14.sp,
              fontWeight: FontWeight.w500,
              color: lightGrayColor,
            ),
            TextSpan(
              children: [
                TextSpan(text: '내 장비 > 뱃지', style: TextStyle(color: skyBlueColor)),
                const TextSpan(text: ' 카테고리에서\n획득한 뱃지를 확인하실수 있습니다.'),
              ],
            ),
          ),
        ),
      ],
    ),
    actions: [
      Expanded(
        child: GazagoButton(
          buttonText: '확인',
          onTap: () async {
            Get.back();
          },
        ),
      ),
    ],
  );
}

void showDeleteRecordAlert(ArchiveController controller, int id) {
  showAlert(
    title: '삭제',
    contentText: '기록이 정말 사라지길 원하십니까?',
    actions: [
      Expanded(
        child: GazagoButton(
          onTap: () => Get.back(),
          buttonText: '아니요',
          textColor: Colors.white,
          buttonColor: popupBgColor,
        ),
      ),
      SizedBox(
        width: 9.sp,
      ),
      Expanded(
        child: GazagoButton(
          onTap: () {
            controller.deleteItem(id);
          },
          buttonText: '삭제하기',
          buttonColor: skyBlueColor,
        ),
      ),
    ],
  );
}

void showLogoutAlert(PreferenceController controller) {
  showAlert(
    title: '로그아웃 하시겠습니까?',
    contentText: '로그아웃 시 진행 중\n운동은 자동 정지되어 저장됩니다.',
    actions: [
      Expanded(
        child: GazagoButton(
          onTap: () => controller.onLogout(),
          buttonText: '네',
          textColor: Colors.white,
          buttonColor: popupBgColor,
        ),
      ),
      SizedBox(
        width: 9.sp,
      ),
      Expanded(
        child: GazagoButton(
          onTap: () => Get.back(),
          buttonText: '아니요',
          buttonColor: skyBlueColor,
        ),
      ),
    ],
  );
}

void showConfirmWithdrawAlert(WithdrawConfirmController controller) {
  showAlert(
    title: '탈퇴에 최종 동의 하십니까?',
    contentText: '아쉽네요.\n다음에 다시 가자고와 만나요!',
    actions: [
      Expanded(
        child: GazagoButton(
          onTap: () => Get.back(),
          buttonText: '취소',
          textColor: Colors.white,
          buttonColor: popupBgColor,
        ),
      ),
      SizedBox(
        width: 9.sp,
      ),
      Expanded(
        child: GazagoButton(
          onTap: () => controller.handleFetchWithdrawMember(),
          buttonText: '확인',
          buttonColor: skyBlueColor,
        ),
      ),
    ],
  );
}

void showPendingExerciseAlert(ActivityController controller) {
  Get.dialog(
    barrierColor: Colors.transparent,
    Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
            child: Container(
              decoration: new BoxDecoration(color: Colors.black.withOpacity(0.6)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 100),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(top: 26.sp, left: 18.sp, right: 18.sp, bottom: 22.sp),
                    margin: EdgeInsets.only(
                      left: 30.sp,
                      right: 30.sp,
                    ),
                    decoration: BoxDecoration(
                      color: popupBgColor,
                      borderRadius: BorderRadius.circular(10.sp),
                    ),
                    child: Column(
                      children: [
                        iconAppName,
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 33.sp),
                          child: StyledText(
                            '진행 중인 운동이 있습니다.\n계속 하시겠습니까?',
                            fontSize: 18.sp,
                            lineHeight: 28.sp,
                            fontWeight: 500,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        GazagoButton(
                          onTap: () {
                            controller.continueExerciseFromDialog();
                          },
                          buttonText: '네, 계속할래요',
                        )
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(
                      top: 39.sp,
                      left: 46.sp,
                      right: 46.sp,
                      bottom: 14.sp,
                    ),
                    padding: EdgeInsets.only(
                      top: 7.sp,
                      bottom: 11.sp,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10.sp),
                    ),
                    child: Text.rich(
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16.sp,
                        height: 22.sp / 16.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                      TextSpan(
                        text: '운동을 종료하시려면\n',
                        children: [
                          TextSpan(text: '아래 '),
                          TextSpan(text: '종료 버튼을 3초간 눌러주세요', style: TextStyle(color: skyBlueColor)),
                        ],
                      ),
                    ),
                  ),
                  Obx(() {
                    return GestureDetector(
                      onTapDown: (tapDownDetail) => controller.onTapDownStop(tapDownDetail, controller.selectedChallenge.value, source: 'pendingExerciseDialog'),
                      onTapUp: (tapUpDetail) => controller.onTapUpStop(tapUpDetail, source: 'pendingExerciseDialog'),
                      child: Stack(
                        children: [
                          CircularButton(
                            radius: 104.sp,
                            color: Colors.white,
                            child: Icon(Icons.stop, color: Colors.black, size: 64.sp),
                          ),
                          Positioned(
                            top: 0,
                            left: 0,
                            child: Container(
                              width: 104.sp,
                              height: 104.sp,
                              padding: EdgeInsets.all(5.sp),
                              child: CircularProgressIndicator(
                                strokeWidth: 6.sp,
                                color: skyBlueColor,
                                value: controller.stopProgress.value,
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
