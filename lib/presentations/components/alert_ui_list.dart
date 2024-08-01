import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart' as sp;
import 'package:gaza_go/constants/config.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/constants/routes.dart';
import 'package:gaza_go/platform/controllers/activity_controller.dart';
import 'package:gaza_go/platform/controllers/archive_controller.dart';
import 'package:gaza_go/platform/controllers/challenges_controller.dart';
import 'package:gaza_go/platform/controllers/challenges_detail_controller.dart';
import 'package:gaza_go/platform/controllers/collection_detail_controller.dart';
import 'package:gaza_go/platform/controllers/crew_detail_controller.dart';
import 'package:gaza_go/platform/controllers/daily_benefit_controller.dart';
import 'package:gaza_go/platform/controllers/debugging_controller.dart';
import 'package:gaza_go/platform/controllers/home_menu_controller.dart';
import 'package:gaza_go/platform/controllers/inventory_controller.dart';
import 'package:gaza_go/platform/controllers/inventory_home_controller.dart';
import 'package:gaza_go/platform/controllers/loading_controller.dart';
import 'package:gaza_go/platform/controllers/login_controller.dart';
import 'package:gaza_go/platform/controllers/my_page_controller.dart';
import 'package:gaza_go/platform/controllers/notice_popup_controller.dart';
import 'package:gaza_go/platform/controllers/preference_controller.dart';
import 'package:gaza_go/platform/controllers/shop_controller.dart';
import 'package:gaza_go/platform/controllers/shop_detail_controller.dart';
import 'package:gaza_go/platform/controllers/wallet_go_controller.dart';
import 'package:gaza_go/platform/controllers/wallet_master_controller.dart';
import 'package:gaza_go/platform/controllers/wallet_on_chain_nft_detail_controller.dart';
import 'package:gaza_go/platform/controllers/wallet_staika_controller.dart';
import 'package:gaza_go/platform/controllers/withdraw_confirm_controller.dart';
import 'package:gaza_go/platform/events/index.dart';
import 'package:gaza_go/platform/helpers/activity_mixin.dart';
import 'package:gaza_go/platform/helpers/alert_helper.dart';
import 'package:gaza_go/platform/helpers/base_helper.dart';
import 'package:gaza_go/platform/helpers/inventory_helper.dart';
import 'package:gaza_go/platform/models/challenge_course_model.dart';
import 'package:gaza_go/platform/models/challenge_landing_model.dart';
import 'package:gaza_go/platform/models/crew_icon_model.dart';
import 'package:gaza_go/platform/models/crew_model.dart';
import 'package:gaza_go/platform/models/exchange_stik_price_model.dart';
import 'package:gaza_go/platform/models/gathering_condition_model.dart';
import 'package:gaza_go/platform/models/inventory_item_model.dart';
import 'package:gaza_go/platform/models/push_message_challenge_success_model.dart';
import 'package:gaza_go/presentations/components/circular_button.dart';
import 'package:gaza_go/presentations/components/fair_play_content.dart';
import 'package:gaza_go/presentations/components/gazago_button.dart';
import 'package:gaza_go/presentations/components/item_counter.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/icons.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:gaza_go/theme/theme.g.dart';
import 'package:get/get.dart';
import 'package:get_event_bus/get_event_bus.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
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

// void showShoeRepairSlider(InventoryController controller, int feeTikDurability, int itemId) {
//   showAlert(
//     title: '신발 내구도 충전',
//     contentWidget: Obx(() {
//       return Column(
//         children: [
//           Padding(
//             padding: EdgeInsets.only(top: 12.0.sp),
//             child: StyledText(
//               '현재 신발 내구도 ${formatDecimalPlaces(itemId == controller.equippedShoe.value.id ? controller.equippedShoe.value.durability : controller.selectedItem.value.durability, 2)}',
//               fontSize: 16,
//               lineHeight: 22,
//               fontWeight: 500,
//               color: deepGrayColor,
//             ),
//           ),
//           Container(
//             margin: EdgeInsets.only(top: 15.sp),
//             child: FlutterSlider(
//               values: [controller.currentSliderValue.value],
//               max: 100,
//               min: 0,
//               handlerHeight: 32.0,
//               ignoreSteps: [
//                 FlutterSliderIgnoreSteps(from: 0, to: 0),
//               ],
//               trackBar: FlutterSliderTrackBar(
//                 inactiveTrackBarHeight: 16,
//                 activeTrackBarHeight: 15,
//                 inactiveTrackBar: BoxDecoration(
//                   borderRadius: BorderRadius.circular(20.sp),
//                   color: sliderGrayColor,
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black,
//                       offset: Offset(2.sp, 3.sp),
//                     )
//                   ],
//                 ),
//                 activeTrackBar: BoxDecoration(
//                   borderRadius: BorderRadius.circular(20.sp),
//                   color: purpleColor,
//                 ),
//               ),
//               onDragging: (handlerIndex, lowerValue, upperValue) {
//                 controller.currentSliderValue.value = lowerValue;
//                 controller.costTik.value = controller.currentSliderValue.value.toInt() * feeTikDurability;
//               },
//               handler: FlutterSliderHandler(
//                 decoration: BoxDecoration(
//                   color: purpleColor,
//                   border: Border.all(width: 2.sp, color: Colors.white),
//                   borderRadius: BorderRadius.circular(30.sp),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black,
//                       offset: Offset(2.sp, 3.sp),
//                     )
//                   ],
//                 ),
//                 child: iconSliderShoe,
//               ),
//               tooltip: FlutterSliderTooltip(
//                 textStyle: TextStyle(
//                   color: Colors.black,
//                   fontSize: 22.sp,
//                   fontWeight: FontWeight.w500,
//                   height: 1.sp,
//                 ),
//                 format: (label) => '+ ${formatDecimalPlaces(double.parse(label), 0)}',
//                 boxStyle: FlutterSliderTooltipBox(
//                   decoration: BoxDecoration(
//                     color: purpleColor,
//                     borderRadius: BorderRadius.circular(50.sp),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           Padding(
//             padding: EdgeInsets.symmetric(vertical: 40.0.sp),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 const StyledText(
//                   '충전 비용 :',
//                   fontSize: 22,
//                   fontWeight: 500,
//                   color: Color(0xFFA7A7A7),
//                 ),
//                 StyledText(
//                   ' ${controller.costTik.value} TIK',
//                   fontSize: 22,
//                   fontWeight: 500,
//                   color: Colors.white,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       );
//     }),
//     actions: [
//       Expanded(
//         child: GazagoButton(
//           onTap: () => controller.closeRepairPopup(),
//           buttonText: '취소',
//           textColor: Colors.white,
//           buttonColor: popupBgColor,
//         ),
//       ),
//       SizedBox(
//         width: 9.sp,
//       ),
//       Expanded(
//         child: Obx(() {
//           return GazagoButton(
//             onTap: () => controller.fetchRepairShoes(itemId),
//             disableButton: controller.disableButton.value,
//             buttonText: '네',
//             buttonColor: skyBlueColor,
//           );
//         }),
//       ),
//     ],
//   );
// }

// void showRepairStatSlider(ActivityController controller, StatModel stat, int feeTikStamina, int feeTikDurability) {
//   showAlert(
//     title: stat.type == 'STAMINA' ? '체력 충전' : '신발 내구도 충전',
//     contentWidget: Obx(() {
//       return Column(
//         children: [
//           Padding(
//             padding: EdgeInsets.only(top: 12.0.sp),
//             child: stat.type == 'STAMINA'
//                 ? StyledText(
//                     '현재 체력 ${stat.currentStat}',
//                     fontSize: 16,
//                     lineHeight: 22,
//                     fontWeight: 500,
//                     color: deepGrayColor,
//                   )
//                 : StyledText(
//                     '현재 신발 내구도 ${formatDecimalPlaces(stat.currentStat, 2)}',
//                     fontSize: 16,
//                     lineHeight: 22,
//                     fontWeight: 500,
//                     color: deepGrayColor,
//                   ),
//           ),
//           Container(
//             margin: EdgeInsets.only(top: 15.sp),
//             child: FlutterSlider(
//               values: [controller.currentSliderValue.value],
//               max: 100,
//               min: 0,
//               step: const FlutterSliderStep(
//                 step: 1, // default
//               ),
//               handlerHeight: 32.0,
//               ignoreSteps: [
//                 FlutterSliderIgnoreSteps(from: 0, to: 0),
//               ],
//               trackBar: FlutterSliderTrackBar(
//                 inactiveTrackBarHeight: 16,
//                 activeTrackBarHeight: 15,
//                 inactiveTrackBar: BoxDecoration(
//                   borderRadius: BorderRadius.circular(20.sp),
//                   color: const Color(0xFF494954),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black,
//                       offset: Offset(2.sp, 3.sp),
//                     )
//                   ],
//                 ),
//                 activeTrackBar: BoxDecoration(
//                   borderRadius: BorderRadius.circular(20.sp),
//                   color: stat.type == 'STAMINA' ? lightGreenColor : purpleColor,
//                 ),
//               ),
//               onDragging: (handlerIndex, lowerValue, upperValue) {
//                 controller.currentSliderValue.value = lowerValue;
//                 controller.costTik.value = controller.currentSliderValue.value.toInt() * (stat.type == 'STAMINA' ? feeTikStamina : feeTikDurability);
//               },
//               handler: FlutterSliderHandler(
//                 decoration: BoxDecoration(
//                   color: stat.type == 'STAMINA' ? lightGreenColor : purpleColor,
//                   border: Border.all(width: 2.sp, color: Colors.white),
//                   borderRadius: BorderRadius.circular(30.sp),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black,
//                       offset: Offset(2.sp, 3.sp),
//                     )
//                   ],
//                 ),
//                 child: stat.type == 'STAMINA' ? iconSliderStamina : iconSliderShoe,
//               ),
//               tooltip: FlutterSliderTooltip(
//                 textStyle: TextStyle(
//                   color: Colors.black,
//                   fontSize: 22.sp,
//                   fontWeight: FontWeight.w500,
//                   height: 1.sp,
//                 ),
//                 format: (label) => '+ ${formatDecimalPlaces(double.parse(label), 0)}',
//                 boxStyle: FlutterSliderTooltipBox(
//                   decoration: BoxDecoration(
//                     color: stat.type == 'STAMINA' ? lightGreenColor : purpleColor,
//                     borderRadius: BorderRadius.circular(50.sp),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           Padding(
//             padding: EdgeInsets.symmetric(vertical: 40.0.sp),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 StyledText(
//                   '${stat.type == 'STAMINA' ? '충전 ' : '충전 '}비용 :',
//                   fontSize: 22,
//                   fontWeight: 500,
//                   color: lightGrayColor,
//                 ),
//                 StyledText(
//                   ' ${controller.costTik.value} TIK',
//                   fontSize: 22,
//                   fontWeight: 500,
//                   color: Colors.white,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       );
//     }),
//     actions: [
//       Expanded(
//         child: GazagoButton(
//           onTap: () => controller.closeRepairPopup(),
//           buttonText: '취소',
//           textColor: Colors.white,
//           buttonColor: popupBgColor,
//         ),
//       ),
//       SizedBox(
//         width: 9.sp,
//       ),
//       Expanded(
//         child: Obx(() {
//           return GazagoButton(
//             onTap: () => stat.type == 'STAMINA' ? controller.fetchRechargeStamina(stat.type) : controller.fetchRepairShoes(),
//             disableButton: controller.disableButton.value,
//             buttonText: '네',
//             buttonColor: skyBlueColor,
//           );
//         }),
//       ),
//     ],
//   );
// }

void showNotEnoughTaikaAlert() {
  showAlert(
    allowMultipleBottomSheet: true,
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
        const TextSpan(
          text: '정확한 운동기록을 위해서 ',
          children: [
            TextSpan(text: '위치', style: TextStyle(color: skyBlueColor)),
            TextSpan(text: '엑세스 \n권한을 허용해 주세요'),
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

Future<void> checkAppPermissionAlert(DailyBenefitController controller) async {
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
        const TextSpan(
          text: '광고를 보기 위해선 \n',
          children: [
            TextSpan(text: '설정 -> 개인정보 보호 및 보안 -> 추적\n', style: TextStyle(color: skyBlueColor)),
            TextSpan(text: '가자고 앱에 대한 권한을 허용해 주세요.'),
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
            controller.moveAppSettings();
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
        const TextSpan(
          text: '정확한 운동기록을 위해서 ',
          children: [
            TextSpan(text: '신체 활동\n', style: TextStyle(color: skyBlueColor)),
            TextSpan(text: '엑세스 권한을 허용해 주세요.'),
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
        const TextSpan(
          text: '정상적인 gazaGO 이용을 위하여 디바이스의 ',
          children: [
            TextSpan(text: 'GPS', style: TextStyle(color: skyBlueColor)),
            TextSpan(text: ' 기능을 활성화 시켜주세요.'),
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
        const TextSpan(
          text: '비정상적인 ',
          children: [
            TextSpan(text: 'GPS 활동', style: TextStyle(color: skyBlueColor)),
            TextSpan(text: '이 감지되었습니다.'),
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
        const TextSpan(
          text: '프로필 사진 변경을 위해서 ',
          children: [
            TextSpan(text: '사진\n', style: TextStyle(color: skyBlueColor)),
            TextSpan(text: '엑세스 권한을 허용해 주세요.'),
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

void showEndExerciseAlert(ActivityMixin mixin) {
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
          onTap: () => mixin.endExercise(source: 'showEndExerciseAlert'),
          buttonText: '종료',
          buttonColor: skyBlueColor,
        ),
      ),
    ],
  );
}

// void showEndExerciseAdAlert(ActivityController controller) {
//   showAlert(
//     title: '활동 종료',
//     contentText: '지금까지의 기록만 저장됩니다.',
//     actions: [
//       Expanded(
//         child: Column(
//           children: [
//             InkWell(
//                 onTap: () => controller.endAd.value != null ? controller.showExerciseEndAd(controller) : null,
//                 child: Obx(() {
//                   return Container(
//                     width: double.infinity,
//                     height: 52.sp,
//                     alignment: Alignment.center,
//                     decoration: BoxDecoration(
//                       color: controller.endAd.value == null ? popupBgColor : skyBlueColor,
//                       border: Border.all(width: 2.sp, color: Colors.black),
//                       borderRadius: BorderRadius.circular(8.sp),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black,
//                           offset: Offset(0, 3.sp),
//                         )
//                       ],
//                     ),
//                     child: controller.endAd.value == null
//                         ? controller.adLoadingTime.value != 0
//                             ? Stack(
//                                 children: [
//                                   Text(
//                                     controller.adLoadingTime.value.toString(),
//                                     style: TextStyle(
//                                       fontSize: 40.sp,
//                                       fontFamily: 'Montserrat',
//                                       fontWeight: FontWeight.w700,
//                                       height: 1.1,
//                                       foreground: Paint()..color = skyBlueColor,
//                                     ),
//                                   ),
//                                   Text(
//                                     controller.adLoadingTime.value.toString(),
//                                     style: TextStyle(
//                                       fontSize: 40.sp,
//                                       height: 1.1,
//                                       fontFamily: 'Montserrat',
//                                       fontWeight: FontWeight.w700,
//                                       foreground: Paint()
//                                         ..strokeWidth = 2
//                                         ..color = Colors.black
//                                         ..style = PaintingStyle.stroke,
//                                     ),
//                                   ),
//                                 ],
//                               )
//                             : const StyledText(
//                                 '아직 광고가 부족해요...',
//                                 color: Color(0xFF60626C),
//                                 fontSize: 18,
//                                 fontWeight: 600,
//                               )
//                         : Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               Padding(
//                                 padding: const EdgeInsets.only(right: 5.0),
//                                 child: iconGoSmall,
//                               ),
//                               const StyledText(
//                                 '광고 보고, GO 10% 더 받고! ',
//                                 color: Colors.black,
//                                 fontSize: 18,
//                                 lineHeight: 19,
//                                 fontWeight: 600,
//                                 letterSpacing: .4,
//                               ),
//                             ],
//                           ),
//                   );
//                 })),
//             Padding(
//               padding: EdgeInsets.only(top: 8.0.sp),
//               child: GazagoButton(
//                 onTap: () => controller.endExercise(source: 'showEndExerciseAlert'),
//                 buttonText: '활동 종료',
//                 buttonColor: const Color(0xFF2C2E36),
//                 textColor: skyBlueColor,
//               ),
//             ),
//             Padding(
//               padding: EdgeInsets.only(top: 25.0.sp),
//               child: InkWell(
//                 onTap: () {
//                   print('close ad popup');
//                   controller.closeAdSelectPopup();
//                 },
//                 child: Container(
//                   decoration: const BoxDecoration(
//                     border: Border(
//                       bottom: BorderSide(
//                         // POINT
//                         color: lightGrayColor,
//                         width: 1.0,
//                       ),
//                     ),
//                   ),
//                   child: const Padding(
//                     padding: EdgeInsets.only(bottom: 6.0, left: 5.0, right: 5.0),
//                     child: StyledText(
//                       '취소',
//                       fontSize: 18,
//                       lineHeight: 22,
//                       fontWeight: 500,
//                       color: lightGrayColor,
//                     ),
//                   ),
//                 ),
//               ),
//             )
//           ],
//         ),
//       )
//     ],
//   );
// }

void showBadgeAcquisitionAlert(String badgeImgUrl, ChallengeCourseModel selectedChallenge) {
  showAlert(
    isScrollControlled: true,
    title: '챌린지 뱃지 발급',
    contentWidget: Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 30.sp, bottom: 30.sp),
          child: badgeImgUrl.contains('.svg')
              ? SvgPicture.network(
                  fit: BoxFit.contain,
                  badgeImgUrl,
                  width: 150.sp,
                  placeholderBuilder: (BuildContext context) => Container(width: 150, height: 150, padding: const EdgeInsets.all(30.0), child: const CircularProgressIndicator(color:skyBlueColor)),
                  headers: imageNetworkHeader,
                )
              : CachedNetworkImage(
                  imageUrl: badgeImgUrl,
                  placeholder: (context, url) => Container(width: 150, height: 150, padding: const EdgeInsets.all(30.0), child: const CircularProgressIndicator(color:skyBlueColor)),
                  fit: BoxFit.fitWidth,
                  width: 150.sp,
                  httpHeaders: imageNetworkHeader,
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
            const TextSpan(
              children: [
                TextSpan(text: '내 장비 > 뱃지', style: TextStyle(color: skyBlueColor)),
                TextSpan(text: ' 카테고리에서\n획득한 뱃지를 확인하실수 있습니다.'),
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

Future<void> showChallengeBadgeAcquisitionAlert(PushMessageChallengeSuccessModel pushMessageData) async {
  showAlert(
    isScrollControlled: true,
    title: '챌린지 뱃지 발급!',
    contentWidget: Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 30.sp, bottom: 30.sp),
          child: pushMessageData.badgeImageUrl != null && pushMessageData.badgeImageUrl!.contains('.svg')
              ? SvgPicture.network(
                  fit: BoxFit.contain,
                  pushMessageData.badgeImageUrl!,
                  width: 150.sp,
                  placeholderBuilder: (BuildContext context) => const Center(child: SizedBox.square(dimension: 40, child: CircularProgressIndicator(color:skyBlueColor))),
                  headers: imageNetworkHeader,
                )
              : CachedNetworkImage(
                  imageUrl: pushMessageData.badgeImageUrl!,
                  placeholder: (context, url) => const Center(child: SizedBox.square(dimension: 40, child: CircularProgressIndicator(color:skyBlueColor))),
                  fit: BoxFit.fitWidth,
                  width: 150.sp,
                  httpHeaders: imageNetworkHeader,
                ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 25.sp, vertical: 14.sp),
          decoration: BoxDecoration(
            color: subBg01Color,
            borderRadius: BorderRadius.circular(11.sp),
          ),
          child: StyledText(
            '${pushMessageData.challengeTitle} 달성',
            fontSize: 16,
            lineHeight: 22,
            fontWeight: 500,
            textAlign: TextAlign.center,
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
            const TextSpan(
              children: [
                TextSpan(text: '내 장비 > 뱃지', style: TextStyle(color: skyBlueColor)),
                TextSpan(text: ' 카테고리에서\n획득한 뱃지를 확인하실수 있습니다.'),
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
    title: '운동기록 삭제',
    contentText: '운동기록을 삭제하면 복구할 수 없어요.',
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
    PopScope(
      canPop: false,
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
                        const TextSpan(
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
                        onTapDown: (tapDownDetail) => controller.onTapDownStop(tapDownDetail, controller.selectedCourse.value, controller: controller, source: 'pendingExerciseDialog'),
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

void itemPurchaseAlert(ShopDetailController controller, double remainMyAsset, tradeSymbol) {
  showAlert(
    title: '구매할까요?',
    isScrollControlled: true,
    contentWidget: Obx(() {
      return Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: AppDoubleData.regular().numberSpacing8.sp, bottom: AppDoubleData.regular().numberSpacing16.sp),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                controller.selectedItem.value.itemCategory == 'DISPOSABLE'
                    ? Text(
                        '${formatDecimalPlaces(controller.purchaseItemSumPrice.value.toDouble(), 0)} ',
                        style: AppTextStyleData.regular().koHeadingSemiboldXl.copyWith(
                              color: AppColorData.regular().colorTextPrimary,
                            ),
                      )
                    : Text(
                        '${formatDecimalPlaces(controller.selectedItem.value.price, controller.selectedItem.value.tradeSymbol == 'STIK' ? 2 : 0, isAutoDecimal: true)} ',
                        style: AppTextStyleData.regular().koHeadingSemiboldXl.copyWith(
                              color: AppColorData.regular().colorTextPrimary,
                            ),
                      ),
                if (controller.selectedItem.value.tradeSymbol != null)
                  Text(
                    controller.selectedItem.value.tradeSymbol!,
                    style: AppTextStyleData.regular().koHeadingMediumXl.copyWith(
                          color: AppColorData.regular().colorTextPrimary,
                        ),
                  ),
              ],
            ),
          ),
          if (controller.selectedItem.value.challengeId != null)
            Padding(
              padding: EdgeInsets.only(bottom: 30.0.sp),
              child: Container(
                decoration: BoxDecoration(
                  color: subBg02Color,
                  borderRadius: BorderRadius.circular(5.sp),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 15.0.sp, horizontal: 20.sp),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 3,
                              height: 3,
                              margin: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: skyBlueColor,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            const StyledText(
                              '해당 아이템은 챌린지 대상 아이템입니다.',
                              fontSize: 14,
                              lineHeight: 20,
                              color: skyBlueColor,
                            )
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 3,
                              height: 3,
                              margin: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: skyBlueColor,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            const StyledText(
                              '구매 후 자동으로 장착되고 챌린지에 자동 참여됩니다.',
                              fontSize: 14,
                              lineHeight: 20,
                              color: skyBlueColor,
                            )
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 3,
                              height: 3,
                              margin: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: skyBlueColor,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            const StyledText(
                              '챌린지 대상 아이템은 1인 당 한개만 구매 가능합니다.',
                              fontSize: 14,
                              lineHeight: 20,
                              color: skyBlueColor,
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          if (controller.selectedItem.value.maxGoProfit! > 0)
            Padding(
              padding: EdgeInsets.only(top: AppDoubleData.regular().numberSpacing12.sp),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'GO 적립량',
                    style: AppTextStyleData.regular().koBodyMediumXl.copyWith(
                          color: AppColorData.regular().colorTextPrimary,
                        ),
                  ),
                  Text(
                    '${formatDecimalPlaces(controller.selectedItem.value.minGoProfit!, 0)}-${formatDecimalPlaces(controller.selectedItem.value.maxGoProfit!, 0)}',
                    style: AppTextStyleData.regular().koBodyMediumXl.copyWith(
                          color: AppColorData.regular().colorTextPrimary,
                        ),
                  ),
                ],
              ),
            ),
          if (controller.selectedItem.value.maxDurability! > 0)
            Padding(
              padding: EdgeInsets.only(top: AppDoubleData.regular().numberSpacing12.sp),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '내구도 저항',
                    style: AppTextStyleData.regular().koBodyMediumXl.copyWith(
                          color: AppColorData.regular().colorTextPrimary,
                        ),
                  ),
                  Text(
                    '${formatDecimalPlaces(controller.selectedItem.value.minDurability!, 0)}-${formatDecimalPlaces(controller.selectedItem.value.maxDurability!, 0)}',
                    style: AppTextStyleData.regular().koBodyMediumXl.copyWith(
                          color: AppColorData.regular().colorTextPrimary,
                        ),
                  ),
                ],
              ),
            ),
          if (controller.selectedItem.value.maxStamina! > 0)
            Padding(
              padding: EdgeInsets.only(top: AppDoubleData.regular().numberSpacing12.sp),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '체력 저항',
                    style: AppTextStyleData.regular().koBodyMediumXl.copyWith(
                          color: AppColorData.regular().colorTextPrimary,
                        ),
                  ),
                  Text(
                    '${formatDecimalPlaces(controller.selectedItem.value.minStamina!, 0)}-${formatDecimalPlaces(controller.selectedItem.value.maxStamina!, 0)}',
                    style: AppTextStyleData.regular().koBodyMediumXl.copyWith(
                          color: AppColorData.regular().colorTextPrimary,
                        ),
                  ),
                ],
              ),
            ),
          if (controller.selectedItem.value.maxLuck! > 0)
            Padding(
              padding: EdgeInsets.only(top: AppDoubleData.regular().numberSpacing12.sp),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '행운',
                    style: AppTextStyleData.regular().koBodyMediumXl.copyWith(
                          color: AppColorData.regular().colorTextPrimary,
                        ),
                  ),
                  Text(
                    '${formatDecimalPlaces(controller.selectedItem.value.minLuck!, 0)}-${formatDecimalPlaces(controller.selectedItem.value.maxLuck!, 0)}',
                    style: AppTextStyleData.regular().koBodyMediumXl.copyWith(
                          color: AppColorData.regular().colorTextPrimary,
                        ),
                  ),
                ],
              ),
            ),
          if (controller.selectedItem.value.itemCategory == 'DISPOSABLE')
            Padding(
              padding: EdgeInsets.only(top: 30.0.sp),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  StyledText(
                    controller.selectedItem.value.name,
                    fontSize: 18,
                    lineHeight: 32,
                    fontWeight: 600,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: popupBgColor,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(8.0.sp),
                          child: Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  if (controller.purchaseItemCount.value > 1) {
                                    controller.purchaseItemCount.value = controller.purchaseItemCount.value - 1;
                                  }
                                },
                                child: Container(
                                  width: 26.sp,
                                  height: 26.sp,
                                  decoration: BoxDecoration(
                                    color: controller.purchaseItemCount.value > 1 ? skyBlueColor : lightGrayColor,
                                    borderRadius: BorderRadius.circular(50),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black,
                                        offset: Offset(0, 3.sp),
                                      )
                                    ],
                                  ),
                                  child: Center(
                                    child: SizedBox(
                                      width: 13.sp,
                                      height: 3.sp,
                                      child: iconEaMinus,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 5.0.sp),
                                child: SizedBox(
                                  width: 80.sp,
                                  child: Center(
                                    child: StyledText(
                                      controller.purchaseItemCount.value.toString(),
                                      fontSize: 20,
                                      lineHeight: 26,
                                      fontWeight: 600,
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  if (remainMyAsset - controller.selectedItem.value.price >= controller.purchaseItemSumPrice.value) {
                                    controller.purchaseItemCount.value = controller.purchaseItemCount.value + 1;
                                  }
                                  return;
                                },
                                child: Container(
                                  width: 26.sp,
                                  height: 26.sp,
                                  decoration: BoxDecoration(
                                    color: remainMyAsset - controller.selectedItem.value.price >= controller.purchaseItemSumPrice.value ? skyBlueColor : lightGrayColor,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black,
                                        offset: Offset(0, 3.sp),
                                      )
                                    ],
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: Center(
                                    child: SizedBox(
                                      width: 13.sp,
                                      height: 13.sp,
                                      child: iconEaPlus,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          Divider(
            height: 40.sp,
            thickness: 2.0.sp,
            color: AppColorData.regular().colorBorderPrimary,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '잔액',
                style: AppTextStyleData.regular().koBodyMediumXl.copyWith(
                      color: AppColorData.regular().colorTextPrimary,
                    ),
              ),
              Text(
                '${formatDecimalPlaces(remainMyAsset, tradeSymbol == 'STIK' ? 2 : 0, isAutoDecimal: true, roundType: RoundType.floor)} ${controller.selectedItem.value.tradeSymbol!}',
                style: AppTextStyleData.regular().koBodyMediumXl.copyWith(
                      color: AppColorData.regular().colorTextPrimary,
                    ),
              ),
            ],
          ),
          if (controller.selectedItem.value.publishType == 'NFT') ...[
            Padding(
              padding: EdgeInsets.only(top: 28.sp),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '  ·  ',
                    style: AppTextStyleData.regular().koBodyMediumMd.copyWith(
                          color: AppColorData.regular().colorTextSecondary,
                        ),
                  ),
                  Expanded(
                    child: Text(
                      'NFT 아이템 구매시 민팅되며,민팅 수수료는 gazaGO가 부담해요.',
                      style: AppTextStyleData.regular().koBodyMediumMd.copyWith(
                            color: AppColorData.regular().colorTextSecondary,
                          ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: EdgeInsets.only(top: 8.sp, bottom: 32.sp),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '  ·  ',
                      style: AppTextStyleData.regular().koBodyMediumMd.copyWith(
                            color: AppColorData.regular().colorTextSecondary,
                          ),
                    ),
                    Expanded(
                      child: Text(
                        'Royalty는 0%이에요.',
                        style: AppTextStyleData.regular().koBodyMediumMd.copyWith(
                              color: AppColorData.regular().colorTextSecondary,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ] else
            remainMyAsset - controller.selectedItem.value.price >= controller.purchaseItemSumPrice.value
                ? Padding(
                    padding: EdgeInsets.only(top: 55.0.sp, bottom: 25.sp),
                    child: const StyledText(
                      '· 구매가 완료되면 취소가 불가합니다.',
                      fontSize: 14,
                      lineHeight: 14,
                      fontWeight: 500,
                      color: skyBlueColor,
                    ),
                  )
                : Padding(
                    padding: EdgeInsets.only(top: 55.0.sp, bottom: 25.sp),
                    child: const StyledText(
                      '· 현재 잔액으로는 제한된 수량만 구매 가능해요',
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
          onTap: () {
            Get.back();
            controller.purchaseItemCount.value = 1;
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
          onTap: () => controller.handlePurchaseShopItem(controller.selectedItem.value.id),
          buttonText: '구매하기',
          buttonColor: skyBlueColor,
        ),
      ),
    ],
  );
}

void itemPurchaseShortBalanceAlert(ShopDetailController controller, double remainMyTik, tradeSymbol) {
  showAlert(
    allowMultipleBottomSheet: true,
    title: '아이템 가격을 확인해주세요',
    isDangerTitle: true,
    isScrollControlled: true,
    contentWidget: Obx(() {
      return Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: AppDoubleData.regular().numberSpacing8.sp, bottom: AppDoubleData.regular().numberSpacing16.sp),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                controller.selectedItem.value.itemCategory == 'DISPOSABLE'
                    ? Text(
                        '${formatDecimalPlaces(controller.purchaseItemSumPrice.value.toDouble(), 0)} ',
                        style: AppTextStyleData.regular().koHeadingSemiboldXl.copyWith(
                              color: AppColorData.regular().colorTextPrimary,
                            ),
                      )
                    : Text(
                        '${formatDecimalPlaces(controller.selectedItem.value.price, controller.selectedItem.value.tradeSymbol == 'STIK' ? 2 : 0, isAutoDecimal: true)} ',
                        style: AppTextStyleData.regular().koHeadingSemiboldXl.copyWith(
                              color: AppColorData.regular().colorTextPrimary,
                            ),
                      ),
                Text(
                  controller.selectedItem.value.tradeSymbol!,
                  style: AppTextStyleData.regular().koHeadingMediumXl.copyWith(
                        color: AppColorData.regular().colorTextPrimary,
                      ),
                ),
              ],
            ),
          ),
          if (controller.selectedItem.value.maxGoProfit! > 0)
            Padding(
              padding: EdgeInsets.only(top: AppDoubleData.regular().numberSpacing12.sp),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'GO 적립량',
                    style: AppTextStyleData.regular().koBodyMediumXl.copyWith(
                          color: AppColorData.regular().colorTextPrimary,
                        ),
                  ),
                  Text(
                    '${formatDecimalPlaces(controller.selectedItem.value.minGoProfit!, 0)}-${formatDecimalPlaces(controller.selectedItem.value.maxGoProfit!, 0)}',
                    style: AppTextStyleData.regular().koBodyMediumXl.copyWith(
                          color: AppColorData.regular().colorTextPrimary,
                        ),
                  ),
                ],
              ),
            ),
          if (controller.selectedItem.value.maxDurability! > 0)
            Padding(
              padding: EdgeInsets.only(top: AppDoubleData.regular().numberSpacing12.sp),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '내구도 저항',
                    style: AppTextStyleData.regular().koBodyMediumXl.copyWith(
                          color: AppColorData.regular().colorTextPrimary,
                        ),
                  ),
                  Text(
                    '${formatDecimalPlaces(controller.selectedItem.value.minDurability!, 0)}-${formatDecimalPlaces(controller.selectedItem.value.maxDurability!, 0)}',
                    style: AppTextStyleData.regular().koBodyMediumXl.copyWith(
                          color: AppColorData.regular().colorTextPrimary,
                        ),
                  ),
                ],
              ),
            ),
          if (controller.selectedItem.value.maxStamina! > 0)
            Padding(
              padding: EdgeInsets.only(top: AppDoubleData.regular().numberSpacing12.sp),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '체력 저항',
                    style: AppTextStyleData.regular().koBodyMediumXl.copyWith(
                          color: AppColorData.regular().colorTextPrimary,
                        ),
                  ),
                  Text(
                    '${formatDecimalPlaces(controller.selectedItem.value.minStamina!, 0)}-${formatDecimalPlaces(controller.selectedItem.value.maxStamina!, 0)}',
                    style: AppTextStyleData.regular().koBodyMediumXl.copyWith(
                          color: AppColorData.regular().colorTextPrimary,
                        ),
                  ),
                ],
              ),
            ),
          if (controller.selectedItem.value.maxLuck! > 0)
            Padding(
              padding: EdgeInsets.only(top: AppDoubleData.regular().numberSpacing12.sp),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '행운',
                    style: AppTextStyleData.regular().koBodyMediumXl.copyWith(
                          color: AppColorData.regular().colorTextPrimary,
                        ),
                  ),
                  Text(
                    '${formatDecimalPlaces(controller.selectedItem.value.minLuck!, 0)}-${formatDecimalPlaces(controller.selectedItem.value.maxLuck!, 0)}',
                    style: AppTextStyleData.regular().koBodyMediumXl.copyWith(
                          color: AppColorData.regular().colorTextPrimary,
                        ),
                  ),
                ],
              ),
            ),
          // if (controller.purchaseItemCount > 0)
          //   Padding(
          //     padding: EdgeInsets.only(top: 30.0.sp),
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //       children: [
          //         StyledText(
          //           controller.selectedItem.value.name,
          //           fontSize: 18,
          //           lineHeight: 32,
          //           fontWeight: 600,
          //         ),
          //         StyledText(
          //           '${controller.purchaseItemCount.value}개',
          //           fontSize: 18,
          //           lineHeight: 32,
          //           fontWeight: 400,
          //         ),
          //       ],
          //     ),
          //   ),
          Divider(
            height: 40.sp,
            thickness: 2.0.sp,
            color: AppColorData.regular().colorBorderPrimary,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '잔액',
                style: AppTextStyleData.regular().koBodyMediumXl.copyWith(
                      color: AppColorData.regular().colorTextWarning,
                    ),
              ),
              Text(
                '${formatDecimalPlaces(remainMyTik, tradeSymbol == 'STIK' ? 2 : 0, isAutoDecimal: true, roundType: RoundType.floor)} ${controller.selectedItem.value.tradeSymbol}',
                style: AppTextStyleData.regular().koBodyMediumXl.copyWith(
                      color: AppColorData.regular().colorTextWarning,
                    ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 10.0.sp, bottom: 25.sp),
            child: Container(),
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

void itemPurchaseCompleteAlert(ShopDetailController controller) {
  showAlert(
    allowMultipleBottomSheet: true,
    title: '아이템 구매 완료',
    isScrollControlled: true,
    contentWidget: Obx(() {
      return Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: AppDoubleData.regular().numberSpacing24.sp, bottom: AppDoubleData.regular().numberSpacing28.sp),
            child: Column(
              children: [
                SizedBox(
                  width: 174.sp,
                  child: controller.purchaseCompleteItem.value.itemImageUrl.contains('.svg')
                      ? SvgPicture.network(
                          fit: BoxFit.contain,
                          controller.purchaseCompleteItem.value.itemImageUrl,
                          placeholderBuilder: (BuildContext context) => const Center(child: SizedBox.square(dimension: 40, child: CircularProgressIndicator(color:skyBlueColor))),
                          headers: imageNetworkHeader,
                        )
                      : CachedNetworkImage(
                          imageUrl: controller.purchaseCompleteItem.value.itemImageUrl,
                          fit: BoxFit.fitWidth,
                          placeholder: (context, url) => const Center(child: SizedBox.square(dimension: 40, child: CircularProgressIndicator(color:skyBlueColor))),
                          errorWidget: (context, url, error) => const Center(child: SizedBox.square(dimension: 40, child: CircularProgressIndicator(color:skyBlueColor))),
                          httpHeaders: imageNetworkHeader,
                        ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: AppDoubleData.regular().numberSpacing12.sp),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                getItemGradeCircleIcon(controller.purchaseCompleteItem.value.itemGrade),
                if (controller.selectedItem.value.id > 0 && controller.selectedItem.value.publishType == 'NFT')
                  Padding(
                    padding: EdgeInsets.only(left: AppDoubleData.regular().numberSpacing8.sp),
                    child: SvgPicture.asset('assets/images/shop/ico_nft_label.svg'),
                  ),
                Padding(
                  padding: EdgeInsets.only(left: AppDoubleData.regular().numberSpacing8.sp),
                  child: Text(
                    controller.purchaseCompleteItem.value.itemName,
                    style: AppTextStyleData.regular().koBodyMediumXl.copyWith(
                          color: AppColorData.regular().colorTextPrimary,
                        ),
                  ),
                ),
                if (controller.purchaseCompleteItem.value.itemCategory == 'DISPOSABLE')
                  Padding(
                    padding: EdgeInsets.only(left: 5.0.sp),
                    child: Text(
                      'x ${controller.purchaseItemCount.toString()}',
                      style: AppTextStyleData.regular().koBodyMediumXl.copyWith(
                            color: AppColorData.regular().colorTextPrimary,
                          ),
                    ),
                  ),
              ],
            ),
          ),
          if (controller.purchaseCompleteItem.value.nftId != null)
            Container(
              padding: EdgeInsets.symmetric(horizontal: AppDoubleData.regular().numberSpacing8.sp, vertical: AppDoubleData.regular().numberSpacing4.sp),
              decoration: BoxDecoration(
                border: Border.all(color: deepGrayColor),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                '#${controller.purchaseCompleteItem.value.serialNumber!}',
                style: AppTextStyleData.regular().koBodySemiboldMd.copyWith(
                      color: AppColorData.regular().colorTextTertiary,
                    ),
              ),
            ),
          Padding(
            padding: EdgeInsets.only(
              top: AppDoubleData.regular().numberSpacing28.sp,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: AppColorData.regular().colorBgPrimary,
                borderRadius: BorderRadius.all(
                  Radius.circular(12),
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 12, bottom: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        if (controller.purchaseCompleteItem.value.itemStat != null && controller.purchaseCompleteItem.value.itemStat!.goProfit! > 0)
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  formatDecimalPlaces(controller.purchaseCompleteItem.value.itemStat!.goProfit!, 0),
                                  style: AppTextStyleData.regular().koBodyMediumXl.copyWith(
                                        color: AppColorData.regular().colorPointCyan,
                                      ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 3.sp),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      iconShopRewardPng,
                                      Padding(
                                        padding: EdgeInsets.only(left: AppDoubleData.regular().numberSpacing4.sp),
                                        child: Text(
                                          'GO 적립량',
                                          style: AppTextStyleData.regular().koCaptionMediumMd.copyWith(
                                                color: AppColorData.regular().colorTextBrand,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (controller.purchaseCompleteItem.value.itemStat != null &&
                            controller.purchaseCompleteItem.value.itemStat!.goProfit! > 0 &&
                            (controller.purchaseCompleteItem.value.itemStat!.durability! > 0 ||
                                controller.purchaseCompleteItem.value.itemStat!.stamina! > 0 ||
                                controller.purchaseCompleteItem.value.itemStat!.luck! > 0))
                          SizedBox(
                            height: 42.sp,
                            child: VerticalDivider(
                              color: AppColorData.regular().colorBorderPrimary,
                              width: 1,
                              thickness: 1,
                            ),
                          ),
                        if (controller.purchaseCompleteItem.value.itemStat != null && controller.purchaseCompleteItem.value.itemStat!.durability! > 0)
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  formatDecimalPlaces(controller.purchaseCompleteItem.value.itemStat!.durability!, 0),
                                  style: AppTextStyleData.regular().koBodyMediumXl.copyWith(
                                        color: AppColorData.regular().colorPointPurple,
                                      ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 3.sp),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      iconShopDurabilityLightPng,
                                      Padding(
                                        padding: EdgeInsets.only(left: 4.0.sp),
                                        child: Text(
                                          '내구도 저항',
                                          style: AppTextStyleData.regular().koCaptionMediumMd.copyWith(
                                                color: AppColorData.regular().colorPointPurple,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (controller.purchaseCompleteItem.value.itemStat != null &&
                            (controller.purchaseCompleteItem.value.itemStat!.goProfit! > 0 || controller.purchaseCompleteItem.value.itemStat!.durability! > 0) &&
                            (controller.purchaseCompleteItem.value.itemStat!.stamina! > 0 || controller.purchaseCompleteItem.value.itemStat!.luck! > 0))
                          SizedBox(
                            height: 42.sp,
                            child: VerticalDivider(
                              color: AppColorData.regular().colorBorderPrimary,
                              width: 1,
                              thickness: 1,
                            ),
                          ),
                        if (controller.purchaseCompleteItem.value.itemStat != null && controller.purchaseCompleteItem.value.itemStat!.stamina! > 0)
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  formatDecimalPlaces(controller.purchaseCompleteItem.value.itemStat!.stamina!, 0),
                                  style: AppTextStyleData.regular().koBodyMediumXl.copyWith(
                                        color: AppColorData.regular().colorYellowgreen500,
                                      ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 3.sp),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      iconShopStaminaPng,
                                      Padding(
                                        padding: EdgeInsets.only(left: 4.0.sp),
                                        child: Text(
                                          '체력 저항',
                                          style: AppTextStyleData.regular().koCaptionMediumMd.copyWith(
                                                color: AppColorData.regular().colorPointYellowgreen,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (controller.purchaseCompleteItem.value.itemStat != null &&
                            controller.purchaseCompleteItem.value.itemStat!.luck! > 0 &&
                            (controller.purchaseCompleteItem.value.itemStat!.durability! > 0 ||
                                controller.purchaseCompleteItem.value.itemStat!.stamina! > 0 ||
                                controller.purchaseCompleteItem.value.itemStat!.goProfit! > 0))
                          SizedBox(
                            height: 42.sp,
                            child: VerticalDivider(
                              color: AppColorData.regular().colorBorderPrimary,
                              width: 1,
                              thickness: 1,
                            ),
                          ),
                        if (controller.purchaseCompleteItem.value.itemStat != null && controller.purchaseCompleteItem.value.itemStat!.luck! > 0)
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  formatDecimalPlaces(controller.purchaseCompleteItem.value.itemStat!.luck!, 0),
                                  style: AppTextStyleData.regular().koBodyMediumXl.copyWith(
                                        color: AppColorData.regular().colorPointPink,
                                      ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 3.sp),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      iconShopLuckPng,
                                      Padding(
                                        padding: EdgeInsets.only(left: 4.0.sp),
                                        child: Text(
                                          '행운',
                                          style: AppTextStyleData.regular().koCaptionMediumMd.copyWith(
                                                color: AppColorData.regular().colorPointPink,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (controller.purchaseCompleteItem.value.itemStat!.repairDurability! > 0)
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  '+${formatDecimalPlaces(controller.purchaseCompleteItem.value.itemStat!.repairDurability!, 0)}',
                                  style: AppTextStyleData.regular().koBodyMediumXl.copyWith(
                                        color: AppColorData.regular().colorPointPurple,
                                      ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 3.sp),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      iconShopDurabilityLightPng,
                                      Padding(
                                        padding: EdgeInsets.only(left: 4.0.sp),
                                        child: Text(
                                          '내구도 수리',
                                          style: AppTextStyleData.regular().koCaptionMediumMd.copyWith(
                                                color: AppColorData.regular().colorPointPurple,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (controller.purchaseCompleteItem.value.itemStat!.recoveryStamina! > 0)
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  '+${formatDecimalPlaces(controller.purchaseCompleteItem.value.itemStat!.recoveryStamina!, 0)}',
                                  style: AppTextStyleData.regular().koBodyMediumXl.copyWith(
                                        color: AppColorData.regular().colorPointYellowgreen,
                                      ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 3.sp),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      iconShopStaminaPng,
                                      Padding(
                                        padding: EdgeInsets.only(left: 4.0.sp),
                                        child: Text(
                                          '체력 회복',
                                          style: AppTextStyleData.regular().koCaptionMediumMd.copyWith(
                                                color: AppColorData.regular().colorPointYellowgreen,
                                              ),
                                        ),
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
                  if (controller.purchaseCompleteItem.value.challenge != null && controller.purchaseCompleteItem.value.challenge!.extTxt != null)
                    Padding(
                      padding: EdgeInsets.only(bottom: 24.0.sp),
                      child: StyledText(
                        controller.purchaseCompleteItem.value.challenge!.extTxt!,
                        fontSize: 14,
                        letterSpacing: -.1,
                        lineHeight: 22,
                        color: lightGrayColor,
                      ),
                    )
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: AppDoubleData.regular().numberSpacing28.sp,
              bottom: AppDoubleData.regular().numberSpacing32.sp,
            ),
            child: Column(
              children: [
                Text(
                  '구매한 아이템은',
                  style: AppTextStyleData.regular().koBodyMediumMd.copyWith(
                        color: AppColorData.regular().colorTextSecondary,
                      ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '내장비 > 아이템',
                      style: AppTextStyleData.regular().koBodyMediumMd.copyWith(
                            color: AppColorData.regular().colorTextBrand,
                          ),
                    ),
                    Text(
                      ' 카테고리에서 확인할 수 있어요.',
                      style: AppTextStyleData.regular().koBodyMediumMd.copyWith(
                            color: AppColorData.regular().colorTextSecondary,
                          ),
                    )
                  ],
                ),
              ],
            ),
          ),
          if (controller.purchaseCompleteItem.value.challenge != null && controller.purchaseCompleteItem.value.challenge!.extTxtDetail != null)
            Padding(
              padding: EdgeInsets.only(
                bottom: 30.sp,
              ),
              child: StyledText(
                controller.purchaseCompleteItem.value.challenge!.extTxtDetail!,
                fontWeight: 500,
                fontSize: 12,
                lineHeight: 18,
                color: deepGrayColor,
                textAlign: TextAlign.center,
              ),
            )
        ],
      );
    }),
    actions: [
      if (controller.purchaseCompleteItem.value.challenge != null && controller.purchaseCompleteItem.value.challenge!.linkUrl != null)
        Expanded(
          child: GazagoButton(
            onTap: () => controller.moveToExternalBrowser(controller.purchaseCompleteItem.value.challenge!.linkUrl),
            buttonText: controller.purchaseCompleteItem.value.challenge!.extBtnLabel!,
            textColor: Colors.white,
            buttonColor: popupBgColor,
          ),
        ),
      if (controller.purchaseCompleteItem.value.challenge != null && controller.purchaseCompleteItem.value.challenge!.linkUrl != null)
        SizedBox(
          width: 9.sp,
        ),
      Expanded(
        child: GazagoButton(
          onTap: () {
            Get.back();
            // if (controller.purchaseCompleteItem.value.itemCategory != 'DISPOSABLE') {
            //   controller.fetchEquipItem(controller.purchaseCompleteItem.value.id);
            // }
          },
          buttonText: '확인',
          buttonColor: skyBlueColor,
        ),
      ),
    ],
  );
}

void itemPurchaseImpossibleAlert() {
  showAlert(
    allowMultipleBottomSheet: true,
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

void itemPurchaseAvailableOnlyOneAlert(String errorMessage) {
  showAlert(
    allowMultipleBottomSheet: true,
    title: errorMessage,
    contentWidget: Padding(
      padding: EdgeInsets.only(top: 20.0.sp, bottom: 40.sp),
      child: const StyledText(
        '챌린지 대상 아이템은 1인당 한개만 구매 가능합니다.',
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
          // Padding(
          //   padding: EdgeInsets.only(bottom: 10.0.sp),
          //   child: const StyledText(
          //     '카테고리',
          //     fontWeight: 500,
          //     fontSize: 16,
          //     lineHeight: 22,
          //   ),
          // ),
          // Obx(() {
          //   return SizedBox(
          //     width: double.infinity,
          //     child: Wrap(
          //       children: [
          //         ...controller.categoryFilterList.asMap().entries.map(
          //               (entry) => Padding(
          //                 padding: EdgeInsets.only(right: 10.sp, bottom: 10.sp),
          //                 child: InkWell(
          //                   onTap: () => controller.onSelectCategory(entry.value['value']),
          //                   child: Container(
          //                     decoration: BoxDecoration(
          //                       color: controller.selectedCategory.any((element) => element == entry.value['value']) ? Colors.white : popupBgColor,
          //                       border: Border.all(
          //                         width: 1,
          //                         color: Colors.white,
          //                       ),
          //                       borderRadius: BorderRadius.circular(20.sp),
          //                     ),
          //                     child: Padding(
          //                       padding: EdgeInsets.symmetric(horizontal: 12.0.sp, vertical: 6.sp),
          //                       child: StyledText(
          //                         entry.value['title']!,
          //                         fontSize: 14,
          //                         lineHeight: 16,
          //                         letterSpacing: .2,
          //                         fontWeight: 500,
          //                         color: controller.selectedCategory.any((element) => element == entry.value['value']) ? Colors.black : Colors.white,
          //                       ),
          //                     ),
          //                   ),
          //                 ),
          //               ),
          //             ),
          //       ],
          //     ),
          //   );
          // }),
          Padding(
            padding: EdgeInsets.only(
              bottom: 28.sp,
            ),
            child: const StyledText(
              '필터',
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
                  Padding(
                    padding: EdgeInsets.only(right: 8.sp, bottom: 10.0.sp),
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
                          child: Text(
                            '전체',
                            style: AppTextStyleData.regular().enBodySemiboldMd.copyWith(
                                  color: controller.isSelectAllItems.value ? Colors.black : Colors.white,
                                ),
                          ),
                        ),
                      ),
                    ),
                  ),
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
                                child: Text(
                                  entry.value['title']!,
                                  style: AppTextStyleData.regular().enBodySemiboldMd.copyWith(
                                        color: controller.selectedGrade.any((element) => element == entry.value['value']) ? Colors.black : getItemGradeColor(entry.value['value']!),
                                      ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                  Padding(
                    padding: EdgeInsets.only(right: 8.sp, bottom: 10.sp),
                    child: InkWell(
                      onTap: () => controller.onSelectNftFilter(),
                      child: Container(
                        decoration: BoxDecoration(
                          color: controller.isSelectNftItems.value ? AppColorData.regular().colorPointOrange : popupBgColor,
                          border: Border.all(
                            width: 1,
                            color: AppColorData.regular().colorPointOrange,
                          ),
                          borderRadius: BorderRadius.circular(20.sp),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12.0.sp, vertical: 6.sp),
                          child: Text(
                            'NFT',
                            style: AppTextStyleData.regular().enBodySemiboldMd.copyWith(
                                  color: controller.isSelectNftItems.value ? Colors.black : AppColorData.regular().colorPointOrange,
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

void showInvalidCertCode(String errorMsg, String errorCode) {
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
          onTap: () {
            Get.back();
            // String? enteredRoute = HiveStore.loadString(key: HiveKey.enteredRoute.name);
            // print(enteredRoute);
            // Get.until((route) => Get.currentRoute == enteredRoute);
            // if(errorCode == 'IDENTITY_VERIFIED_FAILURE'){
            //   Get.back();
            // } else {
            //   if(enteredRoute != null){
            //     Get.until((route) => Get.currentRoute == enteredRoute);
            //   } else {
            //     Get.until((route) => route.isFirst);
            //   }
            //
            // }
          },
          buttonText: '확인',
          buttonColor: skyBlueColor,
        ),
      ),
    ],
  );
}

void alreadyConnectedDeviceAlert(LoginController controller, LoginType socialType, String accessToken) {
  showAlert(
    allowMultipleBottomSheet: true,
    title: '확인 요청',
    contentWidget: Padding(
      padding: EdgeInsets.only(top: 20.0.sp, bottom: 40.sp),
      child: const StyledText(
        '다른 기기에 로그인 되어 있어요.\n해당 기기의 로그인 해제 후 로그인할게요.',
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
    allowMultipleBottomSheet: true,
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
          onTap: () {
            if (!forceLogoutAlertCompleter.isCompleted) {
              forceLogoutAlertCompleter.complete();
            } else {
              Get.back();
              return;
            }
          },
          buttonText: '확인',
          buttonColor: skyBlueColor,
        ),
      ),
    ],
  );

  return forceLogoutAlertCompleter.future;
}

void showAdTipAlert(int? challengeId, ExerciseType exerciseType) {
  Get.dialog(
    barrierColor: Colors.transparent,
    PopScope(
      canPop: false,
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
                                                text: '광고 보고, ${challengeId == null || exerciseType.value == ExerciseType.walking.value ? '1' : '3'}GO 받고 시작하기',
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
                            const TextSpan(
                              text: '· ',
                              style: TextStyle(color: lightGrayColor),
                              children: [
                                TextSpan(
                                  text: '끝까지 광고를 시청하는 것',
                                  style: TextStyle(color: skyBlueColor),
                                ),
                                TextSpan(
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
                            const TextSpan(
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
                            const TextSpan(
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
                              children: const [
                                TextSpan(
                                    text: '오늘의 리워드',
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
                              const StyledText(
                                '어제 가자고에서의 활동을 기준으로 확정돼요!',
                                color: lightGrayColor,
                                fontSize: 11,
                                lineHeight: 16,
                              ),
                              const StyledText(
                                '오늘 리더보드 참여자에게 획득한 GO만큼 돌려드려요!',
                                color: lightGrayColor,
                                fontSize: 11,
                                lineHeight: 16,
                              ),
                              const StyledText(
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
                                const TextSpan(
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
                              const StyledText(
                                '오늘의 리워드는 아래 항목으로 구성됩니다!',
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
                                  const TextSpan(
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
                                child: const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    StyledText(
                                      '· 체력 회복',
                                      fontSize: 12,
                                      lineHeight: 18,
                                      fontWeight: 400,
                                    ),
                                    StyledText(
                                      '· 내구도 수리',
                                      fontSize: 12,
                                      lineHeight: 18,
                                      fontWeight: 400,
                                    ),
                                    StyledText(
                                      '· 일반 장비 구매',
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
                                  const TextSpan(
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
                                child: const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
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
                                  const TextSpan(
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
                                child: const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    StyledText(
                                      '· NFT 장비 구매',
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
  if (Get.isBottomSheetOpen == null || !Get.isBottomSheetOpen! || !Get.isDialogOpen!) {
    await Get.bottomSheet(
      isDismissible: false,
      isScrollControlled: true,
      PopScope(
        canPop: false,
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
                  items: noticePopupController.noticeMainPopupList
                      .map((item) => SizedBox(
                            width: double.infinity,
                            child: InkWell(
                              onTap: () => noticePopupController.moveToWebView(item),
                              child: item.imageUrlKo != null
                                  ? Image.network(
                                      item.imageUrlKo!,
                                      width: double.infinity,
                                    )
                                  : Container(),
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
                            '${(noticePopupController.current.value + 1).toString()}/${noticePopupController.noticeMainPopupList.length}',
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
}

void showStoreNotAvailableAlert() {
  showAlert(
    contentWidget: Center(
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
    allowMultipleBottomSheet: true,
    contentWidget: Obx(() {
      return Container(
          child: controller.showPendingPurchaseUI.value
              ? Center(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 20.sp, bottom: 20.0.sp),
                        child: Lottie.asset(
                          'assets/lottie/purchase_pending.json',
                          width: 40,
                          height: 40,
                          repeat: true,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: StyledText(
                          controller.showVerifyingPurchaseText.value
                              ? controller.isPurchasePending.value
                                  ? '결제 진행중입니다.'
                                  : 'TIK을 충전하고 있습니다.'
                              : '결제 승인 대기중입니다.',
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
              onTap: () => controller.afterChargeTikAndReturnPage(),
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

void showInAppPurchasePendingAlert() {
  showAlert(
    allowMultipleBottomSheet: true,
    contentWidget: Center(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 20.sp, bottom: 20.0.sp),
            child: Lottie.asset(
              'assets/lottie/purchase_pending.json',
              width: 40,
              height: 40,
              repeat: true,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 35.0.sp),
            child: StyledText(
              '결제 진행중입니다.\n잠시 후(최대 10분) 지갑 내역을\n 확인해주세요',
              fontSize: 18.sp,
              fontWeight: 500,
              lineHeight: 24.sp,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    ),
    actions: [
      Expanded(
        child: GazagoButton(
          onTap: () => Get.back(),
          buttonText: '확인',
          buttonColor: skyBlueColor,
        ),
      )
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
              decoration: const InputDecoration(
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
              style: const TextStyle(
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
    allowMultipleBottomSheet: true,
    contentWidget: Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: hasWallet
              ? Text.rich(
                  textAlign: TextAlign.center,
                  style: AppTextStyleData.regular().koHeadingMediumSm.copyWith(
                        color: AppColorData.regular().colorTextPrimary,
                      ),
                  TextSpan(
                    text: 'Staika Wallet을 ',
                    children: [
                      TextSpan(text: '연결', style: TextStyle(color: AppColorData.regular().colorTextBrand)),
                      const TextSpan(text: '했습니다.'),
                    ],
                  ))
              : Text(
                  "Staika 지갑 만들기",
                  style: AppTextStyleData.regular().koHeadingMediumSm.copyWith(
                        color: AppColorData.regular().colorTextPrimary,
                      ),
                ),
        ),
        hasWallet
            ? Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '  ·  ',
                          style: AppTextStyleData.regular().koBodyMediumLg.copyWith(
                                color: AppColorData.regular().colorTextPrimary,
                              ),
                        ),
                        Expanded(
                          child: Text(
                            'gazaGO 계정과 동일한 계정으로 생성되어 있는 Staika Wallet이 있어 연결했습니다.',
                            style: AppTextStyleData.regular().koBodyMediumLg.copyWith(
                                  color: AppColorData.regular().colorTextPrimary,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '  ·  ',
                          style: AppTextStyleData.regular().koBodyMediumLg.copyWith(
                                color: AppColorData.regular().colorTextPrimary,
                              ),
                        ),
                        Expanded(
                          child: Text(
                            'Staika Wallet에 사용 중인 지갑 주소와 이체 비밀번호를 동일하게 사용하실 수 있습니다.',
                            style: AppTextStyleData.regular().koBodyMediumLg.copyWith(
                                  color: AppColorData.regular().colorTextPrimary,
                                ),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '  ·  ',
                          style: AppTextStyleData.regular().koBodyMediumLg.copyWith(
                                color: AppColorData.regular().colorTextPrimary,
                              ),
                        ),
                        Expanded(
                          child: Text(
                            '모두가 누리는 스마트한 자산관리! 편하고 안전한 블록체인 지갑, Staika 지갑을 만듭니다.',
                            style: AppTextStyleData.regular().koBodyMediumLg.copyWith(
                                  color: AppColorData.regular().colorTextPrimary,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '  ·  ',
                          style: AppTextStyleData.regular().koBodyMediumLg.copyWith(
                                color: AppColorData.regular().colorTextPrimary,
                              ),
                        ),
                        Expanded(
                          child: Text(
                            '이체 비밀번호만 설정하면 완료할 수 있어요.',
                            style: AppTextStyleData.regular().koBodyMediumLg.copyWith(
                                  color: AppColorData.regular().colorTextPrimary,
                                ),
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
                  if (tabController?.index == 0) {
                    Get.toNamed(Routes.sendStikStaikaWallet);
                  }
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
                        Get.back();
                        if (tabController != null) tabController.animateTo(0);
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
                        Get.back();
                        Get.toNamed(Routes.createWalletWebview);
                      },
                      buttonText: '만들기',
                      buttonColor: skyBlueColor,
                    ),
                  ),
                ],
              ),
            ),
    ],
  );
}

void showNotSupportedWalletAlert({required String message, required TabController tabController}) {
  showAlert(
    allowMultipleBottomSheet: true,
    contentWidget: Column(
      children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 28, bottom: 30),
              child: Row(
                children: [
                  Expanded(
                    child: StyledText(
                      message,
                      fontSize: 16,
                      lineHeight: 24,
                      fontWeight: 500,
                      color: lightGrayColor,
                      textAlign: TextAlign.center,
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
      Expanded(
        child: Row(
          children: [
            Expanded(
              child: GazagoButton(
                onTap: () {
                  tabController.animateTo(0);
                  Get.back();
                },
                buttonText: '확인',
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
  GoWalletController controller = Get.find();
  WalletMasterController walletMasterController = Get.find();
  showAlert(
    title: '교환 하시겠습니까?',
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
                    walletMasterController.clickedAssetButton.value == 'STAIKA'
                        ? SvgPicture.asset('assets/images/wallet/ico_stik.svg', width: 24, height: 24)
                        : SvgPicture.asset('assets/images/wallet/ico_tik.svg', width: 24, height: 24),
                    Padding(
                      padding: EdgeInsets.only(left: 7.0.sp),
                      child: StyledText(
                        formatDecimalPlaces(
                            walletMasterController.clickedAssetButton.value == 'STAIKA'
                                ? double.parse(exchangeProduct.fromUiAmountString!)
                                : productSumFeePrice(exchangeProduct.fromUiAmountString!, exchangeProduct.uiFeeString!),
                            4,
                            isAutoDecimal: true),
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
                    walletMasterController.clickedAssetButton.value == 'STAIKA'
                        ? SvgPicture.asset('assets/images/wallet/ico_tik.svg', width: 24, height: 24)
                        : SvgPicture.asset('assets/images/wallet/ico_stik.svg', width: 24, height: 24),
                    Padding(
                      padding: EdgeInsets.only(left: 7.0.sp),
                      child: walletMasterController.clickedAssetButton.value == 'STAIKA'
                          ? StyledText(
                              formatDecimalPlaces(productMinusFeePrice(exchangeProduct.toUiAmountString!, exchangeProduct.uiFeeString!), 0),
                              fontSize: 30,
                              lineHeight: 32,
                              fontWeight: 600,
                              letterSpacing: -.1,
                            )
                          : StyledText(
                              formatDecimalPlaces(double.parse(exchangeProduct.toUiAmountString!), 0),
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
              const StyledText(
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
            child: const StyledText(
              '교환이 완료되면 취소할 수 없습니다.',
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
          buttonText: '교환',
          buttonColor: skyBlueColor,
        ),
      ),
    ],
  );
}

void failureChargeStikToTikAlert(GoWalletController controller, String errorMsg) {
  showAlert(
    allowMultipleBottomSheet: true,
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
  WalletMasterController walletMasterController = Get.find();
  showAlert(
    contentWidget: Padding(
      padding: EdgeInsets.only(top: 20.0.sp, bottom: 40.sp),
      child: Column(
        children: [
          iconCircleSkyBlueCheck,
          Padding(
            padding: EdgeInsets.only(top: 20.0.sp),
            child: StyledText(
              '${walletMasterController.clickedAssetButton.value == 'STAIKA' ? 'TIK' : 'STIK'} 교환이 완료 되었습니다.',
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

void sendStikToGoWalletAlert(StaikaWalletController controller, String password) {
  WalletMasterController walletMasterController = Get.find();
  showAlert(
    allowMultipleBottomSheet: true,
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
                      child: const StyledText(
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
            child: const StyledText(
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
            controller.confirmSendStikToGoWallet(password);
          },
          buttonText: '네',
          buttonColor: skyBlueColor,
        ),
      ),
    ],
  );
}

void sendStikToStaikaWalletAlert(GoWalletController controller) {
  WalletMasterController walletMasterController = Get.find();
  showAlert(
    allowMultipleBottomSheet: true,
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
                          walletMasterController.stik.value.decimals!,
                          isAutoDecimal: true,
                        ),
                        fontSize: 30,
                        lineHeight: 32,
                        fontWeight: 600,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 7.0.sp),
                      child: const StyledText(
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
            child: const StyledText(
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
            if (!controller.loaderController.isLoading.value) {
              controller.confirmSendStikStaikaWallet();
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
  WalletMasterController walletMasterController = Get.find();
  showAlert(
    allowMultipleBottomSheet: true,
    title: '잔액이 부족해 진행할 수 없습니다.',
    contentWidget: Padding(
      padding: EdgeInsets.only(top: 20.0.sp, bottom: 40.sp),
      child: StyledText(
        '부족한 ${walletMasterController.clickedAssetButton.value == 'STAIKA' ? 'STIK' : 'TIK'} 을 보유한 후 다시 시도해 주세요.',
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
  showAlert(
    allowMultipleBottomSheet: true,
    title: '보유한 STIK이 부족합니다.',
    isScrollControlled: true,
    contentWidget: Obx(() {
      return Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 34.0.sp, bottom: 30.sp),
            child: Column(
              children: [
                // Opacity(
                //   opacity: 0.4,
                //   child: FittedBox(
                //     child: Row(
                //       mainAxisAlignment: MainAxisAlignment.center,
                //       children: [
                //         SvgPicture.asset('assets/images/wallet/ico_stik.svg', width: 24, height: 24),
                //         Padding(
                //           padding: EdgeInsets.only(left: 7.0.sp),
                //           child: StyledText(
                //             formatDecimalPlaces(
                //               double.parse(controller.sendStikUiAmount.value),
                //               controller.assetStik.value!.decimals,
                //               isAutoDecimal: true,
                //             ),
                //             fontSize: 30,
                //             lineHeight: 32,
                //             fontWeight: 600,
                //             letterSpacing: -.1,
                //           ),
                //         ),
                //         Padding(
                //           padding: EdgeInsets.only(left: 7.0.sp),
                //           child: const StyledText(
                //             'STIK',
                //             fontSize: 30,
                //             lineHeight: 32,
                //             fontWeight: 400,
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0.sp),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const StyledText(
                        '신청한 STIK',
                        fontWeight: 500,
                        fontSize: 16,
                        letterSpacing: -.2,
                      ),
                      StyledText(
                        '${formatDecimalPlaces(double.parse(controller.sendStikUiAmount.value), 4, isAutoDecimal: true)} STIK',
                        fontWeight: 500,
                        fontSize: 16,
                        letterSpacing: -.2,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15.0.sp, bottom: 10.sp),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const StyledText(
                        '보유한 STIK',
                        fontWeight: 500,
                        fontSize: 16,
                        letterSpacing: -.2,
                      ),
                      StyledText(
                        '${formatDecimalPlaces(double.parse(controller.assetStik.value!.uiAmountString), 4, isAutoDecimal: true, roundType: RoundType.floor)} STIK',
                        fontWeight: 500,
                        fontSize: 16,
                        letterSpacing: -.2,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15.0.sp),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const StyledText(
                        '송금 후 잔액',
                        fontWeight: 500,
                        fontSize: 16,
                        letterSpacing: -.2,
                      ),
                      StyledText(
                        '${formatDecimalPlaces(double.parse(controller.shortStikUiAmount.value), 4, isAutoDecimal: true)} STIK',
                        fontWeight: 500,
                        fontSize: 16,
                        letterSpacing: -.2,
                      ),
                    ],
                  ),
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
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: TextStyle(color: lightGrayColor, fontWeight: FontWeight.w500, fontSize: 14.sp, height: 18.sp / 14, letterSpacing: -.1),
                children: const [
                  TextSpan(
                    text: '솔라나(Solana) 블록체인 네트워크 정책상\n지갑에 최소',
                  ),
                  TextSpan(
                    text: '0.0001 STIK',
                  ),
                  TextSpan(
                    text: ' 이상 잔액이 필요합니다.\n보내는 STIK 금액을 변경한 후 다시 시도해 주세요.',
                  ),
                ],
              ),
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

void sendStikShortBalanceAlert(GoWalletController controller) {
  WalletMasterController walletMasterController = Get.find();
  showAlert(
    allowMultipleBottomSheet: true,
    title: '잔액이 부족해 진행할 수 없습니다.',
    isScrollControlled: true,
    contentWidget: Obx(() {
      return Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 34.0.sp, bottom: 30.sp),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 10.0.sp),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const StyledText(
                        '요청 금액',
                        fontWeight: 500,
                        fontSize: 16,
                        letterSpacing: -.2,
                      ),
                      StyledText(
                        '${formatDecimalPlaces(double.parse(controller.sendStikUiAmount.value), 4, isAutoDecimal: true)} STIK',
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
                      const StyledText(
                        '현재 잔액',
                        fontWeight: 500,
                        fontSize: 16,
                        letterSpacing: -.2,
                      ),
                      StyledText(
                        '${formatDecimalPlaces(double.parse(walletMasterController.stik.value.uiAmountString!), 4, isAutoDecimal: true, roundType: RoundType.floor)} STIK',
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
            child: const StyledText(
              '· 부족한 STIK을 보유한 후 다시 시도해 주세요.',
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
                child: const StyledText(
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

void successExchangeStikToStaikaWalletAlert(GoWalletController controller) {
  showAlert(
    contentWidget: Padding(
      padding: EdgeInsets.only(top: 20.0.sp, bottom: 40.sp),
      child: Column(
        children: [
          Column(
            children: [
              const StyledText(
                '접수 되었습니다.',
                fontSize: 18,
                lineHeight: 24,
                fontWeight: 500,
                letterSpacing: .2,
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.0.sp),
                child: const StyledText(
                  '24시간이내 처리될 예정입니다.',
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
                child: const StyledText(
                  '블록체인 네트워크 지연으로 완료하지 못했습니다.',
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

void showForceUpdateApp() {
  showAlert(
    title: '새 업데이트가 있습니다.',
    contentText: '앱을 사용하기 위해서 업데이트가 필요합니다.',
    allowMultipleBottomSheet: true,
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

void showRecommendUpdateApp() {
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

void showItemTipAlert() {
  Get.dialog(
    barrierColor: Colors.transparent,
    useSafeArea: false,
    WillPopScope(
      onWillPop: () async => false,
      child: Material(
        color: Colors.black.withOpacity(0.8),
        child: Center(
          child: Container(
            width: 316.sp,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(top: 40.sp, left: 20.sp, right: 20.sp, bottom: 32.sp),
                      decoration: BoxDecoration(
                        color: AppColorData.regular().colorBgTertiary,
                        borderRadius: BorderRadius.circular(AppDoubleData.regular().numberRadius20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            '능력치 안내',
                            style: AppTextStyleData.regular().koHeadingSemiboldSm.copyWith(
                              color: AppColorData.regular().colorTextPrimary
                            )
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 8.0.sp),
                            child: Text(
                                '아이템 구매시 아이템 등급에 따라 능력치가\n확률적으로 결정돼요.',
                                style: AppTextStyleData.regular().koBodyMediumMd.copyWith(
                                    color: AppColorData.regular().colorTextPrimary
                                ),
                                textAlign: TextAlign.center,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 20.0.sp),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    iconStatGo,
                                    Padding(
                                      padding: EdgeInsets.only(left: 6.0.sp),
                                      child: Text(
                                        'GO 적립량',
                                        style: AppTextStyleData.regular().koBodyMediumMd.copyWith(
                                          color: AppColorData.regular().colorTextPrimary,
                                          height: 1.1,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top:4.0.sp),
                                  child: Text(
                                    '수치가 높을수록 같은 운동량에\n더 많은 GO를 얻을 수 있어요.',
                                    style: AppTextStyleData.regular().koBodyMediumSm.copyWith(
                                        color: AppColorData.regular().colorTextPrimary
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top:16.0.sp),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          iconStatDurability,
                                          Padding(
                                            padding: EdgeInsets.only(left: 6.0.sp),
                                            child: Text(
                                              '내구도 저항',
                                              style: AppTextStyleData.regular().koBodyMediumMd.copyWith(
                                                  color: AppColorData.regular().colorTextPrimary,
                                                height: 1.1,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top:4.0.sp),
                                        child: Text(
                                          '수치가 높을수록 같은 운동량에\n내구도가 덜 감소해요.',
                                          style: AppTextStyleData.regular().koBodyMediumSm.copyWith(
                                              color: AppColorData.regular().colorTextPrimary
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top:16.0.sp),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          iconStatStamina,
                                          Padding(
                                            padding: EdgeInsets.only(left: 6.0.sp),
                                            child: Text(
                                              '체력 저항',
                                              style: AppTextStyleData.regular().koBodyMediumMd.copyWith(
                                                  color: AppColorData.regular().colorTextPrimary,
                                                height: 1.1,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top:4.0.sp),
                                        child: Text(
                                          '수치가 높을수록 같은 운동량에\n체력이 덜 감소해요.',
                                          style: AppTextStyleData.regular().koBodyMediumSm.copyWith(
                                              color: AppColorData.regular().colorTextPrimary
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top:16.0.sp),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          iconStatLuck,
                                          Padding(
                                            padding: EdgeInsets.only(left: 6.0.sp),
                                            child: Text(
                                              '행운',
                                              style: AppTextStyleData.regular().koBodyMediumMd.copyWith(
                                                  color: AppColorData.regular().colorTextPrimary,
                                                height: 1.1,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top:4.0.sp),
                                        child: Text(
                                          '수치가 높을수록 운동 중에 행운 GO를\n더 크게, 더 자주 얻을 수 있어요.',
                                          style: AppTextStyleData.regular().koBodyMediumSm.copyWith(
                                              color: AppColorData.regular().colorTextPrimary
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
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
                    Positioned(right: 16.8.sp, top: 16.8.sp, child: InkWell(onTap: () => Get.back(), child: iconCloseWhite)),
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

void showMaintenanceAlert({String type = 'ING', required String contentText, List<Function>? callbacks}) {
  List<Widget> setWidgets() {
    Widget image;
    Widget title;
    Widget description;
    switch (type) {
      case 'PREVIEW':
        image = Image.asset(
          'assets/images/maintenance/maintenance_preview.png',
          width: 150,
          height: 160,
        );
        title = Padding(
          padding: const EdgeInsets.only(top: 30, bottom: 13),
          child: SvgPicture.asset(
            'assets/images/maintenance/maintenance_preview_text.svg',
          ),
        );
        description = const Padding(
          padding: EdgeInsets.only(top: 28, bottom: 28),
          child: StyledText(
            '플레이 중인 운동은 점검 시작 전에 완료해 주세요.\n점검이 시작되면 모든 운동이 강제 종료돼요.\n운영상황에 따라 점검일정은 변경될 수 있습니다.',
            fontWeight: 500,
            fontSize: 16,
            lineHeight: 24,
            textAlign: TextAlign.center,
          ),
        );
        break;
      case 'ING':
        image = Image.asset(
          'assets/images/maintenance/maintenance_in_progress.png',
          width: 150,
          height: 180,
        );
        title = Padding(
          padding: const EdgeInsets.only(top: 30, bottom: 13),
          child: SvgPicture.asset(
            'assets/images/maintenance/maintenance_in_progress_text.svg',
          ),
        );

        description = const Padding(
          padding: EdgeInsets.only(top: 28, bottom: 28),
          child: StyledText(
            '안녕하세요 가자고 팀입니다.\n새로운 기능 업데이트를 위해 시스템 점검중입니다.\n양해 부탁드립니다.',
            fontWeight: 500,
            fontSize: 16,
            lineHeight: 24,
            textAlign: TextAlign.center,
          ),
        );
        break;
      case 'EMERGENCY':
        image = Image.asset(
          'assets/images/maintenance/maintenance_siren.png',
          width: 56,
          height: 83,
        );
        title = Padding(
          padding: const EdgeInsets.only(top: 30, bottom: 13),
          child: SvgPicture.asset(
            'assets/images/maintenance/maintenance_siren_text.svg',
          ),
        );
        description = const Padding(
          padding: EdgeInsets.only(top: 28, bottom: 28),
          child: StyledText(
            '긴급 점검 진행 중입니다.\n서비스 이용에 불편을 드려 대단히 죄송합니다.',
            fontWeight: 500,
            fontSize: 16,
            lineHeight: 24,
            textAlign: TextAlign.center,
          ),
        );
        break;
      default:
        image = Image.asset(
          'assets/images/maintenance/maintenance_in_progress.png',
          width: 150,
          height: 180,
        );
        title = Padding(
          padding: const EdgeInsets.only(top: 30, bottom: 13),
          child: SvgPicture.asset(
            'assets/images/maintenance/maintenance_in_progress_text.svg',
          ),
        );
        description = const Padding(
          padding: EdgeInsets.only(top: 28, bottom: 28),
          child: StyledText(
            '안녕하세요 가자고 팀입니다.\n새로운 기능 업데이트를 위해 시스템 점검중입니다.\n양해 부탁드립니다.',
            fontWeight: 500,
            fontSize: 16,
            lineHeight: 24,
            textAlign: TextAlign.center,
          ),
        );
    }
    return [image, title, description];
  }

  Get.dialog(
    PopScope(
      canPop: false,
      child: Dialog(
        insetPadding: EdgeInsets.zero,
        backgroundColor: subBg01Color,
        child: Stack(
          children: [
            Positioned(
              top: 25,
              left: 25,
              child: SvgPicture.asset(
                'assets/images/gazago_logo_text.svg',
              ),
            ),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  setWidgets()[0],
                  setWidgets()[1],
                  if (type != 'EMERGENCY')
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: StyledText(
                        contentText.replaceAll('\\n', '\n'),
                        fontWeight: 500,
                        fontSize: 16,
                        lineHeight: 22,
                        color: deepGrayColor,
                      ),
                    ),
                  setWidgets()[2],
                  if (callbacks != null) ...[
                    SizedBox(
                      width: 180,
                      child: GazagoButton(
                        buttonText: '닫기',
                        buttonColor: popupBgColor,
                        textColor: Colors.white,
                        onTap: () => callbacks[0](),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 25),
                      child: InkWell(
                        onTap: () => callbacks[1](),
                        child: Container(
                          padding: const EdgeInsets.only(bottom: 1),
                          decoration: const BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                              color: deepGrayColor,
                            )),
                          ),
                          child: const StyledText(
                            '오늘 그만 보기',
                            color: deepGrayColor,
                            fontSize: 16,
                            fontWeight: 500,
                            lineHeight: 24,
                          ),
                        ),
                      ),
                    )
                  ]
                ],
              ),
            ),
          ],
        ),
      ),
    ),
    barrierColor: subBg01Color,
    useSafeArea: true,
    barrierDismissible: false,
  );
}

void challengesSortListAlert(ChallengesController controller) {
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

void challengesFilterListAlert(ChallengesController controller) {
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
                      borderRadius: BorderRadius.circular(25.sp),
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
            padding: EdgeInsets.only(bottom: 20.0.sp),
            child: const StyledText(
              '운동모드',
              fontWeight: 500,
              fontSize: 20,
              lineHeight: 22,
            ),
          ),
          Obx(() {
            return SizedBox(
              width: double.infinity,
              child: Wrap(
                children: [
                  ...controller.exerciseTypeFilterList.asMap().entries.map(
                        (entry) => Padding(
                          padding: EdgeInsets.only(right: 10.sp),
                          child: InkWell(
                            onTap: () => controller.onSelectCategory(entry.value['value']),
                            child: Container(
                              decoration: BoxDecoration(
                                color: controller.selectedStatus.any((element) => element == entry.value['value']) ? Colors.white : popupBgColor,
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
                                  color: controller.selectedStatus.any((element) => element == entry.value['value']) ? Colors.black : Colors.white,
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

void challengeItemSoldOutAlert() {
  showAlert(
    contentWidget: Padding(
      padding: EdgeInsets.only(top: 20.0.sp, bottom: 40.sp),
      child: const Column(
        children: [
          StyledText(
            '해당 아이템은 판매가 완료되어\n챌린지 참여가 불가능합니다.',
            fontSize: 20,
            lineHeight: 28,
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

void challengeEndedAlert() {
  showAlert(
    contentWidget: Padding(
      padding: EdgeInsets.only(top: 20.0.sp, bottom: 40.sp),
      child: const Column(
        children: [
          StyledText(
            '챌린지가 종료되어 해당 아이템을\n구매할 수 없습니다.',
            fontSize: 20,
            lineHeight: 28,
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

void moveBuyChallengeItemPageAlert(ChallengesDetailController controller, int itemId) {
  showAlert(
    contentWidget: Padding(
      padding: EdgeInsets.only(top: 20.0.sp, bottom: 40.sp),
      child: const Column(
        children: [
          StyledText(
            '해당 챌린지에 참여하기 위해\n아이템을 구매하러 가시겠습니까?',
            fontSize: 20,
            lineHeight: 28,
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
            Get.back();
            Get.toNamed(Routes.shopItemDetail, arguments: {'id': itemId});
          },
          buttonText: '네',
          buttonColor: skyBlueColor,
        ),
      ),
    ],
  );
}

void challengeItemEquip() {
  ChallengesDetailController challengesDetailController = Get.find();
  showAlert(
    contentWidget: Padding(
      padding: EdgeInsets.only(top: 20.0.sp, bottom: 40.sp),
      child: const Column(
        children: [
          StyledText(
            '챌린지 참가가 가능합니다.\n장착 하시겠어요?',
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

            if (challengesDetailController.challengeDetails.value.challengeUserState != 'JOINED_UNEQUIPPED_ITEM' && challengesDetailController.challengeDetails.value.challengeState == 'IN_PROGRESS') {
              await challengesDetailController.onFetchJoinChallenge();
            }
            challengesDetailController.fetchEquipItem(challengesDetailController.challengeDetails.value.userItem!.id);
          },
          buttonText: '장착하기',
          buttonColor: skyBlueColor,
        ),
      ),
    ],
  );
}

void checkChallengeItemEquip(InventoryController controller, int itemId) {
  showAlert(
    title: '확인해주세요',
    contentWidget: Padding(
      padding: EdgeInsets.only(top: 30.sp, bottom: 50.sp),
      child: Text.rich(
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 18.sp,
          height: 26.sp / 18.sp,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
        const TextSpan(
          text: '챌린지에 참여중인 아이템을\n장착중입니다. 다른 아이템을 착용하시면\n',
          children: [
            TextSpan(text: '챌린지 참여에 제외됩니다!', style: TextStyle(color: skyBlueColor)),
          ],
        ),
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
          onTap: () => {Get.back(), controller.fetchEquipItem(itemId)},
          buttonText: '장착하기',
          buttonColor: skyBlueColor,
        ),
      ),
    ],
  );
}

void consumerItemUsagePopup(controller, context) {
  Get.bottomSheet(
    isDismissible: false,
    isScrollControlled: true,
    enableDrag: false,
    PopScope(
      canPop: false,
      child: Container(
        decoration: BoxDecoration(
          color: popupBgColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12.sp),
            topRight: Radius.circular(12.sp),
          ),
        ),
        child: SizedBox(
          height: MediaQuery.of(context).size.height - 80,
          child: Padding(
            padding: EdgeInsets.only(top: 30.0.sp, bottom: 40.sp),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 30.sp),
                  child: StyledText(
                    controller.selectedType == 'STAMINA' ? '체력 회복하기' : '내구도 수리하기',
                    fontSize: 22,
                    fontWeight: 500,
                    lineHeight: 22,
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Obx(() {
                      return Column(
                        children: [
                          if (controller.consumerItemList.value != null)
                            ...controller.consumerItemList.map((item) {
                              return Obx(() {
                                return Padding(
                                  padding: EdgeInsets.only(bottom: 10.0.sp, left: 20.sp, right: 20.sp),
                                  child: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: subBg02Color,
                                      border: Border.all(
                                        width: 2.sp,
                                        color: Colors.black,
                                      ),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10.sp),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(vertical: 14.0.sp, horizontal: 16.0.sp),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 114.sp,
                                            height: 92.sp,
                                            decoration: BoxDecoration(
                                              color: popupBgColor,
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(12.sp),
                                              ),
                                            ),
                                            child: Stack(children: [
                                              Padding(
                                                padding: EdgeInsets.all(10.0.sp),
                                                child: item.itemImageUrl.contains('.svg')
                                                    ? SvgPicture.network(
                                                        item.itemImageUrl,
                                                        placeholderBuilder: (BuildContext context) => const Center(child: SizedBox.square(dimension: 40, child: CircularProgressIndicator(color:skyBlueColor))),
                                                      )
                                                    : CachedNetworkImage(
                                                        imageUrl: item.itemImageUrl,
                                                        placeholder: (context, url) => const Center(child: SizedBox.square(dimension: 40, child: CircularProgressIndicator(color:skyBlueColor))),
                                                        errorWidget: (context, url, error) => Image.asset("assets/images/@temp_badge.png"),
                                                      ),
                                              ),
                                              if (item.amount! > 1)
                                                Positioned(
                                                  left: 8.sp,
                                                  top: 8.sp,
                                                  child: Container(
                                                      decoration: BoxDecoration(
                                                        color: const Color(0xFF0E0E13),
                                                        borderRadius: BorderRadius.circular(6),
                                                      ),
                                                      child: Padding(
                                                        padding: EdgeInsets.symmetric(vertical: 4.sp, horizontal: 6.0.sp),
                                                        child: StyledText(
                                                          item.amount != null
                                                              ? item.amount > 99
                                                                  ? '99+'
                                                                  : item.amount.toString()
                                                              : '0',
                                                          fontSize: 12,
                                                          lineHeight: 12,
                                                          letterSpacing: -.1,
                                                          fontWeight: 600,
                                                        ),
                                                      )),
                                                ),
                                              Positioned(
                                                right: 8.sp,
                                                top: 8.sp,
                                                width: 18,
                                                height: 18,
                                                child: getItemGradeCircleIcon(item.itemGrade),
                                              ),
                                            ]),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding: EdgeInsets.only(left: 22.0.sp),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Text(item.itemName,
                                                      style: AppTextStyleData.regular().koBodyMediumLg.copyWith(
                                                            color: AppColorData.regular().colorTextPrimary,
                                                          )),
                                                  Padding(
                                                    padding: EdgeInsets.only(top: 4.sp),
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          '효과 : ${item.itemType == 'RECOVERY' ? item.itemStat.recoveryStamina.toInt() : item.itemStat.repairDurability.toInt()}',
                                                          style: AppTextStyleData.regular().koBodyMediumMd.copyWith(
                                                                color: AppColorData.regular().colorTextTertiary,
                                                              ),
                                                        ),
                                                        Padding(
                                                          padding: EdgeInsets.all(3.0.sp),
                                                          child: Text(
                                                            item.itemType == 'RECOVERY' ? '회복' : '수리',
                                                            style: AppTextStyleData.regular().koBodyMediumMd.copyWith(
                                                                  color: AppColorData.regular().colorTextTertiary,
                                                                ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  if (controller.getRepairUseItem(item.id) != null)
                                                    Padding(
                                                      padding: EdgeInsets.only(top: 8.0.sp),
                                                      child: SizedBox(
                                                        width: double.infinity,
                                                        child: Align(
                                                          alignment: Alignment.centerRight,
                                                          child: ItemCounter(
                                                            item: controller.getRepairUseItem(item.id),
                                                            callbackFnc: (item, updatedCount) => controller.updateSpendCount(item, updatedCount),
                                                            maxCount: item.amount,
                                                          ),
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
                              });
                            })
                        ],
                      );
                    }),
                  ),
                ),
                Obx(() {
                  return Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 20.0.sp, left: 20.0.sp, right: 20.0.sp),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              controller.selectedType == 'STAMINA' ? '현재 체력' : '현재 내구도',
                              style: AppTextStyleData.regular().koBodyMediumLg.copyWith(
                                    color: AppColorData.regular().colorTextPrimary,
                                  ),
                            ),
                            Text(
                              formatDecimalPlaces(controller.currentStat.value, 2),
                              style: AppTextStyleData.regular().koBodyMediumLg.copyWith(
                                    color: AppColorData.regular().colorTextPrimary,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 14.0.sp, left: 20.0.sp, right: 20.0.sp),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '회복량',
                              style: AppTextStyleData.regular().koBodyMediumLg.copyWith(
                                    color: AppColorData.regular().colorTextPrimary,
                                  ),
                            ),
                            Text(
                              formatDecimalPlaces(controller.totalStat.toDouble(), 0),
                              style: AppTextStyleData.regular().koBodyMediumLg.copyWith(
                                    color: AppColorData.regular().colorTextPrimary,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 20.0.sp),
                        child: const Divider(
                          color: Color(0xFF494B56),
                          height: 1,
                          thickness: 2,
                        ),
                      ),
                      Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(bottom: 1.0.sp, left: 20.0.sp, right: 20.0.sp),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  controller.selectedType.value == 'STAMINA' ? '회복 후 체력' : '수리 후 내구도',
                                  style: AppTextStyleData.regular().koBodyMediumLg.copyWith(
                                        color: controller.resultStat.value > controller.currentStat.value
                                            ? controller.resultStat.value > 9999
                                                ? AppColorData.regular().colorTextWarning
                                                : AppColorData.regular().colorTextBrand
                                            : AppColorData.regular().colorTextPrimary,
                                      ),
                                ),
                                Text(
                                  formatDecimalPlaces(controller.resultStat.value, 2),
                                  style: AppTextStyleData.regular().koBodyMediumLg.copyWith(
                                        color: controller.resultStat.value > controller.currentStat.value
                                            ? controller.resultStat.value > 9999
                                                ? AppColorData.regular().colorTextWarning
                                                : AppColorData.regular().colorTextBrand
                                            : AppColorData.regular().colorTextPrimary,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          controller.resultStat.value > 9999
                              ? Padding(
                                  padding: EdgeInsets.symmetric(vertical: 13.0.sp),
                                  child: const StyledText(
                                    '9999 이하로만 회복이 가능 합니다.',
                                    fontSize: 14,
                                    fontWeight: 500,
                                    lineHeight: 14,
                                    color: Color(0xFFFF2222),
                                  ),
                                )
                              : SizedBox(height: 40.sp),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.sp),
                            child: Row(
                              children: [
                                Expanded(
                                  child: GazagoButton(
                                    onTap: () {
                                      Get.back();
                                      controller.initStat();
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
                                    onTap: () {
                                      if (controller.resultStat.value <= 9999 && controller.totalStat > 0) {
                                        if (controller.selectedType.value == 'STAMINA') {
                                          if (controller.exerciseState.value != ExerciseState.ongoing) {
                                            Get.back();
                                            showAutoRechargeStaminaAlert(controller);
                                          } else {
                                            Get.back();
                                            controller.confirmRecoveryOrRepairStat(controller.selectedType.value);
                                          }
                                        } else {
                                          Get.back();
                                          controller.confirmRecoveryOrRepairStat(controller.selectedType.value);
                                        }
                                      }
                                      return;
                                    },
                                    buttonText: controller.selectedType == 'STAMINA' ? '회복하기' : '수리하기',
                                    textColor: Colors.black,
                                    buttonColor: controller.resultStat.value <= 9999 && controller.totalStat > 0 ? skyBlueColor : const Color(0xFF11A4AD),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

void shortConsumerItems(String itemType) {
  HomeMenuController homeMenuController = Get.isRegistered<HomeMenuController>() ? Get.find<HomeMenuController>() : Get.put(HomeMenuController());
  ShopController shopController = Get.isRegistered<ShopController>() ? Get.find<ShopController>() : Get.put(ShopController());
  showAlert(
    title: itemType == 'STAMINA' ? '회복 아이템이 없어요' : '수리 아이템이 없어요',
    contentWidget: Padding(
      padding: EdgeInsets.only(top: 20.0.sp, bottom: 40.sp),
      child: Text(
        '상점에서 아이템을 구매할까요?',
        style: AppTextStyleData.regular().koBodyMediumLg.copyWith(
              color: AppColorData.regular().colorTextPrimary,
            ),
        textAlign: TextAlign.center,
      ),
    ),
    actions: [
      Expanded(
        child: GazagoButton(
          onTap: () => Get.back(),
          buttonText: '취소',
          textColor: Colors.white,
          buttonColor: AppColorData.regular().colorBgInteractiveSecondary,
        ),
      ),
      SizedBox(
        width: 9.sp,
      ),
      Expanded(
        child: GazagoButton(
          onTap: () {
            Get.back();
            Get.until((route) => route.isFirst);
            homeMenuController.selectMenu(3);
            shopController.moveToETC();
          },
          buttonText: '구매하러 가기',
          buttonColor: AppColorData.regular().colorBgInteractivePrimary,
        ),
      ),
    ],
  );
}

void participateInChallengeByCodeAlert() {
  ChallengesDetailController controller = Get.find();
  Get.dialog(
    barrierColor: subBg01Color.withOpacity(0.2),
    useSafeArea: true,
    barrierDismissible: false,
    PopScope(
      canPop: false,
      child: Dialog(
        insetPadding: EdgeInsets.zero,
        backgroundColor: subBg01Color.withOpacity(0.2),
        child: Padding(
          padding: EdgeInsets.all(20.0.sp),
          child: Stack(
            children: [
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: popupBgColor,
                    borderRadius: BorderRadius.all(
                      Radius.circular(20.sp),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0.sp, vertical: 30.sp),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: 14.0.sp),
                          child: const StyledText(
                            '참여코드 입력',
                            fontSize: 20,
                            lineHeight: 21,
                            fontWeight: 500,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 35.0.sp),
                          child: const StyledText(
                            '참여코드 입력이 필요한 챌린지 입니다.',
                            fontSize: 16,
                            lineHeight: 17,
                            fontWeight: 500,
                          ),
                        ),
                        Obx(() {
                          return TextField(
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: subBg01Color,
                              hintText: '참여코드를 입력해주세요.',
                              hintStyle: const TextStyle(
                                color: deepGrayColor,
                                fontSize: 18,
                                height: 20 / 18,
                                fontWeight: FontWeight.w500,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                                borderSide: BorderSide(width: 2, color: controller.errorMessage.value == '' ? skyBlueColor : const Color(0xFFFF4C4C)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                                borderSide: BorderSide(width: 2, color: controller.errorMessage.value == '' ? Colors.transparent : const Color(0xFFFF4C4C)),
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(width: 2, color: controller.errorMessage.value == '' ? Colors.transparent : const Color(0xFFFF4C4C)),
                                borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                              ),
                            ),
                            controller: controller.codeTextController,
                            textInputAction: TextInputAction.go,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(r'[a-zaA-Z0-9]')),
                              LengthLimitingTextInputFormatter(6),
                              TextInputFormatter.withFunction((oldValue, newValue) {
                                return newValue.copyWith(text: newValue.text.toUpperCase());
                              }),
                            ],
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.sp,
                              height: 20 / 18,
                              fontWeight: FontWeight.w600,
                            ),
                            autofocus: false,
                            cursorColor: Colors.white,
                            focusNode: controller.focusNode,
                            onChanged: (value) => controller.setCode(value),
                            onSubmitted: (val) {
                              Get.back();
                              controller.onFetchJoinChallenge();
                            },
                          );
                        }),
                        Obx(() {
                          return SizedBox(
                            height: 50.sp,
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 20.0.sp),
                              child: StyledText(controller.errorMessage.value, fontSize: 14, color: Colors.redAccent, fontWeight: 500, lineHeight: 15),
                            ),
                          );
                        }),
                        Padding(
                          padding: EdgeInsets.only(top: 5.0.sp),
                          child: Row(
                            children: [
                              Expanded(
                                child: GazagoButton(
                                  onTap: () => controller.closeParticipateInCodeAlert(),
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
                                    controller.onFetchJoinChallenge();
                                  },
                                  buttonText: '확인',
                                  buttonColor: skyBlueColor,
                                ),
                              ),
                            ],
                          ),
                        )
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
  );
}

Future<void> showFairPlayAlert() async {
  Completer completer = Completer();
  Get.dialog(
    barrierColor: subBg01Color.withOpacity(0.2),
    useSafeArea: true,
    barrierDismissible: false,
    PopScope(
      canPop: false,
      child: Dialog(
        insetPadding: EdgeInsets.zero,
        backgroundColor: subBg01Color.withOpacity(0.8),
        child: Padding(
          padding: EdgeInsets.all(25.0.sp),
          child: Container(
            height: Get.context!.size!.height * 0.7,
            padding: const EdgeInsets.only(top: 38, bottom: 28),
            decoration: BoxDecoration(
              color: popupBgColor,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                iconFairplayAlert,
                const Padding(
                  padding: EdgeInsets.only(
                    top: 18.0,
                    bottom: 30,
                  ),
                  child: StyledText(
                    '가자고 페어플레이',
                    fontSize: 18,
                    lineHeight: 18,
                    fontWeight: 700,
                  ),
                ),
                Expanded(
                  child: FairPlayContent(
                    padding: const EdgeInsets.only(
                      left: 30,
                      right: 30,
                      bottom: 30,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 20,
                    left: 30,
                    right: 30,
                  ),
                  child: GazagoButton(
                    onTap: () {
                      Get.back();
                      completer.complete();
                    },
                    buttonText: '확인했습니다.',
                    buttonColor: skyBlueColor,
                    textColor: Colors.black,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    ),
  );
  return completer.future;
}

void showLockedUserAlert() async {
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
        const TextSpan(
          text: '경고 & 퇴장 카드 운영 정책에 따라\n계정 블락중입니다. ',
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

void showAutoRechargeStaminaAlert(ActivityController controller) {
  showAlert(
    contentWidget: Center(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 14.sp, bottom: 30.sp),
            child: StyledText(
              '체력은 시간이 지나면 회복됩니다.\n정말 회복하시겠습니까?',
              fontSize: 18.sp,
              fontWeight: 500,
              lineHeight: 24.sp,
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
            controller.initStat();
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
          onTap: () {
            Get.back();
            controller.confirmRecoveryOrRepairStat(controller.selectedType.value);
          },
          buttonText: '확인',
          buttonColor: skyBlueColor,
        ),
      ),
    ],
  );
}

void crewJoinInfoAlert(CrewModel crew) async {
  await showAlert(
    title: '크루 가입 안내',
    contentWidget: Padding(
      padding: EdgeInsets.only(top: 22.sp, bottom: 49.sp),
      child: const StyledText(
        '크루에 가입하면 챌린지 종료시까지\n크루를 떠날 수 없습니다\n정말로 가입하시겠습니까?',
        fontWeight: 500,
        fontSize: 16,
        lineHeight: 24,
        letterSpacing: -.1,
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
          buttonText: '네',
          onTap: () {
            Get.back();
            Get.find<ChallengesDetailController>().requestJoinCrew(crew);
          },
        ),
      ),
    ],
  );
}

void showChallengeAlreadyJoinedAlert() {
  showAlert(
    allowMultipleBottomSheet: true,
    contentWidget: Padding(
      padding: EdgeInsets.only(top: 22.sp, bottom: 49.sp),
      child: const StyledText(
        '다른 계정으로 이미 해당 챌린지에\n참가 중입니다.',
        fontWeight: 500,
        fontSize: 16,
        lineHeight: 24,
        letterSpacing: -.1,
        textAlign: TextAlign.center,
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

void crewJoinCompleteAlert(CrewModel crew) async {
  await showAlert(
    contentWidget: Padding(
      padding: EdgeInsets.only(top: 22.sp, bottom: 49.sp),
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: Colors.black,
            radius: 25.sp,
            foregroundImage: (crew.iconImageUrl == null || crew.iconImageUrl == '')
                ? Image.asset(
                    'assets/images/ic_launcher.png',
                    width: 50.sp,
                  ).image
                : crew.iconImageUrl!.contains('.svg')
                    ? sp.Svg(crew.iconImageUrl!, source: sp.SvgSource.network) as ImageProvider
                    : CachedNetworkImageProvider(
                        crew.iconImageUrl!,
                        headers: imageNetworkHeader,
                      ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20.0.sp),
            child: const StyledText(
              '크루가입을 환영합니다!',
              fontWeight: 500,
              fontSize: 22,
              lineHeight: 22,
              letterSpacing: -.1,
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20.0.sp),
            child: const StyledText(
              '크루 가입을 환영합니다!\n크루원 페이지로 이동합니다\n크루챌린지를 즐겨주세요!',
              fontWeight: 500,
              fontSize: 16,
              lineHeight: 24,
              letterSpacing: -.1,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    ),
    actions: [
      Expanded(
        child: GazagoButton(
          buttonText: '확인',
          onTap: () {
            Get.back();
            Get.find<ChallengesDetailController>().moveToMyCrew();
          },
        ),
      ),
    ],
  );
}

void crewCreateCompleteAlert(ChallengesDetailController controller) async {
  await showAlert(
    contentWidget: Padding(
      padding: EdgeInsets.only(top: 22.sp, bottom: 49.sp),
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: Colors.black,
            radius: 25.sp,
            foregroundImage: (controller.myCrew.value!['crew'].iconImageUrl == null || controller.myCrew.value!['crew'].iconImageUrl == '')
                ? Image.asset(
                    'assets/images/ic_launcher.png',
                    width: 50.sp,
                  ).image
                : controller.myCrew.value!['crew'].iconImageUrl!.contains('.svg')
                    ? sp.Svg(controller.myCrew.value!['crew'].iconImageUrl!, source: sp.SvgSource.network) as ImageProvider
                    : CachedNetworkImageProvider(
                        controller.myCrew.value!['crew'].iconImageUrl!,
                        headers: imageNetworkHeader,
                      ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20.0.sp),
            child: const StyledText(
              '크루개설을 축하합니다!',
              fontWeight: 500,
              fontSize: 22,
              lineHeight: 22,
              letterSpacing: -.1,
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20.0.sp),
            child: const StyledText(
              '크루 개설을 축하합니다!\n크루원 페이지로 이동합니다\n크루챌린지를 즐겨주세요!',
              fontWeight: 500,
              fontSize: 16,
              lineHeight: 24,
              letterSpacing: -.1,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    ),
    actions: [
      Expanded(
        child: GazagoButton(
          buttonText: '확인',
          onTap: () {
            Get.back();
            controller.moveToMyCrew();
          },
        ),
      ),
    ],
  );
}

void shortTikCreateCrewAlert() async {
  await showAlert(
    allowMultipleBottomSheet: true,
    title: '잔액이 부족합니다',
    contentWidget: Padding(
      padding: EdgeInsets.only(top: 22.sp, bottom: 49.sp),
      child: const StyledText(
        '챌린지 공유하기로\n무료로 개설이 가능합니다',
        fontWeight: 500,
        fontSize: 16,
        lineHeight: 24,
        letterSpacing: -.1,
        textAlign: TextAlign.center,
      ),
    ),
    actions: [
      Expanded(
        child: GazagoButton(
          onTap: () => Get.back(),
          buttonText: '닫기',
          textColor: Colors.white,
          buttonColor: popupBgColor,
        ),
      ),
      // SizedBox(
      //   width: 9.sp,
      // ),
      // Expanded(
      //   child: GazagoButton(
      //     buttonText: '충전하기',
      //     onTap: () {
      //       Get.back();
      //       showProductList();
      //     },
      //   ),
      // ),
    ],
  );
}

void showCrewRelayEndedAlert(CrewDetailController controller) async {
  await showAlert(
    contentWidget: Padding(
      padding: EdgeInsets.only(top: 22.sp, bottom: 49.sp),
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: Colors.black,
            radius: 25.sp,
            foregroundImage: (controller.selectedCrew.value!.iconImageUrl == null || controller.selectedCrew.value!.iconImageUrl == '')
                ? Image.asset(
                    'assets/images/ic_launcher.png',
                    width: 50.sp,
                  ).image
                : controller.selectedCrew.value!.iconImageUrl!.contains('.svg')
                    ? sp.Svg(controller.selectedCrew.value!.iconImageUrl!, source: sp.SvgSource.network) as ImageProvider
                    : CachedNetworkImageProvider(
                        controller.selectedCrew.value!.iconImageUrl!,
                        headers: imageNetworkHeader,
                      ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20.0.sp),
            child: const StyledText(
              '너무 아쉬워요',
              fontWeight: 500,
              fontSize: 22,
              lineHeight: 22,
              letterSpacing: -.1,
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20.0.sp),
            child: const StyledText(
              '정시 12시안에 0개의 블럭을 쌓았기 때문에\n크루릴레이가 자동으로 종료되었어요!\n챌린지 종료 이후 쌓은 블럭만큼은 보상지급됩니다\n감사합니다.',
              fontWeight: 500,
              fontSize: 16,
              lineHeight: 24,
              letterSpacing: -.1,
              textAlign: TextAlign.center,
            ),
          ),
        ],
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

void crewRecruitLimitAlert(CrewDetailController controller) async {
  await showAlert(
    contentWidget: Padding(
      padding: EdgeInsets.only(top: 22.sp, bottom: 49.sp),
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              CircleAvatar(
                backgroundColor: Colors.black,
                radius: 25.sp,
                foregroundImage: (controller.selectedCrew.value!.iconImageUrl == null || controller.selectedCrew.value!.iconImageUrl == '')
                    ? Image.asset(
                        'assets/images/ic_launcher.png',
                        width: 50.sp,
                      ).image
                    : controller.selectedCrew.value!.iconImageUrl!.contains('.svg')
                        ? sp.Svg(controller.selectedCrew.value!.iconImageUrl!, source: sp.SvgSource.network) as ImageProvider
                        : CachedNetworkImageProvider(
                            controller.selectedCrew.value!.iconImageUrl!,
                            headers: imageNetworkHeader,
                          ),
              ),
              Positioned(
                bottom: 0,
                right: -5.sp,
                child: SvgPicture.asset(
                  'assets/images/challenges/ico_circle_limit.svg',
                  width: 23.sp,
                  height: 23.sp,
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 20.0.sp),
            child: const StyledText(
              '크루 모집을\n제한하시겠습니까?',
              fontWeight: 500,
              fontSize: 22,
              lineHeight: 30,
              letterSpacing: -.1,
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20.0.sp),
            child: const StyledText(
              '크루 모집을 더 이상 받지 않으시겠습니까?\n크루 모집 제한은 총 20명이 되면\n자동으로 잠금이 됩니다.',
              fontWeight: 500,
              fontSize: 16,
              lineHeight: 24,
              letterSpacing: -.1,
              textAlign: TextAlign.center,
            ),
          ),
        ],
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
          buttonText: '네',
          onTap: () {
            Get.back();
            controller.requestToggleRecruitStatus();
          },
        ),
      ),
    ],
  );
}

void crewRecruitUnlimitAlert(CrewDetailController controller) async {
  await showAlert(
    contentWidget: Padding(
      padding: EdgeInsets.only(top: 22.sp, bottom: 49.sp),
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              CircleAvatar(
                backgroundColor: Colors.black,
                radius: 25.sp,
                foregroundImage: (controller.selectedCrew.value!.iconImageUrl == null || controller.selectedCrew.value!.iconImageUrl == '')
                    ? Image.asset(
                        'assets/images/ic_launcher.png',
                        width: 50.sp,
                      ).image
                    : controller.selectedCrew.value!.iconImageUrl!.contains('.svg')
                        ? sp.Svg(controller.selectedCrew.value!.iconImageUrl!, source: sp.SvgSource.network) as ImageProvider
                        : CachedNetworkImageProvider(
                            controller.selectedCrew.value!.iconImageUrl!,
                            headers: imageNetworkHeader,
                          ),
              ),
              Positioned(
                bottom: 0,
                right: -5.sp,
                child: InkWell(
                  onTap: () => Get.back(),
                  child: SvgPicture.asset(
                    'assets/images/challenges/ico_circle_unlimit.svg',
                    width: 23.sp,
                    height: 23.sp,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 20.0.sp),
            child: const StyledText(
              '크루 모집을\n제한을 푸시겠습니까?',
              fontWeight: 500,
              fontSize: 22,
              lineHeight: 30,
              letterSpacing: -.1,
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20.0.sp),
            child: const StyledText(
              '크루 모집을 더 받으시겠습니까?\n크루 모집 제한은 총 20명이 되면\n자동으로 잠금이 됩니다.',
              fontWeight: 500,
              fontSize: 16,
              lineHeight: 24,
              letterSpacing: -.1,
              textAlign: TextAlign.center,
            ),
          ),
        ],
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
          buttonText: '네',
          onTap: () {
            Get.back();
            controller.requestToggleRecruitStatus();
          },
        ),
      ),
    ],
  );
}

void crewRecruitToggleLimitErrorAlert(String errorMessage) async {
  await showAlert(
    contentWidget: Padding(
      padding: EdgeInsets.only(top: 22.sp, bottom: 49.sp),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 20.0.sp),
            child: StyledText(
              errorMessage.replaceAll('\\n', '\n'),
              fontWeight: 500,
              fontSize: 16,
              lineHeight: 24,
              letterSpacing: -.1,
              textAlign: TextAlign.center,
            ),
          ),
        ],
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

void crewChallengeCloseAlert(ChallengesDetailController controller) async {
  await showAlert(
    contentWidget: Padding(
      padding: EdgeInsets.only(top: 22.sp, bottom: 49.sp),
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: Colors.black,
            radius: 25.sp,
            foregroundImage: (controller.myCrew.value!['crew'].iconImageUrl == null || controller.myCrew.value!['crew'].iconImageUrl == '')
                ? Image.asset(
                    'assets/images/ic_launcher.png',
                    width: 50.sp,
                  ).image
                : controller.myCrew.value!['crew'].iconImageUrl!.contains('.svg')
                    ? sp.Svg(controller.myCrew.value!['crew'].iconImageUrl!, source: sp.SvgSource.network) as ImageProvider
                    : CachedNetworkImageProvider(
                        controller.myCrew.value!['crew'].iconImageUrl!,
                        headers: imageNetworkHeader,
                      ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20.0.sp),
            child: const StyledText(
              '챌린지가 종료되었습니다!',
              fontWeight: 500,
              fontSize: 22,
              lineHeight: 22,
              letterSpacing: -.1,
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20.0.sp),
            child: const StyledText(
              '모두들 수고하셨습니다\n공정성을 위해 챌린지 랭킹 점검 후\n랭킹을 공지&보상을 지급하도록 하겠습니다\n감사합니다',
              fontWeight: 500,
              fontSize: 16,
              lineHeight: 24,
              letterSpacing: -.1,
              textAlign: TextAlign.center,
            ),
          ),
        ],
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

void crewCreatePopup(ChallengesDetailController controller) async {
  List<Widget> _renderIcons(List<CrewIconModel> iconList) {
    List<Widget> rows = List.empty(
      growable: true,
    );
    List<Widget> icons = List.empty(
      growable: true,
    );
    for (int i = 0; i < iconList.length; i++) {
      icons.add(
        Material(
          color: Colors.transparent,
          shape: const CircleBorder(),
          clipBehavior: Clip.hardEdge,
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25.sp),
              color: const Color(0xff747474),
              image: DecorationImage(
                image: iconList[i].imageUrl.contains('.svg')
                    ? sp.Svg(iconList[i].imageUrl, source: sp.SvgSource.network) as ImageProvider
                    : CachedNetworkImageProvider(
                        iconList[i].imageUrl,
                        headers: imageNetworkHeader,
                      ),
              ),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(25.sp),
              onTap: () => controller.selectCrewMark(iconList[i]),
              child: Container(
                width: 50.sp,
                height: 50.sp,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(color: iconList[i].id == controller.selectedMarkIconId.value ? skyBlueColor : Colors.transparent, width: 2),
                  borderRadius: BorderRadius.circular(25.sp),
                ),
              ),
            ),
          ),
        ),
      );

      if (i != 0 && icons.length % 5 == 0) {
        if (i < 5) {
          rows.add(Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ...icons,
            ],
          ));
        } else {
          rows.add(
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ...icons,
                ],
              ),
            ),
          );
        }
        icons.clear();
      }
    }
    return rows;
  }

  await Get.bottomSheet(
    isDismissible: false,
    isScrollControlled: true,
    enableDrag: false,
    PopScope(
      canPop: false,
      child: GestureDetector(
        onTap: () => FocusScope.of(Get.context!).requestFocus(FocusNode()),
        child: Container(
          decoration: BoxDecoration(
            color: popupBgColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12.sp),
              topRight: Radius.circular(12.sp),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(20.0.sp),
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 22.sp, bottom: 28.sp),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: 20.0.sp),
                          child: const StyledText(
                            '크루 개설하기',
                            fontSize: 22,
                            letterSpacing: -.1,
                            fontWeight: 600,
                          ),
                        ),
                        Text.rich(
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16.sp,
                            height: 24.sp / 16.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                          const TextSpan(
                            text: '챌린지 기간동안 함께할 크루를 만들어주세요!\n크루를 개설할 시 ',
                            children: [
                              TextSpan(text: '3블럭', style: TextStyle(color: skyBlueColor)),
                              TextSpan(text: '을 제공해드립니다!'),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 4.0.sp),
                          child: const StyledText(
                            '크루 개설 비용 3,000 TIK',
                            fontWeight: 500,
                            fontSize: 16,
                            lineHeight: 24,
                            letterSpacing: -.1,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 33.0.sp, bottom: 8.0.sp, left: 5.sp),
                              child: const StyledText(
                                '크루 마크',
                                fontSize: 16,
                                lineHeight: 18,
                                color: lightGrayColor,
                                fontWeight: 500,
                              ),
                            ),
                            Container(
                                padding: EdgeInsets.symmetric(vertical: 16.0.sp, horizontal: 20.sp),
                                decoration: BoxDecoration(
                                  color: subBg01Color,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10.sp),
                                  ),
                                ),
                                child: Obx(() {
                                  return Column(
                                    children: [
                                      ..._renderIcons(controller.crewMarkIcons),
                                    ],
                                  );
                                })),
                            Padding(
                              padding: EdgeInsets.only(top: 22.0.sp, bottom: 8.sp, left: 5.sp),
                              child: const StyledText(
                                '크루 이름',
                                fontSize: 16,
                                lineHeight: 18,
                                color: lightGrayColor,
                                fontWeight: 500,
                              ),
                            ),
                            TextField(
                              controller: controller.crewNameController,
                              cursorColor: Colors.white,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: subBg01Color,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                                hintText: '크루명을 작성해주세요.',
                                hintStyle: const TextStyle(
                                  color: popupBgColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  height: 1,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                              onChanged: (name) => controller.updateCrewName(name),
                              keyboardType: TextInputType.name,
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(bottom: 3.sp),
                          child: InkWell(
                            onTap: () => controller.handleCreateCrewType('TIK'),
                            borderRadius: BorderRadius.circular(8.sp),
                            child: Container(
                              decoration: BoxDecoration(
                                color: popupBgColor,
                                border: Border.all(width: 2.sp, color: skyBlueColor),
                                borderRadius: BorderRadius.circular(8.sp),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black,
                                    offset: Offset(0, 4.sp),
                                  )
                                ],
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 7.0.sp),
                                child: const Center(
                                  child: Column(
                                    children: [
                                      StyledText(
                                        '개설하기',
                                        fontSize: 18,
                                        lineHeight: 18,
                                        fontWeight: 600,
                                        color: Colors.white,
                                      ),
                                      StyledText(
                                        '3,000TIK',
                                        fontSize: 12,
                                        lineHeight: 16,
                                        fontWeight: 600,
                                        letterSpacing: -.1,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 9.sp,
                      ),
                      Expanded(
                        child: GazagoButton(
                          buttonText: '무료 개설',
                          onTap: () => controller.handleCreateCrewType('INVITE'),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8.0.sp),
                    child: GazagoButton(
                      onTap: () => Get.back(),
                      buttonText: '취소',
                      textColor: Colors.white,
                      buttonColor: popupBgColor,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

void shareCrewChallengeKakaoLinkDialog(ChallengesDetailController controller) {
  Get.dialog(
    Dialog(
      shadowColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      child: Center(
        child: Container(
          height: 270.sp,
          decoration: BoxDecoration(
            color: popupBgColor,
            borderRadius: BorderRadius.all(
              Radius.circular(12.sp),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(20.0.sp),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      StyledText(
                        controller.challengeDetails.value.challengeActivationType == 'CREW' ? '카카오톡으로 친구에게 링크를\n공유하면 크루를 무료로\n개설할 수 있어요!' : '카카오톡으로 친구에게 링크를\n공유하면 챌린지에 무료로\n참여할 수 있어요!',
                        textAlign: TextAlign.center,
                        fontWeight: 500,
                        fontSize: 20,
                        lineHeight: 30,
                      ),
                      const StyledText(
                        '(본인 공유는 불가 합니다)',
                        textAlign: TextAlign.center,
                        fontWeight: 500,
                        fontSize: 16,
                        lineHeight: 30,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 25.sp),
                  child: Row(
                    children: [
                      Expanded(
                        child: GazagoButton(
                          onTap: () => Get.back(),
                          buttonText: '닫기',
                          textColor: Colors.white,
                          buttonColor: popupBgColor,
                        ),
                      ),
                      SizedBox(
                        width: 9.sp,
                      ),
                      Expanded(
                        child: GazagoButton(
                          buttonText: '공유하기',
                          onTap: () async {
                            Get.back();

                            if (controller.challengeDetails.value.challengeActivationType == 'CREW') {
                              controller.shareChallenge(challengeType: ChallengeType.crew, shareSource: ShareSource.createCrew);
                              await Future.delayed(const Duration(seconds: 2));
                              // askSharedCompleteDialog(controller, challengeType: ChallengeType.crew, shareSource: ShareSource.createCrew);
                            } else {
                              if (controller.challengeDetails.value.challengeType == 'PAYMENT') {
                                controller.shareChallenge(challengeType: ChallengeType.payment, shareSource: ShareSource.mirae);
                                await Future.delayed(const Duration(seconds: 2));
                                // askSharedCompleteDialog(controller, challengeType: ChallengeType.payment, shareSource: ShareSource.mirae);
                              } else {
                                controller.shareChallenge(challengeType: ChallengeType.payment, shareSource: ShareSource.spot);
                                await Future.delayed(const Duration(seconds: 2));
                                // askSharedCompleteDialog(controller, challengeType: ChallengeType.payment, shareSource: ShareSource.spot);
                              }
                            }
                            // controller.setChallengeShareFlag();
                          },
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

void askSharedCompleteDialog(ChallengesDetailController controller, {required ChallengeType challengeType, required ShareSource shareSource}) {
  Get.dialog(
    PopScope(
      canPop: false,
      child: Dialog(
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        child: Center(
          child: Container(
            height: 270.sp,
            decoration: BoxDecoration(
              color: popupBgColor,
              borderRadius: BorderRadius.all(
                Radius.circular(12.sp),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(20.0.sp),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const StyledText(
                          '공유하기를 완료했나요?',
                          textAlign: TextAlign.center,
                          fontWeight: 500,
                          fontSize: 20,
                          lineHeight: 30,
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 12.0.sp),
                          child: StyledText(
                            controller.challengeDetails.value.challengeActivationType == 'CREW' ? '완료 버튼을 누르면 크루를\n무료로 개설할 수 있어요!' : '완료 버튼을 누르면\n챌린지에 무료로 참여할 수 있어요!',
                            textAlign: TextAlign.center,
                            fontWeight: 500,
                            fontSize: 16,
                            lineHeight: 24,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(children: [
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
                        buttonText: '완료',
                        onTap: () {
                          Get.back();
                          controller.validateKakaoShareResult(challengeType: challengeType, shareSource: shareSource);
                        },
                      ),
                    ),
                  ])
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

void unableShareMyselfDialog(ChallengesDetailController controller, {required ChallengeType challengeType, required ShareSource shareSource}) {
  Get.dialog(
    Dialog(
      shadowColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      child: Center(
        child: Container(
          height: 270.sp,
          decoration: BoxDecoration(
            color: popupBgColor,
            borderRadius: BorderRadius.all(
              Radius.circular(12.sp),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(20.0.sp),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const StyledText(
                        '본인 공유 불가',
                        textAlign: TextAlign.center,
                        fontWeight: 500,
                        fontSize: 20,
                        lineHeight: 30,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 17.0.sp),
                        child: const StyledText(
                          '본인에게 공유하기는\n인정되지 않아요\n친구에게 공유해주세요!',
                          textAlign: TextAlign.center,
                          fontWeight: 500,
                          fontSize: 16,
                          lineHeight: 24,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(children: [
                  Expanded(
                    child: GazagoButton(
                      onTap: () => Get.back(),
                      buttonText: '닫기',
                      textColor: Colors.white,
                      buttonColor: popupBgColor,
                    ),
                  ),
                  SizedBox(
                    width: 9.sp,
                  ),
                  Expanded(
                    child: GazagoButton(
                      buttonText: '다시 공유',
                      onTap: () async {
                        Get.back();
                        controller.shareChallenge(challengeType: challengeType, shareSource: shareSource);
                        await Future.delayed(const Duration(seconds: 2));
                        askSharedCompleteDialog(controller, challengeType: challengeType, shareSource: shareSource);
                      },
                    ),
                  ),
                ])
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

void unableSharedHistoryDialog(ChallengesDetailController controller, {required ChallengeType challengeType, required ShareSource shareSource}) {
  Get.dialog(
    Dialog(
      shadowColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      child: Center(
        child: Container(
          height: 270.sp,
          decoration: BoxDecoration(
            color: popupBgColor,
            borderRadius: BorderRadius.all(
              Radius.circular(12.sp),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(20.0.sp),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const StyledText(
                        '공유 확인 불가',
                        textAlign: TextAlign.center,
                        fontWeight: 500,
                        fontSize: 20,
                        lineHeight: 30,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 17.0.sp),
                        child: const StyledText(
                          '공유한 이력이 확인되지 않아요\n다시 공유해주세요!',
                          textAlign: TextAlign.center,
                          fontWeight: 500,
                          fontSize: 16,
                          lineHeight: 24,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(children: [
                  Expanded(
                    child: GazagoButton(
                      onTap: () => Get.back(),
                      buttonText: '닫기',
                      textColor: Colors.white,
                      buttonColor: popupBgColor,
                    ),
                  ),
                  SizedBox(
                    width: 9.sp,
                  ),
                  Expanded(
                    child: GazagoButton(
                      buttonText: '다시 공유',
                      onTap: () async {
                        Get.back();
                        controller.shareChallenge(challengeType: challengeType, shareSource: shareSource);
                        await Future.delayed(const Duration(seconds: 2));
                        askSharedCompleteDialog(controller, challengeType: challengeType, shareSource: shareSource);
                      },
                    ),
                  ),
                ])
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

void showCrewInviteInfoAlert(CrewDetailController controller) {
  Get.dialog(
    Dialog(
      shadowColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      child: Center(
        child: Container(
          height: 270.sp,
          decoration: BoxDecoration(
            color: popupBgColor,
            borderRadius: BorderRadius.all(
              Radius.circular(12.sp),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(20.0.sp),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const StyledText(
                        '크루챌린지 초대하기',
                        textAlign: TextAlign.center,
                        fontWeight: 500,
                        fontSize: 20,
                        lineHeight: 30,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 12.0.sp),
                        child: const StyledText(
                          '초대한 친구가 반드시 공유한 링크를\n통해 회원가입 및 챌린지에 참가해야\n블럭이 정상적으로 지급됩니다.\n(본인 공유는 불가 합니다)',
                          textAlign: TextAlign.center,
                          fontWeight: 500,
                          fontSize: 16,
                          lineHeight: 24,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(children: [
                  Expanded(
                    child: GazagoButton(
                      onTap: () => Get.back(),
                      buttonText: '닫기',
                      textColor: Colors.white,
                      buttonColor: popupBgColor,
                    ),
                  ),
                  SizedBox(
                    width: 9.sp,
                  ),
                  Expanded(
                    child: GazagoButton(
                      buttonText: '공유하기',
                      onTap: () {
                        Get.find<ChallengesDetailController>().shareChallenge(
                          challengeType: ChallengeType.crew,
                          shareSource: ShareSource.crewDetail,
                          crewName: controller.selectedCrew.value!.name,
                        );
                        Get.back();
                      },
                    ),
                  ),
                ])
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

void showConfirmNicknameChange(MyPageController controller) {
  showAlert(
    title: '닉네임을 변경하시겠습니까?',
    contentWidget: Center(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 14.sp, bottom: 30.sp),
            child: StyledText(
              '닉네임은 최초 1번만 수정할 수 있어요.\n정말 수정하시겠어요?',
              fontSize: 16.sp,
              fontWeight: 500,
              lineHeight: 22.sp,
              color: lightGrayColor,
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
            await controller.modifyMyAccountInfo();
            Get.back();
          },
          buttonText: '변경',
          buttonColor: skyBlueColor,
        ),
      ),
    ],
  );
}

void showChallengeNeedVerificationAlert() {
  Get.dialog(
    barrierColor: subBg01Color.withOpacity(0.8),
    PopScope(
      canPop: false,
      child: Dialog(
        insetPadding: EdgeInsets.zero,
        backgroundColor: Colors.transparent,
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0.sp),
            child: Container(
              decoration: BoxDecoration(
                color: popupBgColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 25.0.sp),
                      child: const StyledText(
                        '본인인증',
                        fontSize: 20,
                        lineHeight: 20,
                        fontWeight: 500,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 12.0.sp),
                      child: const StyledText(
                        '안전한 챌린지 참여를 위해\n본인 인증이 필요해요',
                        fontSize: 16,
                        lineHeight: 24,
                        fontWeight: 500,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 39.0.sp),
                      child: Row(
                        children: [
                          Expanded(
                            child: GazagoButton(
                              onTap: () {
                                Get.back();
                              },
                              buttonText: '닫기',
                              textColor: Colors.white,
                              buttonColor: popupBgColor,
                            ),
                          ),
                          SizedBox(
                            width: 9.sp,
                          ),
                          Expanded(
                            child: GazagoButton(
                              onTap: () => moveToVerification(),
                              buttonText: '확인',
                              buttonColor: skyBlueColor,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

void showChallengeItemBuyNeedVerificationAlert() {
  Get.dialog(
    barrierColor: Colors.transparent,
    PopScope(
      canPop: false,
      child: Dialog(
        insetPadding: EdgeInsets.zero,
        backgroundColor: subBg01Color.withOpacity(0.8),
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0.sp),
            child: Container(
              decoration: BoxDecoration(
                color: popupBgColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 25.0.sp),
                      child: const StyledText(
                        '본인인증',
                        fontSize: 20,
                        lineHeight: 20,
                        fontWeight: 500,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 12.0.sp),
                      child: const StyledText(
                        '안전한 챌린지 참여를 위해\n챌린지 아이템 구매시\n본인 인증이 필요해요',
                        fontSize: 16,
                        lineHeight: 24,
                        fontWeight: 500,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 39.0.sp),
                      child: Row(
                        children: [
                          Expanded(
                            child: GazagoButton(
                              onTap: () {
                                Get.back();
                              },
                              buttonText: '닫기',
                              textColor: Colors.white,
                              buttonColor: popupBgColor,
                            ),
                          ),
                          SizedBox(
                            width: 9.sp,
                          ),
                          Expanded(
                            child: GazagoButton(
                              onTap: () => moveToVerification(),
                              buttonText: '확인',
                              buttonColor: skyBlueColor,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

void joinChallengePopup(ChallengesDetailController controller) async {
  await Get.bottomSheet(
    isDismissible: false,
    isScrollControlled: true,
    enableDrag: false,
    PopScope(
      canPop: false,
      child: GestureDetector(
        onTap: () => FocusScope.of(Get.context!).requestFocus(FocusNode()),
        child: Container(
          decoration: BoxDecoration(
            color: popupBgColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12.sp),
              topRight: Radius.circular(12.sp),
            ),
          ),
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 35.sp, bottom: 28.sp),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 19.0.sp),
                        child: StyledText(
                          controller.isShortTokenBalance.value ? '잔액이 부족합니다.' : '챌린지에 참가하시겠습니까?',
                          color: controller.isShortTokenBalance.value ? dangerColor : Colors.white,
                          fontSize: 20,
                          lineHeight: 20,
                          letterSpacing: -.1,
                          fontWeight: 600,
                        ),
                      ),
                      Text.rich(
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 30.sp,
                          height: 30.sp / 30.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                        TextSpan(
                          text: formatDecimalPlaces(controller.challengeDetails.value.entryFee!.toDouble(), 0),
                          children: const [
                            TextSpan(text: 'TIK', style: TextStyle(fontWeight: FontWeight.w400)),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 25.0.sp),
                        child: Divider(
                          color: const Color(0xFF494B56),
                          thickness: 2,
                          height: 2.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20.sp, right: 20.sp, bottom: 20.sp),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          StyledText(
                            '잔액',
                            fontSize: 18,
                            fontWeight: 500,
                            letterSpacing: -.1,
                            color: controller.isShortTokenBalance.value ? dangerColor : Colors.white,
                          ),
                          Row(
                            children: [
                              StyledText(
                                formatDecimalPlaces(double.parse(controller.walletMasterController.tik.value.uiAmountString!), 0),
                                fontSize: 20,
                                fontWeight: 700,
                                letterSpacing: -.1,
                                color: controller.isShortTokenBalance.value ? dangerColor : Colors.white,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 4.0.sp),
                                child: StyledText(
                                  'TIK',
                                  fontSize: 20,
                                  fontWeight: 400,
                                  letterSpacing: -.1,
                                  color: controller.isShortTokenBalance.value ? dangerColor : Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 44.sp, bottom: 27.0.sp),
                        child: !controller.isShortTokenBalance.value
                            ? StyledText(
                                '· 참가비는 납부 후 취소 및 환불이 불가합니다.',
                                fontSize: 14,
                                color: controller.isShortTokenBalance.value ? dangerColor : skyBlueColor,
                              )
                            : Container(),
                      ),
                      Row(
                        children: [
                          if (!controller.isShortTokenBalance.value)
                            Expanded(
                              child: GazagoButton(
                                onTap: () => controller.onFetchJoinChallenge(),
                                buttonText: '참가하기',
                                textColor: Colors.white,
                                buttonColor: popupBgColor,
                              ),
                            ),
                          if (!controller.isShortTokenBalance.value)
                            SizedBox(
                              width: 9.sp,
                            ),
                          Expanded(
                            child: GazagoButton(
                              buttonText: '무료 참여',
                              onTap: () {
                                shareCrewChallengeKakaoLinkDialog(controller);
                              },
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 8.0.sp),
                        child: GazagoButton(
                          onTap: () => Get.back(),
                          buttonText: '취소',
                          textColor: Colors.white,
                          buttonColor: popupBgColor,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

void showChallengeLandingPopup(ChallengesDetailController controller, ChallengeLandingModel landingInfo) {
  Get.dialog(
    barrierColor: Colors.transparent,
    PopScope(
      canPop: false,
      child: Dialog(
        insetPadding: EdgeInsets.zero,
        backgroundColor: subBg01Color.withOpacity(0.8),
        child: Center(
            child: Padding(
          padding: EdgeInsets.all(35.0.sp),
          child: Container(
            decoration: BoxDecoration(
              color: popupBgColor,
              borderRadius: BorderRadius.all(
                Radius.circular(12.5.sp),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.5.sp),
                    topRight: Radius.circular(12.5.sp),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: landingInfo.imageUrl!,
                    fit: BoxFit.fitWidth,
                    placeholder: (context, url) => const Center(child: SizedBox.square(dimension: 40, child: CircularProgressIndicator(color:skyBlueColor))),
                    errorWidget: (context, url, error) => const Center(child: SizedBox.square(dimension: 40, child: CircularProgressIndicator(color:skyBlueColor))),
                    httpHeaders: imageNetworkHeader,
                  ),
                ),
                Row(
                  children: [
                    InkWell(
                      onTap: () => Get.back(),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(12.5.sp),
                          ),
                          color: const Color(0xFF2E3038),
                        ),
                        width: 140.sp,
                        height: 60.sp,
                        child: const Center(
                          child: StyledText(
                            '닫기',
                            fontSize: 18,
                            fontWeight: 500,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 1,
                      color: skyBlueColor,
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Get.back();
                          controller.onClickChallengeLandingPage(landingInfo);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(12.5.sp),
                            ),
                            color: const Color(0xFF2E3038),
                          ),
                          height: 60.sp,
                          child: Center(
                            child: StyledText(
                              landingInfo.label!,
                              fontSize: 18,
                              fontWeight: 500,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        )),
      ),
    ),
  );
}

void showModalWebview(controller, context, {String? title, String linkUrl = ''}) {
  InAppWebViewController? inAppWebViewController;

  showCupertinoModalBottomSheet(
    isDismissible: true,
    enableDrag: false,
    context: context,
    builder: (builder) {
      return Material(
        child: Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
            ),
            child: CupertinoPageScaffold(
              backgroundColor: Colors.transparent,
              navigationBar: CupertinoNavigationBar(
                backgroundColor: popupBgColor,
                leading: InkWell(
                  child: const Icon(Icons.close, color: Colors.white),
                  onTap: () {
                    Get.back();
                  },
                ),
                trailing: InkWell(
                  child: const Icon(Icons.refresh, color: Colors.white),
                  onTap: () {
                    // webViewController.webViewKey.currentState?.reloadWebView();
                    if (inAppWebViewController != null) {
                      inAppWebViewController!.reload();
                    }
                  },
                ),
                middle: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (title != null)
                        StyledText(
                          title!,
                          letterSpacing: -.1,
                          fontWeight: 600,
                          fontSize: 12,
                          lineHeight: 16,
                          overflowEllipsis: true,
                        ),
                      StyledText(
                        linkUrl,
                        letterSpacing: -.1,
                        color: lightGrayColor,
                        fontWeight: 500,
                        fontSize: 10,
                        lineHeight: 14,
                        overflowEllipsis: true,
                      ),
                    ],
                  ),
                ),
              ),
              child: Container(
                color: Colors.white,
                child: InAppWebView(
                  key: controller.webViewKey,
                  gestureRecognizers: Set()..add(Factory<VerticalDragGestureRecognizer>(() => VerticalDragGestureRecognizer())),
                  initialUrlRequest: URLRequest(url: WebUri(linkUrl)),
                  onWebViewCreated: (InAppWebViewController webviewController) {
                    inAppWebViewController = webviewController;
                  },
                  onProgressChanged: (InAppWebViewController webviewController, int progress) {
                    // setState(() {
                    //   this.progress = progress / 100;
                    // });
                  },
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}

void showModalNoticeWebview({String? title, String linkUrl = ''}) {
  GlobalKey webViewKey = GlobalKey();
  Get.bottomSheet(
    isDismissible: false,
    ignoreSafeArea: false,
    enableDrag: false,
    isScrollControlled: true,
    PopScope(
      canPop: false,
      child: Scaffold(
        body: SafeArea(
          top: true,
          child: InAppWebView(
            key: webViewKey,
            initialUrlRequest: URLRequest(url: WebUri(linkUrl)),
            initialSettings: InAppWebViewSettings(
              disableContextMenu: true,
              javaScriptEnabled: true,
            ),
            onLoadResourceWithCustomScheme: (controller, url) async {
              await controller.stopLoading();
              return null;
            },
            onWebViewCreated: (controller) {
              // register a JavaScript handler with name "myHandlerName"
            },
          ),
        ),
      ),
    ),
  );
}

void errorBottomSheet(String errorMsg) {
  showAlert(
    contentWidget: Padding(
      padding: EdgeInsets.only(bottom: 35.0.sp, top: 10.sp),
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

void showNeedVerificationExchangeAlert() {
  showAlert(
    title: '본인인증이 필요합니다.',
    contentText: '안전한 거래를 위해서는 본인인증이 필요하여\n인증페이지로 이동합니다.',
    actions: [
      Expanded(
        child: GazagoButton(
          onTap: () => moveToVerification(),
          buttonText: '확인',
          buttonColor: skyBlueColor,
        ),
      ),
    ],
  );
}

void showFourteenUnderUserAlert() {
  showAlert(
    contentWidget: Padding(
      padding: EdgeInsets.only(top: 20.0.sp, bottom: 40.sp),
      child: const Column(
        children: [
          StyledText(
            '14세 미만 사용자는 본인 인증 서비스를\n이용할 수 없습니다.',
            fontSize: 20,
            lineHeight: 28,
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

void showMinimumSendStikAmountAlert() {
  showAlert(
    contentWidget: Padding(
      padding: EdgeInsets.only(top: 20.0.sp, bottom: 40.sp),
      child: Column(
        children: [
          iconCircleSkyBlueCheck,
          Padding(
            padding: EdgeInsets.only(top: 20.0.sp),
            child: const StyledText(
              '최소 5STIK 이상 보낼 수 있습니다.',
              fontSize: 20,
              lineHeight: 28,
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
          },
          buttonText: '확인',
          buttonColor: skyBlueColor,
        ),
      ),
    ],
  );
}

void showRefetchGetSpendingWalletAlert() {
  WalletMasterController walletMasterController = Get.isRegistered<WalletMasterController>() ? Get.find<WalletMasterController>() : Get.put(WalletMasterController());
  showAlert(
    allowMultipleBottomSheet: true,
    contentWidget: Padding(
      padding: EdgeInsets.only(top: 20.0.sp, bottom: 40.sp),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 20.0.sp),
            child: const StyledText(
              '지갑 정보를 불러오지 못했습니다.\n확인을 누르시면 재조회를 시도합니다.',
              fontSize: 20,
              lineHeight: 28,
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
            walletMasterController.getSpendingWalletBalances();
          },
          buttonText: '확인',
          buttonColor: skyBlueColor,
        ),
      ),
    ],
  );
}

void showFailureGetSpendingWalletAlert() {
  WalletMasterController walletMasterController = Get.isRegistered<WalletMasterController>() ? Get.find<WalletMasterController>() : Get.put(WalletMasterController());
  showAlert(
    allowMultipleBottomSheet: true,
    contentWidget: Padding(
      padding: EdgeInsets.only(top: 0.0.sp, bottom: 32.sp),
      child: Column(
        children: [

          iconPopupExclamationMark,
          Padding(
            padding: EdgeInsets.only(top: 16.0.sp),
            child: Text(
              '잠시 후 다시 시도해주세요',
              style: AppTextStyleData.regular().koHeadingMediumSm.copyWith(
                  color: AppColorData.regular().colorTextPrimary
              )
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20.0.sp),
            child: Text(
              '일시적인 오류로 지갑 정보를 불러 올 수 없습니다.',
                style: AppTextStyleData.regular().koBodyMediumLg.copyWith(
                    color: AppColorData.regular().colorTextPrimary
                )
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
          },
          buttonText: '확인',
          buttonColor: skyBlueColor,
        ),
      ),
    ],
  );
}

void showIOSAdPermissionAlert(DailyBenefitController controller) {
  Get.dialog(
    barrierColor: Colors.transparent,
    useSafeArea: false,
    WillPopScope(
      onWillPop: () async => false,
      child: Dialog(
        insetPadding: EdgeInsets.zero,
        backgroundColor: subBg01Color.withOpacity(.8),
        child: Center(
            child: Container(
              width: 316.sp,
              decoration: BoxDecoration(
                color: popupBgColor,
                borderRadius: BorderRadius.all(
                  Radius.circular(12.5.sp),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(left: 20.0.sp, right: 20.sp, top: 36.0.sp, bottom: 24.sp),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 16.sp),
                      child: Text(
                        '광고 시청을 위해\n앱 추적 요청을 허용해주세요.',
                        style: AppTextStyleData.regular().koHeadingSemiboldSm.copyWith(
                          color: AppColorData.regular().colorTextPrimary,
                        ),
                          textAlign: TextAlign.center,
                      ),
                    ),
                    Image.asset(
                      'assets/images/activity/img_ios_ad_permission.png',
                      fit: BoxFit.fitWidth,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 16.0.sp),
                      child: Text(
                          '그림과 같이 설정 → 가자고 앱에서\n추적을 허용해 주세요.',
                              style: AppTextStyleData.regular().koBodyMediumMd.copyWith(
                                color: AppColorData.regular().colorTextSecondary,
                              ),
                        textAlign: TextAlign.center,
                      )
                    ),
                    Padding(
                        padding: EdgeInsets.only(top: 8.0.sp, bottom: 24.sp),
                        child: InkWell(
                          onTap: () {
                            Get.toNamed(Routes.webView, arguments: {'linkUrl': 'https://eztechfin.notion.site/883801b0ca0e465d976f9a0062d080df?pvs=4'});
                          },
                          child: Text(
                            '추적 허용이 보이지 않는다면?',
                            style: AppTextStyleData.regular().koBodyMediumMd.copyWith(
                              color: AppColorData.regular().colorTextTertiary,
                              decoration: TextDecoration.underline,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        )
                    ),
                    GazagoButton(
                      onTap: () {
                        controller.moveAppSettings();
                      },
                      buttonText: '확인',
                      buttonColor: skyBlueColor,
                    ),
                  ],
                ),
              ),
            )),
      ),
    ),
  );
}

void showIOSDeniedAdPermissionAlert(DailyBenefitController controller) {
  Get.dialog(
    barrierColor: Colors.transparent,
    useSafeArea: false,
    WillPopScope(
      onWillPop: () async => false,
      child: Dialog(
        insetPadding: EdgeInsets.zero,
        backgroundColor: subBg01Color.withOpacity(.8),
        child: Center(
            child: Container(
              width: 316.sp,
              decoration: BoxDecoration(
                color: popupBgColor,
                borderRadius: BorderRadius.all(
                  Radius.circular(12.5.sp),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(left: 20.0.sp, right: 20.sp, top: 36.0.sp, bottom: 24.sp),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 16.sp),
                      child: Text(
                        '광고 시청을 위해\n앱 추적 요청을 허용해주세요.',
                        style: AppTextStyleData.regular().koHeadingSemiboldSm.copyWith(
                          color: AppColorData.regular().colorTextPrimary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Image.asset(
                      'assets/images/activity/img_ios_ad_denied_permission.png',
                      fit: BoxFit.fitWidth,
                    ),
                    Padding(
                        padding: EdgeInsets.only(top: 16.0.sp),
                        child: Text(
                          '그림과 같이 설정 → 개인정보 보호 및 보안 →\n추적 페이지에서 가자고 앱 추적을 허용해 주세요.',
                          style: AppTextStyleData.regular().koBodyMediumMd.copyWith(
                            color: AppColorData.regular().colorTextSecondary,
                          ),
                          textAlign: TextAlign.center,
                        )
                    ),
                    Padding(
                        padding: EdgeInsets.only(top: 8.0.sp, bottom: 24.sp),
                        child: InkWell(
                          onTap: () {
                            Get.toNamed(Routes.webView, arguments: {'linkUrl': 'https://eztechfin.notion.site/883801b0ca0e465d976f9a0062d080df?pvs=4'});
                          },
                          child: Text(
                            '추적 허용이 보이지 않는다면?',
                            style: AppTextStyleData.regular().koBodyMediumMd.copyWith(
                              color: AppColorData.regular().colorTextTertiary,
                              decoration: TextDecoration.underline,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        )
                    ),
                    GazagoButton(
                      onTap: () {
                        controller.moveAppSettings();
                        // Get.back();
                      },
                      buttonText: '확인',
                      buttonColor: skyBlueColor,
                    ),
                  ],
                ),
              ),
            )),
      ),
    ),
  );
}

void showNotGpsSensor() {
  ActivityController controller = Get.isRegistered<ActivityController>() ? Get.find<ActivityController>() : Get.put(ActivityController());
  Get.dialog(WillPopScope(
    onWillPop: () async => false,
    child: Dialog(
      alignment: Alignment.center,
      insetPadding: EdgeInsets.zero,
      shadowColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      child: Padding(
        padding: EdgeInsets.all(32.0.sp),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                color: popupBgColor,
                borderRadius: BorderRadius.circular(AppDoubleData.regular().numberRadius20),
              ),
              child: Padding(
                padding: EdgeInsets.only(left: 20.0.sp, right: 20.sp, bottom: 32.sp, top: 36.sp),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    StyledText(
                      'GPS 미수신 시 이렇게 해보세요',
                      fontWeight: 600,
                      fontSize: 20,
                      lineHeight: 28,
                      textAlign: TextAlign.center,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 8.sp, bottom: 28.sp),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: controller.gpsNoticeList
                            .asMap()
                            .entries
                            .map((e) => Padding(
                                  padding: EdgeInsets.only(top: 2.0.sp),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      StyledText(
                                        '${e.key + 1}.',
                                        fontSize: 16,
                                        lineHeight: 22,
                                        fontWeight: 500,
                                      ),
                                      Expanded(
                                        child: StyledText(
                                          ' ${e.value}',
                                          fontSize: 16,
                                          lineHeight: 22,
                                          fontWeight: 500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 0.0.sp),
                      child: GazagoButton(
                        buttonText: '확인',
                        onTap: () {
                          Get.back();
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  ));
}

void showNotGpsSensorAlert(ActivityController controller) {
  showAlert(
    isScrollControlled: true,
    contentWidget: Padding(
      padding: EdgeInsets.only(bottom: 32.0.sp),
      child: Column(
        children: [
          iconPopupExclamationMark,
          Padding(
            padding: EdgeInsets.only(top: 20.0.sp, bottom: 20.0.sp),
            child: StyledText(
              'GPS 수신이 원활하지 않아\n운동을 기록하기 어려워요',
              fontWeight: 500,
              fontSize: 20,
              lineHeight: 28,
              textAlign: TextAlign.center,
            ),
          ),
          StyledText(
            '1.\n절전모드 등 휴대폰 설정에 따라 GPS 수신이 \n원활하지 않을 수 있어요',
            fontWeight: 500,
            fontSize: 16,
            lineHeight: 22,
            textAlign: TextAlign.center,
          ),
          Padding(
            padding: EdgeInsets.only(top: 12.0.sp),
            child: StyledText(
              '2.\n넓게 트인 야외로 이동해보세요.',
              fontWeight: 500,
              fontSize: 16,
              lineHeight: 22,
              textAlign: TextAlign.center, 
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 12.0.sp),
            child: StyledText(
              '3.\n지속적으로 GPS 수신이 원활하지 않을 경우\n휴대폰을 껐다가 켠 다음 다시 시도해주세요.',
              fontWeight: 500,
              fontSize: 16,
              lineHeight: 22,
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
            controller.isShowGpsAccuracyAlert.value = true;
            Get.back();
          },
          buttonText: '확인',
          buttonColor: skyBlueColor,
        ),
      ),
    ],
  );
}

void requireShowEmailAlert() {
  showAlert(
    allowMultipleBottomSheet: true,
    title: '이메일을 확인할 수 없습니다.',
    contentWidget: Padding(
      padding: EdgeInsets.only(top: 20.0.sp, bottom: 32.sp),
      child: const StyledText(
        '설정 > [사용자 이름] > iCloud >\n나의 이메일 가리기에서 가자고 앱을 검색하여\n전달 받을 이메일 주소를 활성화한 후\n 다시 시도해 주세요.',
        fontSize: 16,
        lineHeight: 23,
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

void showSendNftToGoWalletAlert(WalletOnChainNftDetailController controller) {
  showAlert(
    contentWidget: Center(
      child: Column(
        children: [
          Text(
            'GO 지갑으로 보낼까요?',
            style: AppTextStyleData.regular().koHeadingMediumSm.copyWith(
                  color: AppColorData.regular().colorTextPrimary,
                ),
            textAlign: TextAlign.center,
          ),
          Padding(
            padding: EdgeInsets.only(top: 8.sp),
            child: Text(
              removeSerialNumberString(controller.nftDetail.value!.name!),
              style: AppTextStyleData.regular().koBodyMediumXl.copyWith(
                    color: AppColorData.regular().colorTextPrimary,
                  ),
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 12.sp),
            padding: EdgeInsets.symmetric(vertical: 4.sp, horizontal: 8.sp),
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColorData.regular().colorBorderTertiary,
              ),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Text(
              extractSerialNumberString(controller.nftDetail.value!.name!),
              style: AppTextStyleData.regular().koBodySemiboldMd.copyWith(
                    color: AppColorData.regular().colorTextTertiary,
                  ),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20.sp),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '  ·  ',
                  style: AppTextStyleData.regular().koBodyMediumMd.copyWith(
                        color: AppColorData.regular().colorTextSecondary,
                      ),
                ),
                Expanded(
                  child: Text(
                    '전송 수수료는 gazaGO에서 부담해요.',
                    style: AppTextStyleData.regular().koBodyMediumMd.copyWith(
                          color: AppColorData.regular().colorTextSecondary,
                        ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 8.sp, bottom: 32.sp),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '  ·  ',
                  style: AppTextStyleData.regular().koBodyMediumMd.copyWith(
                        color: AppColorData.regular().colorTextSecondary,
                      ),
                ),
                Expanded(
                  child: Text(
                    'GO 지갑으로 이동한 아이템은 gazaGO에서\n사용할 수 있으며, Staika 지갑에서 보여지지 않습니다.',
                    style: AppTextStyleData.regular().koBodyMediumMd.copyWith(
                          color: AppColorData.regular().colorTextSecondary,
                        ),
                  ),
                ),
              ],
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
          },
          buttonText: '취소',
          textColor: AppColorData.regular().colorTextPrimary,
          buttonColor: AppColorData.regular().colorBgInteractiveSecondary,
        ),
      ),
      SizedBox(
        width: 9.sp,
      ),
      Expanded(
        child: GazagoButton(
          onTap: () {
            controller.requestSendNft();
          },
          buttonText: '보내기',
          buttonColor: AppColorData.regular().colorBgInteractivePrimary,
        ),
      ),
    ],
  );
}

void showItemIsEquippedAlert() {
  showAlert(
    contentWidget: Center(
      child: Column(
        children: [
          Text(
            '장착중인 아이템은\nStaika지갑으로 보낼 수 없어요.',
            style: AppTextStyleData.regular().koHeadingSemiboldSm.copyWith(
                  color: AppColorData.regular().colorTextPrimary,
                ),
            textAlign: TextAlign.center,
          ),
          Padding(
            padding: EdgeInsets.only(top: 8.sp, bottom: 28.sp),
            child: Text(
              '다른 아이템으로 장착 후 다시 시도해주세요.',
              style: AppTextStyleData.regular().koBodyMediumLg.copyWith(
                    color: AppColorData.regular().colorTextPrimary,
                  ),
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
          },
          buttonText: '취소',
          textColor: AppColorData.regular().colorTextPrimary,
          buttonColor: AppColorData.regular().colorBgInteractiveSecondary,
        ),
      ),
      SizedBox(
        width: 9.sp,
      ),
      Expanded(
        child: GazagoButton(
          onTap: () {
            Get.until((route) => route.isFirst);
            Get.find<HomeMenuController>().selectMenu(1);
            Get.find<InventoryHomeController>().tabController.animateTo(0);
          },
          buttonText: '내 장비 가기',
          buttonColor: AppColorData.regular().colorBgInteractivePrimary,
        ),
      ),
    ],
  );
}

void showNotCompatibleItemAlert() {
  showAlert(
    contentWidget: Center(
      child: Column(
        children: [
          Text(
            'gazaGO에서 사용할 수 없는\n아이템이에요',
            style: AppTextStyleData.regular().koHeadingSemiboldSm.copyWith(
                  color: AppColorData.regular().colorTextPrimary,
                ),
            textAlign: TextAlign.center,
          ),
          Padding(
            padding: EdgeInsets.only(top: 8.sp, bottom: 28.sp),
            child: Text(
              '아이템을 다시 확인해주세요.',
              style: AppTextStyleData.regular().koBodyMediumLg.copyWith(
                    color: AppColorData.regular().colorTextPrimary,
                  ),
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
          },
          buttonText: '취소',
          textColor: AppColorData.regular().colorTextPrimary,
          buttonColor: AppColorData.regular().colorBgInteractiveSecondary,
        ),
      ),
      SizedBox(
        width: 9.sp,
      ),
      Expanded(
        child: GazagoButton(
          onTap: () {
            Get.until((route) => Get.currentRoute == Routes.walletNftList);
          },
          buttonText: '다시 고르기',
          buttonColor: AppColorData.regular().colorBgInteractivePrimary,
        ),
      ),
    ],
  );
}

void showNftTransferSuccess({required bool isOnChain}) {
  showAlert(
    allowMultipleBottomSheet: true,
    contentWidget: Center(
      child: Column(
        children: [
          Lottie.asset(
            'assets/lottie/purchase_success.json',
            width: 40,
            height: 40,
            repeat: false,
          ),
          Padding(
            padding: EdgeInsets.only(top: 16.sp),
            child: Text(
              '보내기 신청 완료',
              style: AppTextStyleData.regular().koHeadingMediumSm.copyWith(
                    color: AppColorData.regular().colorTextPrimary,
                  ),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20.sp, bottom: 32.sp),
            child: Text(
              isOnChain ? '보낸 아이템은 내 장비에서 장착할 수 있어요.' : '잠시 후 Staika 지갑 > NFT 목록 에서 볼 수 있어요.',
              style: AppTextStyleData.regular().koBodyMediumLg.copyWith(
                    color: AppColorData.regular().colorTextPrimary,
                  ),
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
            Get.until((route) => Get.currentRoute == Routes.walletNftList || Get.currentRoute == Routes.home);
            Get.bus.fire(RefreshNftListEvent());
          },
          buttonText: '확인',
          buttonColor: AppColorData.regular().colorBgInteractivePrimary,
        ),
      ),
    ],
  );
}

void showBlockchainNetworkErrorAlert() {
  showAlert(
    allowMultipleBottomSheet: true,
    contentWidget: Column(
      children: [
        iconError,
        Padding(
          padding: EdgeInsets.only(top: 16.sp),
          child: Text(
            '블록체인 네트워크 문제 발생',
            style: AppTextStyleData.regular().koHeadingMediumSm.copyWith(
                  color: AppColorData.regular().colorTextPrimary,
                ),
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 20.sp, bottom: 32.sp),
          child: Text(
            '잠시 후 다시 시도해주세요.',
            style: AppTextStyleData.regular().koBodyMediumLg.copyWith(
                  color: AppColorData.regular().colorTextPrimary,
                ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    ),
    actions: [
      Expanded(
        child: GazagoButton(
          onTap: () {
            Get.back();
          },
          buttonText: '확인',
          buttonColor: AppColorData.regular().colorBgInteractivePrimary,
        ),
      ),
    ],
  );
}

void showNotEnoughBalanceErrorAlert() {
  showAlert(
    allowMultipleBottomSheet: true,
    contentWidget: Column(
      children: [
        Text(
          '수수료를 확인해 주세요',
          style: AppTextStyleData.regular().koHeadingMediumSm.copyWith(
                color: AppColorData.regular().colorTextPrimary,
              ),
          textAlign: TextAlign.center,
        ),
        Padding(
          padding: EdgeInsets.only(top: 20.sp, bottom: 32.sp),
          child: Text(
            'NFT 보내기에 필요한 수수료를 확인해 주세요.',
            style: AppTextStyleData.regular().koBodyMediumLg.copyWith(
                  color: AppColorData.regular().colorTextPrimary,
                ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    ),
    actions: [
      Expanded(
        child: GazagoButton(
          onTap: () {
            Get.back();
          },
          buttonText: '확인',
          buttonColor: AppColorData.regular().colorBgInteractivePrimary,
        ),
      ),
    ],
  );
}

void showSendToStaikaConfirmAlert(InventoryController controller, InventoryItemModel item) {
  showAlert(
    title: 'Staika 지갑으로 보낼까요?',
    isScrollControlled: true,
    contentWidget: Column(
      children: [
        Padding(
          padding: EdgeInsets.only(
            top: AppDoubleData.regular().numberSpacing8.sp,
            bottom: AppDoubleData.regular().numberSpacing12.sp,
          ),
          child: Text(
            item.itemName,
            style: AppTextStyleData.regular().koBodyMediumXl.copyWith(
                  color: AppColorData.regular().colorTextPrimary,
                ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(bottom: 20.sp),
          padding: EdgeInsets.symmetric(vertical: 4.sp, horizontal: 8.sp),
          decoration: BoxDecoration(
            border: Border.all(
              color: AppColorData.regular().colorBorderTertiary,
            ),
            borderRadius: BorderRadius.circular(100),
          ),
          child: Text(
            '#${item.serialNumber ?? ' '}',
            style: AppTextStyleData.regular().koBodySemiboldMd.copyWith(
                  color: AppColorData.regular().colorTextTertiary,
                ),
            textAlign: TextAlign.center,
          ),
        ),
        if (item.itemStat!.goProfit! > 0)
          Padding(
            padding: EdgeInsets.only(top: AppDoubleData.regular().numberSpacing12.sp),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'GO 적립량',
                  style: AppTextStyleData.regular().koBodyMediumXl.copyWith(
                        color: AppColorData.regular().colorTextPrimary,
                      ),
                ),
                Text(
                  formatDecimalPlaces(item.itemStat!.goProfit!, 0),
                  style: AppTextStyleData.regular().koBodyMediumXl.copyWith(
                        color: AppColorData.regular().colorTextPrimary,
                      ),
                ),
              ],
            ),
          ),
        if (item.itemStat!.durability! > 0)
          Padding(
            padding: EdgeInsets.only(top: AppDoubleData.regular().numberSpacing12.sp),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '내구도 저항',
                  style: AppTextStyleData.regular().koBodyMediumXl.copyWith(
                        color: AppColorData.regular().colorTextPrimary,
                      ),
                ),
                Text(
                  formatDecimalPlaces(item.itemStat!.durability!, 0),
                  style: AppTextStyleData.regular().koBodyMediumXl.copyWith(
                        color: AppColorData.regular().colorTextPrimary,
                      ),
                ),
              ],
            ),
          ),
        if (item.itemStat!.stamina! > 0)
          Padding(
            padding: EdgeInsets.only(top: AppDoubleData.regular().numberSpacing12.sp),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '체력 저항',
                  style: AppTextStyleData.regular().koBodyMediumXl.copyWith(
                        color: AppColorData.regular().colorTextPrimary,
                      ),
                ),
                Text(
                  formatDecimalPlaces(item.itemStat!.stamina!, 0),
                  style: AppTextStyleData.regular().koBodyMediumXl.copyWith(
                        color: AppColorData.regular().colorTextPrimary,
                      ),
                ),
              ],
            ),
          ),
        if (item.itemStat!.luck! > 0)
          Padding(
            padding: EdgeInsets.only(top: AppDoubleData.regular().numberSpacing12.sp),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '행운',
                  style: AppTextStyleData.regular().koBodyMediumXl.copyWith(
                        color: AppColorData.regular().colorTextPrimary,
                      ),
                ),
                Text(
                  formatDecimalPlaces(item.itemStat!.luck!, 0),
                  style: AppTextStyleData.regular().koBodyMediumXl.copyWith(
                        color: AppColorData.regular().colorTextPrimary,
                      ),
                ),
              ],
            ),
          ),
        if (item.itemCategory == 'SHOES')
          Padding(
            padding: EdgeInsets.only(top: AppDoubleData.regular().numberSpacing12.sp),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '현재 내구도',
                  style: AppTextStyleData.regular().koBodyMediumXl.copyWith(
                        color: AppColorData.regular().colorTextPrimary,
                      ),
                ),
                Text(
                  formatDecimalPlaces(item.durability!, 2),
                  style: AppTextStyleData.regular().koBodyMediumXl.copyWith(
                        color: AppColorData.regular().colorTextPrimary,
                      ),
                ),
              ],
            ),
          ),
        Padding(
          padding: EdgeInsets.only(top: AppDoubleData.regular().numberSpacing12.sp),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '전송 수수료',
                style: AppTextStyleData.regular().koBodyMediumXl.copyWith(
                      color: AppColorData.regular().colorTextPrimary,
                    ),
              ),
              Text(
                '0 TIK',
                style: AppTextStyleData.regular().koBodyMediumXl.copyWith(
                      color: AppColorData.regular().colorTextPrimary,
                    ),
              ),
            ],
          ),
        ),
        Divider(
          height: 40.sp,
          thickness: 2.0.sp,
          color: AppColorData.regular().colorBorderPrimary,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '  ·  ',
              style: AppTextStyleData.regular().koBodyMediumMd.copyWith(
                    color: AppColorData.regular().colorTextSecondary,
                  ),
            ),
            Expanded(
              child: Text(
                '전송 수수료는 gazaGO에서 부담해요.',
                style: AppTextStyleData.regular().koBodyMediumMd.copyWith(
                      color: AppColorData.regular().colorTextSecondary,
                    ),
              ),
            ),
          ],
        ),
        SizedBox(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.only(top: 8.sp, bottom: 32.sp),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '  ·  ',
                  style: AppTextStyleData.regular().koBodyMediumMd.copyWith(
                        color: AppColorData.regular().colorTextSecondary,
                      ),
                ),
                Expanded(
                  child: Text(
                    'Staika 지갑으로 이동한 아이템은 gazaGO에서 사용할 수 없습니다.',
                    style: AppTextStyleData.regular().koBodyMediumMd.copyWith(
                          color: AppColorData.regular().colorTextSecondary,
                        ),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    ),
    actions: [
      Expanded(
        child: GazagoButton(
          onTap: () {
            Get.back();
          },
          buttonText: '취소',
          textColor: AppColorData.regular().colorTextPrimary,
          buttonColor: AppColorData.regular().colorBgInteractiveSecondary,
        ),
      ),
      SizedBox(
        width: 9.sp,
      ),
      Expanded(
        child: GazagoButton(
          onTap: () => {controller.sendNftToStaika(item)},
          buttonText: '보내기',
          buttonColor: AppColorData.regular().colorBgInteractivePrimary,
        ),
      ),
    ],
  );
}

void showConfirmCollectionRewardAlert(CollectionDetailController controller) {
  showAlert(
    isScrollControlled: true,
    title: '정말로 리워드를 받을까요?',
    contentWidget: Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 30.sp),
          child: controller.renderCollectionImage(controller.detailCollection.value.gatheringReward),
        ),
        Padding(
          padding: EdgeInsets.only(top: controller.detailCollection.value.gatheringReward.type == 'ITEM' || controller.detailCollection.value.gatheringReward.type == 'BADGE' ? 16.sp : 10.0.sp),
          child: Container(
              decoration: BoxDecoration(
                color: AppColorData.regular().colorBgPrimary,
                borderRadius: BorderRadius.all(
                  Radius.circular(AppDoubleData.regular().numberRadius8),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(left: 16.0.sp, right: 16.sp, top: 9.sp, bottom: 12.sp),
                child: Text(
                  controller.gatheringRewardName(controller.detailCollection.value.gatheringReward),
                  style: AppTextStyleData.regular().koBodyMediumLg.copyWith(
                        color: AppColorData.regular().colorTextPrimary,
                      ),
                ),
              )),
        ),
        Padding(
            padding: EdgeInsets.only(top: 16.sp, bottom: 32.sp),
            child: Text(
              '리워드를 받으면 컬렉션 재료는 모두 사라져요.',
              style: AppTextStyleData.regular().koBodyMediumMd.copyWith(
                    color: AppColorData.regular().colorTextSecondary,
                  ),
            )),
      ],
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
          buttonText: '리워드 받기',
          onTap: () async {
            Get.back();
            controller.getCollectionReward(controller.detailCollection.value.id);
          },
        ),
      ),
    ],
  );
}

void showGetCollectionRewardAlert(GatheringConditionModel responseData) {
  CollectionDetailController controller = Get.find();
  showAlert(
    isScrollControlled: true,
    title: '리워드 획득',
    contentWidget: Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 30.sp),
          child: controller.renderCollectionImage(responseData),
        ),
        Padding(
          padding: EdgeInsets.only(top: responseData.type == 'ITEM' || responseData.type == 'BADGE' ? 16.sp : 10.0.sp),
          child: Container(
              decoration: BoxDecoration(
                color: AppColorData.regular().colorBgPrimary,
                borderRadius: BorderRadius.all(
                  Radius.circular(AppDoubleData.regular().numberRadius8),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(left: 16.0.sp, right: 16.sp, top: 9.sp, bottom: 12.sp),
                child: Text(
                  controller.gatheringRewardName(responseData),
                  style: AppTextStyleData.regular().koBodyMediumLg.copyWith(
                        color: AppColorData.regular().colorTextPrimary,
                      ),
                ),
              )),
        ),
        Padding(
          padding: EdgeInsets.only(top: 16.sp, bottom: 32.sp),
          child: Text.rich(
            textAlign: TextAlign.center,
            style: AppTextStyleData.regular().koBodyMediumMd.copyWith(
                  color: AppColorData.regular().colorTextSecondary,
                ),
            TextSpan(
              children: responseData.type == 'BADGE' || responseData.type == 'ITEM'
                  ? [
                      TextSpan(text: '컬렉션 리워드는\n내 장비에서 확인할 수 있어요.'),
                    ]
                  : responseData.type == 'STIK'
                      ? [
                          TextSpan(text: '지갑 > GO지갑 > Staika', style: TextStyle(color: AppColorData.regular().colorTextBrand)),
                          TextSpan(text: ' 에서\n확인할 수 있어요.'),
                        ]
                      : [
                          TextSpan(text: '지갑 > GO지갑 > Taika', style: TextStyle(color: AppColorData.regular().colorTextBrand)),
                          TextSpan(text: ' 에서\n확인할 수 있어요.'),
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
            controller.confirmGetReward();
          },
        ),
      ),
    ],
  );
}

void showGetCollectionRewardErrorAlert() {
  showAlert(
    allowMultipleBottomSheet: true,
    title: '일시적인 오류가 발생했습니다',
    contentWidget: Padding(
      padding: EdgeInsets.only(top: 20.0.sp, bottom: 32.sp),
      child: Text(
        '잠시 후에 다시 시도해 주세요.',
        style: AppTextStyleData.regular().koBodyMediumLg.copyWith(
              color: AppColorData.regular().colorTextPrimary,
            ),
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

void showNotEnoughGatheringConditionErrorAlert() {
  showAlert(
    allowMultipleBottomSheet: true,
    title: '컬렉션 재료 확인 요청',
    contentWidget: Padding(
      padding: EdgeInsets.only(top: 20.0.sp, bottom: 32.sp),
      child: Text(
        '컬렉션 재료가 더 필요해요.',
        style: AppTextStyleData.regular().koBodyMediumLg.copyWith(
              color: AppColorData.regular().colorTextPrimary,
            ),
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




void showServiceInspectionNotice() {
  Get.dialog(
    barrierColor: Colors.transparent,
    useSafeArea: false,
    WillPopScope(
      onWillPop: () async => false,
      child: Dialog(
        insetPadding: EdgeInsets.zero,
        backgroundColor: subBg01Color.withOpacity(.8),
        child: Center(
            child: Container(
              width: 316.sp,
              decoration: BoxDecoration(
                color: popupBgColor,
                borderRadius: BorderRadius.all(
                  Radius.circular(12.5.sp),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(left: 20.0.sp, right: 20.sp, top: 36.0.sp, bottom: 36.sp),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 16.sp),
                      child: Text(
                        '서비스 점검중 입니다.',
                        style: AppTextStyleData.regular().koHeadingSemiboldSm.copyWith(
                          color: AppColorData.regular().colorTextPrimary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    StyledText(
                      '이용에 불편을 드려 죄송합니다.',
                      fontWeight: 500,
                      fontSize: 16,
                      lineHeight: 24,
                      letterSpacing: -.1,
                      textAlign: TextAlign.center,
                    ),

                  ],
                ),
              ),
            )),
      ),
    ),
  );
}