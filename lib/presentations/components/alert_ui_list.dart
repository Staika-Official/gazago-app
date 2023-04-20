import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:another_xlider/another_xlider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/constants/routes.dart';
import 'package:gaza_go/platform/controllers/activity_controller.dart';
import 'package:gaza_go/platform/controllers/archive_controller.dart';
import 'package:gaza_go/platform/controllers/debugging_controller.dart';
import 'package:gaza_go/platform/controllers/inventory_controller.dart';
import 'package:gaza_go/platform/controllers/loading_controller.dart';
import 'package:gaza_go/platform/controllers/login_controller.dart';
import 'package:gaza_go/platform/controllers/my_page_controller.dart';
import 'package:gaza_go/platform/controllers/notice_popup_controller.dart';
import 'package:gaza_go/platform/controllers/preference_controller.dart';
import 'package:gaza_go/platform/controllers/shop_controller.dart';
import 'package:gaza_go/platform/controllers/wallet_go_controller.dart';
import 'package:gaza_go/platform/controllers/wallet_master_controller.dart';
import 'package:gaza_go/platform/controllers/wallet_staika_controller.dart';
import 'package:gaza_go/platform/controllers/withdraw_confirm_controller.dart';
import 'package:gaza_go/platform/helpers/activity_mixin.dart';
import 'package:gaza_go/platform/helpers/alert_helper.dart';
import 'package:gaza_go/platform/helpers/base_helper.dart';
import 'package:gaza_go/platform/helpers/inventory_helper.dart';
import 'package:gaza_go/platform/models/challenge_model.dart';
import 'package:gaza_go/platform/models/exchange_stik_price_model.dart';
import 'package:gaza_go/platform/models/inventory_badge_model.dart';
import 'package:gaza_go/platform/models/stat_model.dart';
import 'package:gaza_go/presentations/components/circular_button.dart';
import 'package:gaza_go/presentations/components/gazago_button.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/icons.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:gaza_go/presentations/views/wallet/confirm_wallet_password.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';

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
    title: '신발 내구도 충전',
    contentWidget: Obx(() {
      return Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 12.0.sp),
            child: StyledText(
              '현재 신발 내구도 ${formatDecimalPlaces(controller.equippedShoe.value.durability, 2)}',
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
                  '충전 비용 :',
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
        child: Obx(() {
          return GazagoButton(
            onTap: () => controller.fetchRepairShoes(controller.equippedShoe.value.id),
            disableButton: controller.disableButton.value,
            buttonText: '네',
            buttonColor: skyBlueColor,
          );
        }),
      ),
    ],
  );
}

void showRepairStatSlider(ActivityController controller, StatModel stat, int feeTikStamina, int feeTikDurability) {
  showAlert(
    title: stat.type == 'STAMINA' ? '체력 충전' : '신발 내구도 충전',
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
                    '현재 신발 내구도 ${formatDecimalPlaces(stat.currentStat, 2)}',
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
                  '${stat.type == 'STAMINA' ? '충전 ' : '충전 '}비용 :',
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
        child: Obx(() {
          return GazagoButton(
            onTap: () => stat.type == 'STAMINA' ? controller.fetchRechargeStamina(stat.type) : controller.fetchRepairShoes(),
            disableButton: controller.disableButton.value,
            buttonText: '네',
            buttonColor: skyBlueColor,
          );
        }),
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

void showFakeGpsAlert() async {
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
          text: '비정상적인 ',
          children: [
            TextSpan(text: 'GPS 활동', style: TextStyle(color: skyBlueColor)),
            const TextSpan(text: '이 감지되었습니다.'),
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

Future<bool> showGalleryPermissionAlert(MyPageController controller) async {
  Completer<bool> photoPermissionCompleter = Completer();
  bool permissionGranted = false;
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
          text: '프로필 사진 변경을 위해서 ',
          children: [
            TextSpan(text: '사진\n', style: TextStyle(color: skyBlueColor)),
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
            permissionGranted = await controller.requestPhotoPermission();
          },
        ),
      ),
    ],
  );

  photoPermissionCompleter.complete(permissionGranted);

  return photoPermissionCompleter.future;
}

void showEndExerciseAlert(ActivityMixin mixin, ChallengeModel challenge) {
  showAlert(
    title: '활동 종료',
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
          buttonText: '활동 종료',
          buttonColor: skyBlueColor,
        ),
      ),
    ],
  );
}

void showEndExerciseAdAlert(ChallengeModel challenge, ActivityController controller) {
  showAlert(
    title: '활동 종료',
    contentText: '지금까지의 기록만 저장됩니다.',
    actions: [
      Expanded(
        child: Column(
          children: [
            InkWell(
                onTap: () => controller.endAd.value == null ? null : controller.showExerciseEndAd(challenge, controller),
                child: Obx(() {
                  return Container(
                    width: double.infinity,
                    height: 52.sp,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: controller.endAd.value == null ? popupBgColor : skyBlueColor,
                      border: Border.all(width: 2.sp, color: Colors.black),
                      borderRadius: BorderRadius.circular(8.sp),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black,
                          offset: Offset(0, 3.sp),
                        )
                      ],
                    ),
                    child: controller.endAd.value == null
                        ? controller.time.value != 0
                            ? Stack(
                                children: [
                                  Text(
                                    controller.time.value.toString(),
                                    style: TextStyle(
                                      fontSize: 40.sp,
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.w700,
                                      height: 1.1,
                                      foreground: Paint()..color = skyBlueColor,
                                    ),
                                  ),
                                  Text(
                                    controller.time.value.toString(),
                                    style: TextStyle(
                                      fontSize: 40.sp,
                                      height: 1.1,
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.w700,
                                      foreground: Paint()
                                        ..strokeWidth = 2
                                        ..color = Colors.black
                                        ..style = PaintingStyle.stroke,
                                    ),
                                  ),
                                ],
                              )
                            : const StyledText(
                                '아직 광고가 부족해요...',
                                color: Color(0xFF60626C),
                                fontSize: 18,
                                fontWeight: 600,
                              )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(right: 5.0),
                                child: iconGoSmall,
                              ),
                              StyledText(
                                '광고 보고, GO 10% 더 받고! ',
                                color: Colors.black,
                                fontSize: 18,
                                lineHeight: 19,
                                fontWeight: 600,
                                letterSpacing: .4,
                              ),
                            ],
                          ),
                  );
                })),
            Padding(
              padding: EdgeInsets.only(top: 8.0.sp),
              child: GazagoButton(
                onTap: () => controller.endExercise(challenge, source: 'showEndExerciseAlert'),
                buttonText: '활동 종료',
                buttonColor: const Color(0xFF2C2E36),
                textColor: skyBlueColor,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 25.0.sp),
              child: InkWell(
                onTap: () {
                  print('close ad popup');
                  controller.closeAdSelectPopup();
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        // POINT
                        color: lightGrayColor,
                        width: 1.0,
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 6.0, left: 5.0, right: 5.0),
                    child: StyledText(
                      '취소',
                      fontSize: 18,
                      lineHeight: 22,
                      fontWeight: 500,
                      color: lightGrayColor,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      )
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
          child: badge.badge.imageUrl.contains('.svg')
              ? SvgPicture.network(
                  fit: BoxFit.contain,
                  badge.badge.imageUrl,
                  width: 150.sp,
                  placeholderBuilder: (BuildContext context) => Container(padding: const EdgeInsets.all(30.0), child: const CircularProgressIndicator()),
                )
              : CachedNetworkImage(
                  imageUrl: badge.badge.imageUrl,
                  placeholder: (context, url) => const CircularProgressIndicator(),
                  fit: BoxFit.fitWidth,
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
    WillPopScope(
      onWillPop: () async => false,
      child: Material(
        color: Colors.transparent,
        child: Stack(
          children: [
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
              child: Container(
                decoration: BoxDecoration(color: Colors.black.withOpacity(0.6)),
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
                            const TextSpan(text: '아래 '),
                            TextSpan(text: '종료 버튼을 3초간 눌러주세요', style: TextStyle(color: skyBlueColor)),
                          ],
                        ),
                      ),
                    ),
                    Obx(() {
                      return GestureDetector(
                        onTapDown: (tapDownDetail) => controller.onTapDownStop(tapDownDetail, controller.selectedChallenge.value, controller: controller, source: 'pendingExerciseDialog'),
                        onTapUp: (tapUpDetail) => controller.onTapUpStop(tapUpDetail),
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
    ),
  );
}

void itemPurchaseAlert(ShopController controller, double remainMyTik, tradeSymbol) {
  showAlert(
    title: '구매 하시겠습니까?',
    isScrollControlled: true,
    contentWidget: Obx(() {
      return Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 22.0.sp, bottom: 70.sp),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                StyledText(
                  '${formatDecimalPlaces(controller.selectedItem.value.price, 0)} ',
                  fontSize: 30,
                  lineHeight: 32,
                  fontWeight: 600,
                ),
                StyledText(
                  controller.selectedItem.value.tradeSymbol!,
                  fontSize: 30,
                  lineHeight: 32,
                  fontWeight: 400,
                ),
              ],
            ),
          ),
          if (controller.selectedItem.value.maxGoProfit > 0)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const StyledText(
                  'GO 보상',
                  fontSize: 18,
                  lineHeight: 32,
                  fontWeight: 500,
                ),
                StyledText(
                  '${formatDecimalPlaces(controller.selectedItem.value.minGoProfit, 0)}-${formatDecimalPlaces(controller.selectedItem.value.maxGoProfit, 0)}',
                  fontSize: 18,
                  lineHeight: 32,
                  fontWeight: 400,
                ),
              ],
            ),
          if (controller.selectedItem.value.maxStamina > 0)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const StyledText(
                  '체력',
                  fontSize: 18,
                  lineHeight: 32,
                  fontWeight: 500,
                ),
                StyledText(
                  '${formatDecimalPlaces(controller.selectedItem.value.minStamina, 0)}-${formatDecimalPlaces(controller.selectedItem.value.maxStamina, 0)}',
                  fontSize: 18,
                  lineHeight: 32,
                  fontWeight: 400,
                ),
              ],
            ),
          if (controller.selectedItem.value.maxDurability > 0)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const StyledText(
                  '내구도',
                  fontSize: 18,
                  lineHeight: 32,
                  fontWeight: 600,
                ),
                StyledText(
                  '${formatDecimalPlaces(controller.selectedItem.value.minDurability, 0)}-${formatDecimalPlaces(controller.selectedItem.value.maxDurability, 0)}',
                  fontSize: 18,
                  lineHeight: 32,
                  fontWeight: 400,
                ),
              ],
            ),
          if (controller.selectedItem.value.maxLuck > 0)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const StyledText(
                  '행운',
                  fontSize: 18,
                  lineHeight: 32,
                  fontWeight: 600,
                ),
                StyledText(
                  '${formatDecimalPlaces(controller.selectedItem.value.minLuck, 0)}-${formatDecimalPlaces(controller.selectedItem.value.maxLuck, 0)}',
                  fontSize: 18,
                  lineHeight: 32,
                  fontWeight: 400,
                ),
              ],
            ),
          Divider(
            height: 40.sp,
            thickness: 2.0.sp,
            color: const Color(0xFF494B56),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const StyledText(
                '잔액',
                fontSize: 18,
                lineHeight: 18,
                fontWeight: 600,
              ),
              StyledText(
                '${formatDecimalPlaces(remainMyTik, tradeSymbol == 'STIK' ? 9 : 0, isAutoDecimal: true)} ${controller.selectedItem.value.tradeSymbol!}',
                fontSize: 18,
                lineHeight: 18,
                fontWeight: 400,
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 55.0.sp, bottom: 25.sp),
            child: StyledText(
              '· 구매가 완료되면 취소가 불가합니다.',
              fontSize: 14,
              lineHeight: 14,
              fontWeight: 500,
              color: skyBlueColor,
            ),
          )
        ],
      );
    }),
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
          onTap: () => controller.handlePurchaseShopItem(controller.selectedItem.value.id),
          buttonText: '구매',
          buttonColor: skyBlueColor,
        ),
      ),
    ],
  );
}

void itemPurchaseShortBalanceAlert(ShopController controller, double remainMyTik, tradeSymbol) {
  showAlert(
    title: '잔액이 부족합니다',
    isDangerTitle: true,
    isScrollControlled: true,
    contentWidget: Obx(() {
      return Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 22.0.sp, bottom: 70.sp),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                StyledText(
                  '${formatDecimalPlaces(controller.selectedItem.value.price, 0)} ',
                  fontSize: 30,
                  lineHeight: 32,
                  fontWeight: 600,
                ),
                StyledText(
                  controller.selectedItem.value.tradeSymbol!,
                  fontSize: 30,
                  lineHeight: 32,
                  fontWeight: 400,
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const StyledText(
                'GO 보상율',
                fontSize: 18,
                lineHeight: 32,
                fontWeight: 600,
              ),
              StyledText(
                '${formatDecimalPlaces(controller.selectedItem.value.fromRewardRate, 0)}-${formatDecimalPlaces(controller.selectedItem.value.toRewardRate, 0)}%',
                fontSize: 18,
                lineHeight: 32,
                fontWeight: 400,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const StyledText(
                '체력 감소율',
                fontSize: 18,
                lineHeight: 32,
                fontWeight: 600,
              ),
              StyledText(
                '${formatDecimalPlaces(controller.selectedItem.value.fromStaminaReduceRate, 0)}-${formatDecimalPlaces(controller.selectedItem.value.toStaminaReduceRate, 0)}%',
                fontSize: 18,
                lineHeight: 32,
                fontWeight: 400,
              ),
            ],
          ),
          if (controller.selectedItem.value.itemCategory == 'SHOES')
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const StyledText(
                  '내구도 감소율',
                  fontSize: 18,
                  lineHeight: 32,
                  fontWeight: 600,
                ),
                StyledText(
                  '${formatDecimalPlaces(controller.selectedItem.value.fromAbrasionRate, 0)}-${formatDecimalPlaces(controller.selectedItem.value.toAbrasionRate, 0)}%',
                  fontSize: 18,
                  lineHeight: 32,
                  fontWeight: 400,
                ),
              ],
            ),
          Divider(
            height: 40.sp,
            thickness: 2.0.sp,
            color: const Color(0xFF494B56),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              StyledText(
                '잔액',
                fontSize: 18,
                lineHeight: 18,
                fontWeight: 600,
                color: dangerColor,
              ),
              StyledText(
                '${formatDecimalPlaces(remainMyTik, tradeSymbol == 'STIK' ? 9 : 0, isAutoDecimal: true)} ${controller.selectedItem.value.tradeSymbol}',
                fontSize: 18,
                lineHeight: 18,
                fontWeight: 400,
                color: dangerColor,
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 55.0.sp, bottom: 25.sp),
            child: StyledText(
              '· ${controller.selectedItem.value.tradeSymbol} 충전 후 재시도 해주세요',
              fontSize: 14,
              lineHeight: 14,
              fontWeight: 500,
              color: dangerColor,
            ),
          )
        ],
      );
    }),
    actions: [
      Expanded(
        child: GazagoButton(
          onTap: () => Get.back(),
          buttonText: '닫기',
          buttonColor: skyBlueColor,
        ),
      ),
    ],
  );
}

void itemPurchaseCompleteAlert(ShopController controller) {
  showAlert(
    title: '구매가 완료되었습니다.',
    isScrollControlled: true,
    contentWidget: Obx(() {
      return Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 20.0.sp, bottom: 15.sp),
            child: Column(
              children: [
                SizedBox(
                  width: 150.sp,
                  child: controller.purchaseCompleteItem.value.itemImageUrl.contains('.svg')
                      ? SvgPicture.network(
                          fit: BoxFit.contain,
                          controller.purchaseCompleteItem.value.itemImageUrl,
                          placeholderBuilder: (BuildContext context) => Container(padding: const EdgeInsets.all(30.0), child: const CircularProgressIndicator()),
                        )
                      : CachedNetworkImage(
                          imageUrl: controller.purchaseCompleteItem.value.itemImageUrl,
                          fit: BoxFit.fitWidth,
                          placeholder: (context, url) => const CircularProgressIndicator(),
                          errorWidget: (context, url, error) => Image.asset("assets/images/@temp_badge.png"),
                        ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 15.0.sp),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                getItemGradeCircleIcon(controller.purchaseCompleteItem.value.itemGrade),
                if (controller.selectedItem.value.publishType == 'NFT')
                  Padding(
                    padding: EdgeInsets.only(left: 5.0.sp),
                    child: SvgPicture.asset('assets/images/shop/ico_nft_label.svg'),
                  ),
                Padding(
                  padding: EdgeInsets.only(left: 5.0.sp),
                  child: StyledText(
                    controller.purchaseCompleteItem.value.itemName,
                    fontSize: 18,
                    lineHeight: 20,
                    fontWeight: 500,
                  ),
                ),
              ],
            ),
          ),
          if (controller.purchaseCompleteItem.value.nftId != null)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15.sp, vertical: 8.sp),
              decoration: BoxDecoration(
                border: Border.all(color: deepGrayColor),
                borderRadius: BorderRadius.circular(30),
              ),
              child: StyledText(
                '#${controller.purchaseCompleteItem.value.nftId!}',
                fontSize: 14,
                lineHeight: 14,
                fontWeight: 600,
                color: deepGrayColor,
              ),
            ),
          Padding(
            padding: EdgeInsets.only(bottom: 20.0.sp),
            child: Column(
              children: [
                if (controller.purchaseCompleteItem.value.itemStat.durability! > 0)
                  Padding(
                    padding: EdgeInsets.only(top: 20.0.sp),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                iconStatDurability,
                                Padding(
                                  padding: EdgeInsets.only(left: 3.0),
                                  child: StyledText(
                                    '내구도',
                                    fontWeight: 500,
                                    fontSize: 14,
                                    lineHeight: 15,
                                  ),
                                ),
                              ],
                            ),
                            StyledText(
                              formatDecimalPlaces(controller.purchaseCompleteItem.value.itemStat.durability!, 0),
                              fontSize: 12,
                              fontWeight: 500,
                              color: purpleColor,
                              letterSpacing: -.1,
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 8.0.sp),
                          child: ClipRRect(
                            child: SizedBox(
                              height: 11,
                              child: Stack(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: subBg02Color,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(50.sp),
                                      ),
                                    ),
                                  ),
                                  LayoutBuilder(
                                    builder: (context, constraints) {
                                      return Container(
                                        width: constraints.maxWidth / (double.parse(controller.itemDurabilityMax.value) / controller.purchaseCompleteItem.value.itemStat.durability!),
                                        decoration: BoxDecoration(
                                          color: purpleColor,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(30.sp),
                                          ),
                                        ),
                                      );
                                    },
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                // 체력
                if (controller.purchaseCompleteItem.value.itemStat.stamina! > 0)
                  Padding(
                    padding: EdgeInsets.only(top: 16.0.sp),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                iconStatStamina,
                                Padding(
                                  padding: EdgeInsets.only(left: 3.0),
                                  child: StyledText(
                                    '체력',
                                    fontWeight: 500,
                                    fontSize: 14,
                                    lineHeight: 15,
                                  ),
                                ),
                              ],
                            ),
                            StyledText(
                              formatDecimalPlaces(controller.purchaseCompleteItem.value.itemStat.stamina!, 0),
                              fontSize: 12,
                              fontWeight: 500,
                              color: lightGreenColor,
                              letterSpacing: -.1,
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 8.0.sp),
                          child: ClipRRect(
                            child: SizedBox(
                              height: 11,
                              child: Stack(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: subBg02Color,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(50.sp),
                                      ),
                                    ),
                                  ),
                                  LayoutBuilder(
                                    builder: (context, constraints) {
                                      return Container(
                                        width: constraints.maxWidth / (double.parse(controller.itemHealthMax.value) / controller.purchaseCompleteItem.value.itemStat.stamina!),
                                        decoration: BoxDecoration(
                                          color: lightGreenColor,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(30.sp),
                                          ),
                                        ),
                                      );
                                    },
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                // Go 보상
                if (controller.purchaseCompleteItem.value.itemStat.goProfit! > 0)
                  Padding(
                    padding: EdgeInsets.only(top: 16.0.sp),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                iconStatGo,
                                Padding(
                                  padding: EdgeInsets.only(left: 3.0),
                                  child: StyledText(
                                    'GO 보상',
                                    fontWeight: 500,
                                    fontSize: 14,
                                    lineHeight: 15,
                                  ),
                                ),
                              ],
                            ),
                            StyledText(
                              formatDecimalPlaces(controller.purchaseCompleteItem.value.itemStat.goProfit!, 0),
                              fontSize: 12,
                              fontWeight: 500,
                              color: skyBlueColor,
                              letterSpacing: -.1,
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 8.0.sp),
                          child: ClipRRect(
                            child: SizedBox(
                              height: 11,
                              child: Stack(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: subBg02Color,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(50.sp),
                                      ),
                                    ),
                                  ),
                                  LayoutBuilder(
                                    builder: (context, constraints) {
                                      return Container(
                                        width: constraints.maxWidth / (double.parse(controller.itemGoMax.value) / controller.purchaseCompleteItem.value.itemStat.goProfit!),
                                        decoration: BoxDecoration(
                                          color: skyBlueColor,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(30.sp),
                                          ),
                                        ),
                                      );
                                    },
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                // 행운
                if (controller.purchaseCompleteItem.value.itemStat.luck! > 0)
                  Padding(
                    padding: EdgeInsets.only(top: 16.0.sp),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                iconStatLuck,
                                Padding(
                                  padding: EdgeInsets.only(left: 3.0),
                                  child: StyledText(
                                    '행운',
                                    fontWeight: 500,
                                    fontSize: 14,
                                    lineHeight: 15,
                                  ),
                                ),
                              ],
                            ),
                            StyledText(
                              formatDecimalPlaces(controller.purchaseCompleteItem.value.itemStat.luck!, 0),
                              fontSize: 12,
                              fontWeight: 500,
                              color: pinkColor,
                              letterSpacing: -.1,
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 8.0.sp),
                          child: ClipRRect(
                            child: SizedBox(
                              height: 11,
                              child: Stack(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: subBg02Color,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(50.sp),
                                      ),
                                    ),
                                  ),
                                  LayoutBuilder(
                                    builder: (context, constraints) {
                                      return Container(
                                        width: constraints.maxWidth / (double.parse(controller.itemLuckMax.value) / controller.purchaseCompleteItem.value.itemStat.luck!),
                                        decoration: BoxDecoration(
                                          color: pinkColor,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(30.sp),
                                          ),
                                        ),
                                      );
                                    },
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: 35.0.sp,
              bottom: 30.sp,
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    StyledText(
                      '내장비 > 아이템',
                      fontWeight: 500,
                      fontSize: 14,
                      lineHeight: 20,
                      color: skyBlueColor,
                    ),
                    StyledText(
                      ' 카테고리에서',
                      fontWeight: 500,
                      fontSize: 14,
                      lineHeight: 20,
                      color: lightGrayColor,
                    )
                  ],
                ),
                StyledText(
                  '획득한 뱃지를 확인하실수 있습니다.',
                  fontWeight: 500,
                  fontSize: 14,
                  lineHeight: 20,
                  color: lightGrayColor,
                ),
              ],
            ),
          )
        ],
      );
    }),
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

void itemPurchaseImpossibleAlert() {
  showAlert(
    title: '구매가 불가합니다',
    contentWidget: Padding(
      padding: EdgeInsets.only(top: 20.0.sp, bottom: 40.sp),
      child: const StyledText(
        '재고가 모두 소진되었거나 관리자에 의해\n판매가 중지 되었습니다\n불편을 끼쳐드려  죄송합니다',
        fontSize: 18,
        lineHeight: 24,
        fontWeight: 500,
        letterSpacing: .2,
        textAlign: TextAlign.center,
      ),
    ),
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

void itemSortListAlert(ShopController controller) {
  showAlert(
    contentWidget: Padding(
      padding: EdgeInsets.only(top: 20.0.sp, bottom: 40.sp),
      child: Obx(
        () {
          return Column(
            children: [
              ...controller.sortingList.asMap().entries.map(
                    (entry) => Padding(
                      padding: EdgeInsets.only(top: entry.key > 0 ? 40.sp : 0),
                      child: InkWell(
                        onTap: () => controller.onClickSortingMenu(entry.value),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            StyledText(
                              entry.value['title']!,
                              fontSize: 18,
                              lineHeight: 20,
                              fontWeight: 500,
                              color: controller.isSelectedSortValue.value['value'] == entry.value['value'] ? skyBlueColor : Colors.white,
                            ),
                            if (controller.isSelectedSortValue.value['value'] == entry.value['value']) iconSortChecked
                          ],
                        ),
                      ),
                    ),
                  ),
            ],
          );
        },
      ),
    ),
    actions: [
      Expanded(
        child: GazagoButton(
          onTap: () => controller.closeSortingMenu(),
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
          onTap: () => controller.onClickConfirmSortValue(controller.isSelectedSortValue.value),
          buttonText: '적용하기',
          buttonColor: skyBlueColor,
        ),
      ),
    ],
  );
}

void itemFilterListAlert(ShopController controller) {
  showAlert(
    isScrollControlled: true,
    contentWidget: Padding(
      padding: EdgeInsets.only(bottom: 40.sp),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(() {
            return Padding(
              padding: EdgeInsets.only(bottom: 10.0.sp),
              child: Align(
                alignment: Alignment.topRight,
                child: InkWell(
                  onTap: () => controller.onSelectAllItems(),
                  child: Container(
                    decoration: BoxDecoration(
                      color: controller.isSelectAllItems.value ? Colors.white : popupBgColor,
                      border: Border.all(
                        width: 1,
                        color: Colors.white,
                      ),
                      borderRadius: BorderRadius.circular(20.sp),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.0.sp, vertical: 6.sp),
                      child: StyledText(
                        '전체',
                        fontSize: 14,
                        lineHeight: 16,
                        letterSpacing: .2,
                        fontWeight: 500,
                        color: controller.isSelectAllItems.value ? Colors.black : Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
          Padding(
            padding: EdgeInsets.only(bottom: 10.0.sp),
            child: const StyledText(
              '카테고리',
              fontWeight: 500,
              fontSize: 16,
              lineHeight: 22,
            ),
          ),
          Obx(() {
            return SizedBox(
              width: double.infinity,
              child: Wrap(
                children: [
                  ...controller.categoryFilterList.asMap().entries.map(
                        (entry) => Padding(
                          padding: EdgeInsets.only(right: 10.sp, bottom: 10.sp),
                          child: InkWell(
                            onTap: () => controller.onSelectCategory(entry.value['value']),
                            child: Container(
                              decoration: BoxDecoration(
                                color: controller.selectedCategory.any((element) => element == entry.value['value']) ? Colors.white : popupBgColor,
                                border: Border.all(
                                  width: 1,
                                  color: Colors.white,
                                ),
                                borderRadius: BorderRadius.circular(20.sp),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 12.0.sp, vertical: 6.sp),
                                child: StyledText(
                                  entry.value['title']!,
                                  fontSize: 14,
                                  lineHeight: 16,
                                  letterSpacing: .2,
                                  fontWeight: 500,
                                  color: controller.selectedCategory.any((element) => element == entry.value['value']) ? Colors.black : Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                ],
              ),
            );
          }),
          Padding(
            padding: EdgeInsets.only(bottom: 10.0.sp, top: 20.sp),
            child: const StyledText(
              '등급',
              fontWeight: 500,
              fontSize: 16,
              lineHeight: 22,
            ),
          ),
          Obx(() {
            return SizedBox(
              width: double.infinity,
              child: Wrap(
                children: [
                  ...controller.gradeFilterList.asMap().entries.map(
                        (entry) => Padding(
                          padding: EdgeInsets.only(right: 8.sp, bottom: 10.sp),
                          child: InkWell(
                            onTap: () => controller.onSelectGrade(entry.value['value']),
                            child: Container(
                              decoration: BoxDecoration(
                                color: controller.selectedGrade.any((element) => element == entry.value['value']) ? getItemGradeColor(entry.value['value']!) : popupBgColor,
                                border: Border.all(
                                  width: 1,
                                  color: getItemGradeColor(entry.value['value']!),
                                ),
                                borderRadius: BorderRadius.circular(20.sp),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 12.0.sp, vertical: 6.sp),
                                child: StyledText(
                                  entry.value['title']!,
                                  fontSize: 14,
                                  lineHeight: 16,
                                  letterSpacing: .2,
                                  fontWeight: 500,
                                  color: controller.selectedGrade.any((element) => element == entry.value['value']) ? Colors.black : getItemGradeColor(entry.value['value']!),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                ],
              ),
            );
          }),
        ],
      ),
    ),
    actions: [
      Expanded(
        child: GazagoButton(
          onTap: () => controller.closeItemFilterPopup(),
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
          onTap: () => controller.onClickConfirmFilterValue(),
          buttonText: '적용하기',
          buttonColor: skyBlueColor,
        ),
      ),
    ],
  );
}

void showTelecomList(controller) {
  showAlert(
      isNonePaddingOuter: true,
      isScrollControlled: true,
      contentWidget: Container(
        padding: EdgeInsets.symmetric(vertical: 12.sp),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 6, bottom: 32),
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xffd9d9d9),
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: StyledText(
                '통신사 선택',
                fontWeight: 500,
                fontSize: 20,
              ),
            ),
            Column(
              children: [
                ...MobileCompany.values.map((telecom) {
                  return SizedBox(
                    width: double.infinity,
                    child: MaterialButton(
                      padding: const EdgeInsets.all(20),
                      textColor: lightGrayColor,
                      onPressed: () => controller!.updateTelecom(telecom),
                      child: Text(
                        telecom.mobileCompanyName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          height: 1,
                        ),
                      ),
                    ),
                  );
                })
              ],
            )
          ],
        ),
      ),
      actions: []);
}

void showInvalidVerifyCode(String errorMsg) {
  showAlert(
    contentWidget: Padding(
      padding: EdgeInsets.only(bottom: 35.0.sp),
      child: StyledText(
        errorMsg,
        fontSize: 18,
        lineHeight: 24,
        fontWeight: 500,
        textAlign: TextAlign.center,
      ),
    ),
    actions: [
      Expanded(
        child: GazagoButton(
          onTap: () => Get.until((route) => Get.currentRoute == Routes.verificationName),
          buttonText: '확인',
          buttonColor: skyBlueColor,
        ),
      ),
    ],
  );
}

void showInvalidCertCode(String errorMsg) {
  showAlert(
    contentWidget: Padding(
      padding: EdgeInsets.only(bottom: 35.0.sp),
      child: StyledText(
        errorMsg,
        fontSize: 18,
        lineHeight: 24,
        fontWeight: 500,
        textAlign: TextAlign.center,
      ),
    ),
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

void alreadyConnectedDeviceAlert(LoginController controller, LoginType socialType, String accessToken) {
  showAlert(
    title: '확인 요청',
    contentWidget: Padding(
      padding: EdgeInsets.only(top: 20.0.sp, bottom: 40.sp),
      child: const StyledText(
        '댜른 기기에 로그인 되어 있어요.\n해당 기기의 로그인 해제 후 로그인할게요.',
        fontSize: 18,
        lineHeight: 24,
        fontWeight: 500,
        letterSpacing: .2,
        textAlign: TextAlign.center,
      ),
    ),
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
          onTap: () => controller.requestLogin(socialType, accessToken, forceLogin: true),
          buttonText: '네',
          buttonColor: skyBlueColor,
        ),
      ),
    ],
  );
}

Future<void> showForceLogoutAlert() {
  Completer forceLogoutAlertCompleter = Completer();
  showAlert(
    title: '확인 완료',
    contentWidget: Padding(
      padding: EdgeInsets.only(top: 20.0.sp, bottom: 40.sp),
      child: const StyledText(
        '사용 중인 계정이 다른 기기에서\n로그인하여 접속이 종료되었어요.',
        fontSize: 18,
        lineHeight: 24,
        fontWeight: 500,
        letterSpacing: .2,
        textAlign: TextAlign.center,
      ),
    ),
    actions: [
      Expanded(
        child: GazagoButton(
          onTap: () => forceLogoutAlertCompleter.complete(),
          buttonText: '확인',
          buttonColor: skyBlueColor,
        ),
      ),
    ],
  );

  return forceLogoutAlertCompleter.future;
}

void showAdTipAlert(ExerciseType exerciseType) {
  Get.dialog(
    barrierColor: Colors.transparent,
    WillPopScope(
      onWillPop: () async => false,
      child: Material(
        color: Colors.black.withOpacity(0.6),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.0.sp),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(top: 19.sp, left: 18.sp, right: 18.sp, bottom: 50.sp),
                      decoration: BoxDecoration(
                        color: popupBgColor,
                        borderRadius: BorderRadius.circular(10.sp),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: StyledText(
                              '광고 시청 TIP',
                              fontSize: 18.sp,
                              lineHeight: 28.sp,
                              fontWeight: 500,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 29.0.sp),
                            child: Stack(children: [
                              Padding(
                                padding: EdgeInsets.only(bottom: 30.0.sp),
                                child: Container(
                                  width: double.infinity,
                                  height: 144.sp,
                                  decoration: BoxDecoration(
                                    color: skyBlueColor,
                                    border: Border.all(
                                      width: 1,
                                      style: BorderStyle.solid,
                                      color: Colors.black,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color.fromRGBO(0, 0, 0, 0.85),
                                        offset: const Offset(0, 2),
                                        blurRadius: 0,
                                        spreadRadius: 1.sp,
                                      )
                                    ],
                                    borderRadius: BorderRadius.circular(14.sp),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 32.sp, left: 10.sp, right: 10.sp),
                                    child: Column(
                                      children: [
                                        iconGo,
                                        Padding(
                                          padding: EdgeInsets.only(top: 12.sp),
                                          child: FittedBox(
                                            alignment: Alignment.topCenter,
                                            child: Text.rich(
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 20.sp,
                                                height: 24.sp / 18.sp,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black,
                                                fontFamily: 'Montserrat',
                                              ),
                                              TextSpan(
                                                text: [ExerciseType.walking, ExerciseType.hiking].any((type) => exerciseType == type) ? '1' : '3',
                                                children: const [
                                                  TextSpan(text: 'GO', style: TextStyle(fontWeight: FontWeight.w800)),
                                                  TextSpan(text: ' 획득하고 시작하기'),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(right: 20, top: 100, child: iconHand),
                            ]),
                          ),
                          Text.rich(
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 14.sp,
                              height: 22.sp / 14.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                            TextSpan(
                              text: '· ',
                              style: TextStyle(color: lightGrayColor),
                              children: [
                                TextSpan(
                                  text: '끝까지 광고를 시청하는 것',
                                  style: TextStyle(color: skyBlueColor),
                                ),
                                const TextSpan(
                                  text: '을 권장 드려요!',
                                ),
                              ],
                            ),
                          ),
                          Text.rich(
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 14.sp,
                              height: 22.sp / 14.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                            TextSpan(
                              text: '· ',
                              style: TextStyle(color: lightGrayColor),
                              children: [
                                TextSpan(
                                  text: '광고 보상은 당일의 GO 획득 기준이에요!',
                                ),
                              ],
                            ),
                          ),
                          Text.rich(
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 14.sp,
                              height: 22.sp / 14.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                            TextSpan(
                              text: '· ',
                              style: TextStyle(color: lightGrayColor),
                              children: [
                                TextSpan(
                                  text: '활동 종료의 광고 버튼이 비활성화 되는 경우',
                                  style: TextStyle(color: skyBlueColor),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 15.0.sp),
                            child: Wrap(
                              children: [
                                Text.rich(
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    height: 22.sp / 14.sp,
                                    fontWeight: FontWeight.w500,
                                    color: lightGrayColor,
                                  ),
                                  const TextSpan(
                                    text: '(1) 적립한 GO가 0 GO일 경우',
                                  ),
                                ),
                                Text.rich(
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    height: 22.sp / 14.sp,
                                    fontWeight: FontWeight.w500,
                                    color: lightGrayColor,
                                  ),
                                  const TextSpan(
                                    text: '(2) 활동 시간이 매일 자정(KST)이 지나간 경우',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(right: 14, top: 14, child: InkWell(onTap: () => Get.back(), child: iconCloseWhite)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

void showLeaderboardInfo() {
  Get.dialog(
    barrierColor: Colors.black.withOpacity(.8),
    Material(
      color: Colors.transparent,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25.0.sp),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(top: 49.sp, left: 29.sp, right: 29.sp, bottom: 50.sp),
                    decoration: BoxDecoration(
                      color: popupBgColor,
                      borderRadius: BorderRadius.circular(10.sp),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 84.sp,
                          child: Image.asset(
                            'assets/images/leaderboard/ico_info_tik.png',
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 20.0.sp),
                          child: Text.rich(
                            TextSpan(
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 20.sp,
                                color: Colors.white,
                                // height: 18.sp,
                              ),
                              children: [
                                TextSpan(
                                  text: '오늘 분배할',
                                ),
                                TextSpan(
                                    text: ' 전체 리워드',
                                    style: TextStyle(
                                      color: Color(0xFFFF87B5),
                                      // height: 18.sp,
                                    )),
                                TextSpan(
                                  text: '란?',
                                )
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 8.0.sp),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              StyledText(
                                '어제 가자고에서의 활동을 기준으로 확정돼요!',
                                color: lightGrayColor,
                                fontSize: 11,
                                lineHeight: 16,
                              ),
                              StyledText(
                                '오늘 리더보드 참여자에게 획득한 GO만큼 돌려드려요!',
                                color: lightGrayColor,
                                fontSize: 11,
                                lineHeight: 16,
                              ),
                              StyledText(
                                '매일 자정(한국시간기준)에 확정되고 돌려드려요!',
                                color: lightGrayColor,
                                fontSize: 11,
                                lineHeight: 16,
                              ),
                              Text.rich(
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  height: 18.sp / 11.sp,
                                  fontWeight: FontWeight.w400,
                                  color: lightGrayColor,
                                ),
                                TextSpan(
                                  text: '가자고 팀은 매출의 50~70%를 보상',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: '으로 돌려드리고 있어요',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        color: lightGrayColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              StyledText(
                                '오늘 분배할 전체 리워드는 아래 항목으로 구성됩니다!',
                                color: lightGrayColor,
                                fontSize: 11,
                                lineHeight: 16,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 36.sp),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: double.infinity,
                                child: Text.rich(
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    height: 22.sp / 14.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                  TextSpan(
                                    text: '1. 어제 사용된',
                                    children: [
                                      TextSpan(
                                        text: ' TIK의 합',
                                        style: TextStyle(
                                          color: tikColor,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 5.0.sp, left: 7.0.sp),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    StyledText(
                                      '· 체력 충전',
                                      fontSize: 12,
                                      lineHeight: 18,
                                      fontWeight: 400,
                                    ),
                                    StyledText(
                                      '· 신발 내구도 충전',
                                      fontSize: 12,
                                      lineHeight: 18,
                                      fontWeight: 400,
                                    ),
                                    StyledText(
                                      '· 일반 아이템 구매',
                                      fontSize: 12,
                                      lineHeight: 18,
                                      fontWeight: 400,
                                    ),
                                    StyledText(
                                      '· 상품권 교환에 사용된 일부 비용',
                                      fontSize: 12,
                                      lineHeight: 18,
                                      fontWeight: 400,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 12.sp),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: double.infinity,
                                child: Text.rich(
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    height: 22.sp / 14.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                  TextSpan(
                                    text: '2. 리더보드 참여자 ',
                                    children: [
                                      TextSpan(
                                        text: '추가 제공 보상',
                                        style: TextStyle(
                                          color: tikColor,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 5.0.sp, left: 7.0.sp),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    StyledText(
                                      '· 참여자 수 보상(TIK)',
                                      fontSize: 12,
                                      lineHeight: 18,
                                      fontWeight: 400,
                                    ),
                                    StyledText(
                                      '· 상위 순위 보상(STIK + TIK)',
                                      fontSize: 12,
                                      lineHeight: 18,
                                      fontWeight: 400,
                                    ),
                                    StyledText(
                                      '· 깜짝 순위 보상(STIK + TIK)',
                                      fontSize: 12,
                                      lineHeight: 18,
                                      fontWeight: 400,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 12.sp),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: double.infinity,
                                child: Text.rich(
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    height: 22.sp / 14.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                  TextSpan(
                                    text: '3. ',
                                    children: [
                                      TextSpan(
                                        text: '2달 전 사용된 STIK의 합',
                                        style: TextStyle(
                                          color: tikColor,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '을 TIK으로 제공',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 5.0.sp, left: 7.0.sp),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    StyledText(
                                      '· NFT 아이템 구매',
                                      fontSize: 12,
                                      lineHeight: 18,
                                      fontWeight: 400,
                                    ),
                                    StyledText(
                                      '· STIK으로 사용된 비용의 일부',
                                      fontSize: 12,
                                      lineHeight: 18,
                                      fontWeight: 400,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(right: 12, top: 20, child: InkWell(onTap: () => Get.back(), child: iconCloseWhite)),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

Future<void> showMainPopupAlert(NoticePopupController noticePopupController) async {
  final CarouselController carouselController = CarouselController();

  await Get.bottomSheet(
    isDismissible: false,
    isScrollControlled: true,
    WillPopScope(
      onWillPop: () async => false,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.transparent,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.max,
          children: [
            Stack(children: [
              CarouselSlider(
                key: const Key('Slider'),
                items: noticePopupController.noticePopupList
                    .map((item) => Container(
                          width: double.infinity,
                          child: InkWell(
                            onTap: () => noticePopupController.moveToWebView(item),
                            child: Image.network(
                              item.imageUrlKo!,
                              width: double.infinity,
                            ),
                          ),
                        ))
                    .toList(),
                carouselController: carouselController,
                options: CarouselOptions(
                  aspectRatio: 1,
                  viewportFraction: 1,
                  autoPlay: true,
                  enlargeCenterPage: false,
                  enableInfiniteScroll: false,
                  onPageChanged: (index, reason) {
                    noticePopupController.setCurrent(index);
                  },
                  onScrolled: (op) {
                    noticePopupController.setValue(op!);
                  },
                ),
              ),
              Positioned(
                  right: 20.sp,
                  top: 12.sp,
                  child: Obx(() {
                    return Container(
                      decoration: BoxDecoration(
                        color: popupBgColor,
                        borderRadius: BorderRadius.circular(20.sp),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0.sp, vertical: 4.0.sp),
                        child: StyledText(
                          '${(noticePopupController.current.value + 1).toString()}/${noticePopupController.noticePopupList.length}',
                          fontSize: 16,
                          lineHeight: 17,
                          fontWeight: 500,
                        ),
                      ),
                    );
                  })),
            ]),
            Container(
              color: popupBgColor,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0.sp),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () => noticePopupController.onSavePopupCloseDate(),
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 28.0.sp, horizontal: 10.sp),
                        child: const StyledText(
                          '오늘 그만 보기',
                          color: Color(0xFFB6B6B6),
                          fontSize: 16,
                          lineHeight: 16,
                          fontWeight: 500,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () => Get.back(),
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 28.0.sp, horizontal: 10.sp),
                        child: const StyledText(
                          '닫기',
                          fontWeight: 700,
                          fontSize: 16,
                          lineHeight: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

void showNotChallangeAbleAlert(ActivityController controller) {
  showAlert(
    contentWidget: Padding(
      padding: EdgeInsets.only(top: 20.0.sp, bottom: 40.sp),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 20.0.sp),
            child: SvgPicture.asset(
              'assets/images/common/ico_challange_marker.svg',
              width: 40.sp,
              height: 40.sp,
            ),
          ),
          const StyledText(
            '현재 챌린시 시작점 위치가 아닙니다.\n시작점은 챌린지 가이드에서 확인해보세요!',
            fontSize: 18,
            lineHeight: 24,
            fontWeight: 500,
            letterSpacing: .2,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
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
          onTap: () => {Get.back(), controller.moveToChallengeMap()},
          buttonText: '챌린지 가이드',
          buttonColor: skyBlueColor,
        ),
      ),
    ],
  );
}

void showStoreNotAvailableAlert() {
  showAlert(
    contentWidget: Container(
      child: Center(
        child: Column(
          children: [
            iconNoConnection,
            Padding(
              padding: const EdgeInsets.only(top: 14, bottom: 30),
              child: StyledText(
                '스토어와 연결 중에 예상하지\n못한 오류가 발생했습니다.\n잠시 후 다시 시도해 주세요',
                fontSize: 18.sp,
                fontWeight: 500,
                lineHeight: 24.sp,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    ),
    actions: [
      Expanded(
        child: GazagoButton(
          onTap: () => Get.until((route) => Get.isBottomSheetOpen == false && Get.isDialogOpen == false),
          buttonText: '확인',
          buttonColor: skyBlueColor,
        ),
      ),
    ],
  );
}

void showInAppPurchaseProgressAlert(WalletMasterController controller) {
  showAlert(
    contentWidget: Obx(() {
      return Container(
          child: controller.showPendingPurchaseUI.value
              ? Center(
                  child: Column(
                    children: [
                      Lottie.asset(
                        'assets/lottie/purchase_pending.json',
                        width: 40,
                        height: 40,
                        repeat: true,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: StyledText(
                          controller.showVerifyingPurchaseText.value ? 'TIK을 충전하고 있습니다.' : '결제 요청중입니다.',
                          fontSize: 18.sp,
                          fontWeight: 500,
                          lineHeight: 24.sp,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                )
              : Center(
                  child: controller.isPurchaseSuccessful.value
                      ? Column(
                          children: [
                            Lottie.asset(
                              'assets/lottie/purchase_success.json',
                              width: 40,
                              height: 40,
                              repeat: false,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 14, bottom: 30),
                              child: StyledText(
                                'TIK 충전이 완료되었습니다.',
                                fontSize: 18.sp,
                                fontWeight: 500,
                                lineHeight: 24.sp,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        )
                      : Column(
                          children: [
                            iconError,
                            Padding(
                              padding: const EdgeInsets.only(top: 14, bottom: 30),
                              child: StyledText(
                                controller.showStoreErrorText.value ? '결제를 하던 중 오류가 발생했습니다.\n잠시 후 다시 시도해 주세요.' : '결제는 완료 되었으나 TIK 충전에 실패하였습니다.\n고객센터(cs@staika.io)에 문의해 주세요.',
                                fontSize: 18.sp,
                                fontWeight: 500,
                                lineHeight: 24.sp,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                ));
    }),
    actions: [
      Obx(() {
        if (controller.showPendingPurchaseUI.value != true) {
          return Expanded(
            child: GazagoButton(
              onTap: () => Get.back(),
              buttonText: '확인',
              buttonColor: skyBlueColor,
            ),
          );
        } else {
          return Container();
        }
      }),
    ],
  );
}

Future<bool> verifyEndPointPasswordAlert(DebuggingController controller) {
  Completer<bool> passwordInputCompleter = Completer();
  controller.endPointPasswordController.text = '';
  showAlert(
    contentWidget: Center(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 14, bottom: 30),
            child: StyledText(
              '비밀번호를 입력해주세요.',
              fontSize: 18.sp,
              fontWeight: 500,
              lineHeight: 24.sp,
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: TextField(
              onSubmitted: (String text) async {
                passwordInputCompleter.complete(await controller.verifyEndPointPassword());
              },
              decoration: InputDecoration(
                focusColor: skyBlueColor,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: skyBlueColor,
                  ),
                ),
              ),
              textAlign: TextAlign.center,
              textInputAction: TextInputAction.go,
              controller: controller.endPointPasswordController,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    ),
    actions: [
      Expanded(
        child: GazagoButton(
          onTap: () {
            Get.back();
            passwordInputCompleter.complete(false);
          },
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
          onTap: () async {
            passwordInputCompleter.complete(await controller.verifyEndPointPassword());
          },
          buttonText: '확인',
          buttonColor: skyBlueColor,
        ),
      ),
    ],
  );

  return passwordInputCompleter.future;
}

void showStaikaStatusAlert({required bool hasWallet, TabController? tabController}) {
  showAlert(
    contentWidget: Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 28, bottom: 28),
          child: Text.rich(
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22.sp,
              height: 22.sp / 22.sp,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
            TextSpan(
              text: 'Staika Wallet을 ',
              children: [
                TextSpan(text: hasWallet ? '연결' : '생성', style: TextStyle(color: skyBlueColor)),
                TextSpan(text: hasWallet ? '했습니다.' : '합니다.'),
              ],
            ),
          ),
        ),
        hasWallet
            ? Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: Row(
                      children: [
                        Container(
                          width: 2,
                          height: 2,
                          margin: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: lightGrayColor,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        Expanded(
                          child: StyledText(
                            'gazaGO 계정과 동일한 계정으로 생성되어 있는 Staika Wallet이 있어 연결했습니다.',
                            fontSize: 16,
                            lineHeight: 24,
                            fontWeight: 500,
                            color: lightGrayColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: Row(
                      children: [
                        Container(
                          width: 2,
                          height: 2,
                          margin: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: lightGrayColor,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        Expanded(
                          child: StyledText(
                            'Staika Wallet에 사용 중인 지갑 주소와 이체 비밀번호를 동일하게 사용하실 수 있습니다.',
                            fontSize: 16,
                            lineHeight: 24,
                            fontWeight: 500,
                            color: lightGrayColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: Row(
                      children: [
                        Container(
                          width: 2,
                          height: 2,
                          margin: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: lightGrayColor,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        Expanded(
                          child: StyledText(
                            '모두가 누리는 스마트한 자산관리! 편하고 안전한 블록체인 지갑, Staika Wallet을 생성합니다.',
                            fontSize: 16,
                            lineHeight: 24,
                            fontWeight: 500,
                            color: lightGrayColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: Row(
                      children: [
                        Container(
                          width: 2,
                          height: 2,
                          margin: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: lightGrayColor,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        Expanded(
                          child: StyledText(
                            '이체 비밀번호 설정만으로 가입이 완료됩니다.',
                            fontSize: 16,
                            lineHeight: 24,
                            fontWeight: 500,
                            color: lightGrayColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ],
    ),
    actions: [
      hasWallet
          ? Expanded(
              child: GazagoButton(
                onTap: () async {
                  Get.back();
                },
                buttonText: '확인',
                buttonColor: skyBlueColor,
              ),
            )
          : Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: GazagoButton(
                      onTap: () {
                        tabController?.animateTo(0);
                        Get.back();
                      },
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
                      onTap: () async {
                        Get.back();
                        Get.toNamed(Routes.joinTerms, arguments: {'platform': 'wallet'});
                      },
                      buttonText: '네',
                      buttonColor: skyBlueColor,
                    ),
                  ),
                ],
              ),
            ),
    ],
  );
}

void exchangeStikToTikAlert(GoWalletController controller, ExchangeStikPriceModel exchangeProduct) {
  WalletMasterController walletMasterController = Get.find();
  showAlert(
    title: '충전 하시겠습니까?',
    isScrollControlled: true,
    contentWidget: Obx(() {
      return Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 34.0.sp, bottom: 43.sp),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset('assets/images/wallet/ico_stik.svg', width: 24, height: 24),
                    Padding(
                      padding: EdgeInsets.only(left: 7.0.sp),
                      child: StyledText(
                        formatDecimalPlaces(exchangeProduct.fromUiAmount!, 9, isAutoDecimal: true),
                        fontSize: 30,
                        lineHeight: 32,
                        fontWeight: 600,
                        letterSpacing: -.1,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 7.0.sp),
                      child: StyledText(
                        exchangeProduct.fromTokenSymbol!,
                        fontSize: 30,
                        lineHeight: 32,
                        fontWeight: 400,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 15.0.sp),
                  child: SvgPicture.asset('assets/images/wallet/ico_arrow_bottom.svg', width: 20, height: 20),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset('assets/images/wallet/ico_tik.svg', width: 24, height: 24),
                    Padding(
                      padding: EdgeInsets.only(left: 7.0.sp),
                      child: StyledText(
                        formatDecimalPlaces(double.parse(exchangeProduct.toUiAmount.toString()), 0),
                        fontSize: 30,
                        lineHeight: 32,
                        fontWeight: 600,
                        letterSpacing: -.1,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 7.0.sp),
                      child: StyledText(
                        exchangeProduct.toTokenSymbol!,
                        fontSize: 30,
                        lineHeight: 32,
                        fontWeight: 400,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              StyledText(
                '기준 가격',
                fontWeight: 500,
                fontSize: 14,
                color: lightGrayColor,
              ),
              StyledText(
                '1 STIK = ₩${formatDecimalPlaces(walletMasterController.stikPriceInfoKRW.value.price!, 0)}',
                fontWeight: 500,
                fontSize: 14,
                color: lightGrayColor,
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 15.0.sp, bottom: 23.0.sp),
            child: const Divider(
              color: Color(0xFF474950),
              height: 3,
              thickness: 1,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 10.sp),
            child: StyledText(
              '충전이 완료되면 취소할 수 없습니다.',
              fontSize: 14,
              lineHeight: 15,
              fontWeight: 500,
              letterSpacing: -0.02,
              color: lightGrayColor,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 20.0.sp),
            child: StyledText(
              '1 STIK = ₩ ${formatDecimalPlaces(walletMasterController.stikPriceInfoKRW.value.price!, 0)} / ${formatDate(walletMasterController.stikPriceInfoKRW.value.lastUpdated)} (CoinMarket Cap)',
              fontSize: 13,
              lineHeight: 15,
              fontWeight: 500,
              color: deepGrayColor,
              letterSpacing: -0.02,
            ),
          ),
        ],
      );
    }),
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
          onTap: () {
            Get.back();
            controller.exchangeStikToTik(exchangeProduct);
          },
          buttonText: '충전',
          buttonColor: skyBlueColor,
        ),
      ),
    ],
  );
}

void failureChargeStikToTikAlert(GoWalletController controller, String errorMsg) {
  showAlert(
    title: '잠시 후 다시 시도해 주세요.',
    contentWidget: Padding(
      padding: EdgeInsets.only(top: 20.0.sp, bottom: 40.sp),
      child: StyledText(
        errorMsg,
        fontSize: 14,
        lineHeight: 20,
        fontWeight: 500,
        letterSpacing: .2,
        color: lightGrayColor,
        textAlign: TextAlign.center,
      ),
    ),
    actions: [
      Expanded(
        child: GazagoButton(
          onTap: () {
            Get.back();
            controller.handleReGetStikPriceAndProductList();
          },
          buttonText: '확인',
          buttonColor: skyBlueColor,
        ),
      ),
    ],
  );
}

void successChargeStikToTikAlert(GoWalletController controller) {
  showAlert(
    contentWidget: Padding(
      padding: EdgeInsets.only(top: 20.0.sp, bottom: 40.sp),
      child: Column(
        children: [
          iconCircleSkyBlueCheck,
          Padding(
            padding: EdgeInsets.only(top: 20.0.sp),
            child: const StyledText(
              'TIK 충전이 완료 되었습니다.',
              fontSize: 18,
              lineHeight: 24,
              fontWeight: 500,
              letterSpacing: .2,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    ),
    actions: [
      Expanded(
        child: GazagoButton(
          onTap: () {
            Get.back();
            controller.handleSuccessChargeTik();
          },
          buttonText: '확인',
          buttonColor: skyBlueColor,
        ),
      ),
    ],
  );
}

void sendStikToGoWalletAlert(StaikaWalletController controller) {
  WalletMasterController walletMasterController = Get.find();
  showAlert(
    title: '전송 하시겠습니까?',
    isScrollControlled: true,
    contentWidget: Obx(() {
      return Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 34.0.sp, bottom: 30.sp),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset('assets/images/wallet/ico_stik.svg', width: 24, height: 24),
                    Padding(
                      padding: EdgeInsets.only(left: 7.0.sp),
                      child: StyledText(
                        formatDecimalPlaces(
                          double.parse(controller.sendStikUiAmount.value),
                          controller.assetStik.value!.decimals,
                          isAutoDecimal: true,
                        ),
                        fontSize: 30,
                        lineHeight: 32,
                        fontWeight: 600,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 7.0.sp),
                      child: StyledText(
                        'STIK',
                        fontSize: 30,
                        lineHeight: 32,
                        fontWeight: 400,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 23.0.sp),
            child: const Divider(
              color: Color(0xFF1D1D26),
              height: 3,
              thickness: 1,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 30.sp),
            child: StyledText(
              '· 전송이 완료되면 취소할 수 없습니다.',
              fontSize: 14,
              lineHeight: 15,
              fontWeight: 500,
              letterSpacing: -0.02,
              color: lightGrayColor,
            ),
          ),
        ],
      );
    }),
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
          onTap: () async {
            Get.back();
            if (double.parse(controller.shortStikUiAmount.value) >= 0) {
              String? password = await showConfirmPasswordDialog(walletMasterController);
              controller.confirmSendStikToGoWallet(password);
            } else {
              String? password = await showConfirmPasswordDialog(walletMasterController);
              controller.confirmSendStikToGoWallet(password);
            }
          },
          buttonText: '네',
          buttonColor: skyBlueColor,
        ),
      ),
    ],
  );
}

void failureShortBalanceStikToTikAlert(GoWalletController controller) {
  showAlert(
    title: '잔액이 부족해 진행할 수 없습니다.',
    contentWidget: Padding(
      padding: EdgeInsets.only(top: 20.0.sp, bottom: 40.sp),
      child: StyledText(
        '부족한 STIK을 충전한 후 다시 시도해 주세요.',
        fontSize: 14,
        lineHeight: 20,
        fontWeight: 500,
        letterSpacing: .2,
        color: lightGrayColor,
        textAlign: TextAlign.center,
      ),
    ),
    actions: [
      Expanded(
        child: GazagoButton(
          onTap: () {
            Get.back();
            controller.handleReGetStikPriceAndProductList();
          },
          buttonText: '확인',
          buttonColor: skyBlueColor,
        ),
      ),
    ],
  );
}

void exchangeStikShortBalanceAlert(StaikaWalletController controller) {
  WalletMasterController walletMasterController = Get.find();
  showAlert(
    title: '잔액이 부족해 진행할 수 없습니다.',
    isScrollControlled: true,
    contentWidget: Obx(() {
      return Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 34.0.sp, bottom: 30.sp),
            child: Column(
              children: [
                Opacity(
                  opacity: 0.4,
                  child: FittedBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset('assets/images/wallet/ico_stik.svg', width: 24, height: 24),
                        Padding(
                          padding: EdgeInsets.only(left: 7.0.sp),
                          child: StyledText(
                            formatDecimalPlaces(
                              double.parse(controller.sendStikUiAmount.value),
                              controller.assetStik.value!.decimals,
                              isAutoDecimal: true,
                            ),
                            fontSize: 30,
                            lineHeight: 32,
                            fontWeight: 600,
                            letterSpacing: -.1,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 7.0.sp),
                          child: StyledText(
                            'STIK',
                            fontSize: 30,
                            lineHeight: 32,
                            fontWeight: 400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 60.0.sp),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      StyledText(
                        '필요한 STIK',
                        fontWeight: 500,
                        fontSize: 16,
                        letterSpacing: -.2,
                      ),
                      StyledText(
                        '${formatDecimalPlaces(double.parse(controller.shortStikUiAmount.value), controller.assetStik.value!.decimals, isAutoDecimal: true)} STIK',
                        fontWeight: 500,
                        fontSize: 16,
                        letterSpacing: -.2,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 24.0.sp),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      StyledText(
                        '잔액 STIK',
                        fontWeight: 500,
                        fontSize: 16,
                        letterSpacing: -.2,
                      ),
                      StyledText(
                        '${controller.assetStik.value!.uiAmount.toString()} STIK',
                        fontWeight: 500,
                        fontSize: 16,
                        letterSpacing: -.2,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 23.0.sp),
            child: const Divider(
              color: Color(0xFF1D1D26),
              height: 3,
              thickness: 1,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 30.sp),
            child: StyledText(
              '· 부족한 STIK을 충전한 후 다시 시도해 주세요.',
              fontSize: 14,
              lineHeight: 15,
              fontWeight: 500,
              letterSpacing: -0.02,
              color: lightGrayColor,
            ),
          ),
        ],
      );
    }),
    actions: [
      Expanded(
        child: GazagoButton(
          onTap: () async {
            Get.back();
          },
          buttonText: '확인',
          buttonColor: skyBlueColor,
        ),
      ),
    ],
  );
}

void successExchangeStikToGoWalletAlert(StaikaWalletController controller) {
  showAlert(
    contentWidget: Padding(
      padding: EdgeInsets.only(top: 20.0.sp, bottom: 40.sp),
      child: Column(
        children: [
          Column(
            children: [
              const StyledText(
                '보내기 신청이 완료 되었습니다.',
                fontSize: 18,
                lineHeight: 24,
                fontWeight: 500,
                letterSpacing: .2,
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.0.sp),
                child: StyledText(
                  '결과는 잠시 후 거래 내역에서 조회 가능합니다.',
                  fontSize: 16,
                  lineHeight: 24,
                  fontWeight: 500,
                  letterSpacing: .2,
                  color: lightGrayColor,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
    actions: [
      Expanded(
        child: GazagoButton(
          onTap: () {
            Get.until((route) => Get.currentRoute == Routes.wallet);
            controller.getStaikaWalletInfo();
          },
          buttonText: '확인',
          buttonColor: skyBlueColor,
        ),
      ),
    ],
  );
}

void failureExchangeStikToGoWalletAlert() {
  showAlert(
    contentWidget: Padding(
      padding: EdgeInsets.only(top: 20.0.sp, bottom: 40.sp),
      child: Column(
        children: [
          Column(
            children: [
              const StyledText(
                '잠시 후 다시 시도해 주세요.',
                fontSize: 18,
                lineHeight: 24,
                fontWeight: 500,
                letterSpacing: .2,
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.0.sp),
                child: StyledText(
                  '블록체인 네트워크 이상으로 완료하지 못했습니다.',
                  fontSize: 16,
                  lineHeight: 24,
                  fontWeight: 500,
                  letterSpacing: .2,
                  color: lightGrayColor,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
    actions: [
      Expanded(
        child: GazagoButton(
          onTap: () {
            Get.back();
          },
          buttonText: '확인',
          buttonColor: skyBlueColor,
        ),
      ),
    ],
  );
}

void showNeedVerificationAlert(WalletMasterController controller) {
  showAlert(
    title: '본인인증이 필요합니다.',
    contentText: '상품권 교환을 위해서는 본인인증이 필요하여\n인증페이지로 이동합니다.',
    actions: [
      Expanded(
        child: GazagoButton(
          onTap: () => controller.moveToVerification(),
          buttonText: '확인',
          buttonColor: skyBlueColor,
        ),
      ),
    ],
  );
}

void showForceUpdateWallet() {
  showAlert(
    title: '새 업데이트가 있습니다.',
    contentText: '앱을 사용하기 위해서 업데이트가 필요합니다.',
    actions: [
      Expanded(
        child: GazagoButton(
          onTap: () {
            if (Platform.isAndroid || Platform.isIOS) {
              final url = Uri.parse(
                Platform.isAndroid ? "https://gazago.page.link/update_android" : "https://gazago.page.link/update_ios",
              );
              launchUrl(
                url,
                mode: LaunchMode.externalApplication,
              );
            }
          },
          buttonText: '업데이트',
          buttonColor: skyBlueColor,
        ),
      ),
    ],
  );
}

void showRecommendUpdateWallet() {
  showAlert(
    title: '새 업데이트가 있습니다.',
    contentText: '앱을 사용하기 위해서 업데이트가 필요합니다.',
    actions: [
      Expanded(
        child: GazagoButton(
          onTap: () => Get.offAllNamed(Routes.home),
          buttonText: '무시하기',
          textColor: Colors.white,
          buttonColor: popupBgColor,
        ),
      ),
      const SizedBox(
        width: 9,
      ),
      Expanded(
        child: GazagoButton(
          onTap: () {
            if (Platform.isAndroid || Platform.isIOS) {
              final url = Uri.parse(
                Platform.isAndroid ? "https://gazago.page.link/update_android" : "https://gazago.page.link/update_ios",
              );
              launchUrl(
                url,
                mode: LaunchMode.externalApplication,
              );
            }
          },
          buttonText: '업데이트',
          buttonColor: skyBlueColor,
        ),
      ),
    ],
  );
}
