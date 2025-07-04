import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider_plus/carousel_slider_plus.dart';
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
import 'package:get/get.dart' hide Trans;
import 'package:get_event_bus/get_event_bus.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:easy_localization/easy_localization.dart';

void showRetryAlert(LoadingController controller) {
  showAlert(
    title: 'loading_error'.tr(),
    contentText: 'retry_error_message'.tr(),
    actions: [
      Expanded(
        child: GazagoButton(
          onTap: () => controller.handleRefreshApp(),
          buttonText: 'retry'.tr(),
          buttonColor: skyBlueColor,
        ),
      ),
    ],
  );
}

// void showShoeRepairSlider(InventoryController controller, int feeTikDurability, int itemId) {
//   showAlert(
//     title: 'shoe_durability_recharge'.tr(),
//     contentWidget: Obx(() {
//       return Column(
//         children: [
//           Padding(
//             padding: EdgeInsets.only(top: 12.0.sp),
//             child: StyledText(
//               'current_shoe_durability'.tr('${formatDecimalPlaces(itemId == controller.equippedShoe.value.id ? controller.equippedShoe.value.durability : controller.selectedItem.value.durability, 2)}'),
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
//                 StyledText(
//                   'recharge_cost'.tr(),
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
//           buttonText: 'cancel'.tr(),
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
//             buttonText: 'yes'.tr(),
//             buttonColor: skyBlueColor,
//           );
//         }),
//       ),
//     ],
//   );
// }

// void showRepairStatSlider(ActivityController controller, StatModel stat, int feeTikStamina, int feeTikDurability) {
//   showAlert(
//     title: stat.type == 'STAMINA' ? 'stamina_recharge_1'.tr() : 'shoe_durability_recharge'.tr(),
//     contentWidget: Obx(() {
//       return Column(
//         children: [
//           Padding(
//             padding: EdgeInsets.only(top: 12.0.sp),
//             child: stat.type == 'STAMINA'
//                 ? StyledText(
//                     'current_stamina'.tr('${stat.currentStat}'),
//                     fontSize: 16,
//                     lineHeight: 22,
//                     fontWeight: 500,
//                     color: deepGrayColor,
//                   )
//                 : StyledText(
//                     'current_shoe_durability_2'.tr('${formatDecimalPlaces(stat.currentStat, 2)}'),
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
//                   'recharge_cost_2'.tr('${stat.type == 'STAMINA' ? '충전 ' : '충전 '}'),
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
//           buttonText: 'cancel'.tr(),
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
//             buttonText: 'yes'.tr(),
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
    title: 'insufficient_balance'.tr(),
    contentText: 'insufficient_taika'.tr(),
    actions: [
      Expanded(
        child: GazagoButton(
          onTap: () => Get.back(),
          buttonText: 'confirm'.tr(),
          buttonColor: skyBlueColor,
        ),
      ),
    ],
  );
}

Future<void> showLocationAlert(ActivityController controller) async {
  await showAlert(
    title: 'notification'.tr(),
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
          text: 'accurate_record_location_permission'.tr(),
          children: [
            TextSpan(
                text: 'location_access'.tr(),
                style: TextStyle(color: skyBlueColor)),
            TextSpan(text: 'access_permission'.tr()),
          ],
        ),
      ),
    ),
    actions: [
      Expanded(
        child: GazagoButton(
          buttonText: 'confirm'.tr(),
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
    title: 'notification'.tr(),
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
          text: 'ad_permission'.tr(),
          children: [
            TextSpan(
                text: 'privacy_setting'.tr(),
                style: TextStyle(color: skyBlueColor)),
            TextSpan(text: 'gaza_go_permission'.tr()),
          ],
        ),
      ),
    ),
    actions: [
      Expanded(
        child: GazagoButton(
          buttonText: 'confirm'.tr(),
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
    title: 'notification'.tr(),
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
          text: 'accurate_record_location_permission'.tr(),
          children: [
            TextSpan(
                text: 'activity_access_permission'.tr(),
                style: TextStyle(color: skyBlueColor)),
            TextSpan(text: 'activity_access_permission_2'.tr()),
          ],
        ),
      ),
    ),
    actions: [
      Expanded(
        child: GazagoButton(
          buttonText: 'confirm'.tr(),
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
    title: 'notification'.tr(),
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
          text: 'activate_device_function'.tr(),
          children: [
            TextSpan(text: 'GPS', style: TextStyle(color: skyBlueColor)),
            TextSpan(text: 'activate_device_function_2'.tr()),
          ],
        ),
      ),
    ),
    actions: [
      Expanded(
        child: GazagoButton(
          buttonText: 'confirm'.tr(),
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
    title: 'notification'.tr(),
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
          text: 'abnormal_gps_activity'.tr(),
          children: [
            TextSpan(
                text: 'abnormal_gps_activity_2'.tr(),
                style: TextStyle(color: skyBlueColor)),
            TextSpan(text: 'abnormal_gps_activity_3'.tr()),
          ],
        ),
      ),
    ),
    actions: [
      Expanded(
        child: GazagoButton(
          buttonText: 'confirm'.tr(),
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
    title: 'notification'.tr(),
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
          text: 'profile_picture_permission'.tr(),
          children: [
            TextSpan(
                text: 'photo_access'.tr(),
                style: const TextStyle(color: skyBlueColor)),
            TextSpan(text: 'activity_access_permission_2'.tr()),
          ],
        ),
      ),
    ),
    actions: [
      Expanded(
        child: GazagoButton(
          buttonText: 'confirm'.tr(),
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
    title: 'exercise_ended'.tr(),
    contentText: 'only_current_record_saved'.tr(),
    actions: [
      Expanded(
        child: GazagoButton(
          onTap: () => Get.back(),
          buttonText: 'cancel'.tr(),
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
          buttonText: 'finished'.tr(),
          buttonColor: skyBlueColor,
        ),
      ),
    ],
  );
}

// void showEndExerciseAdAlert(ActivityController controller) {
//   showAlert(
//     title: 'activity_ended'.tr(),
//     contentText: 'only_current_record_saved'.tr(),
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
//                             : StyledText(
//                                 'insufficient_ads'.tr(),
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
//                               StyledText(
//                                 'watch_ad_get_more_go'.tr(),
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
//                 buttonText: 'activity_ended'.tr(),
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
//                       'cancel'.tr(),
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

void showBadgeAcquisitionAlert(
    String badgeImgUrl, ChallengeCourseModel selectedChallenge) {
  showAlert(
    isScrollControlled: true,
    title: 'challenge_badge_issued'.tr(),
    contentWidget: Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 30.sp, bottom: 30.sp),
          child: badgeImgUrl.contains('.svg')
              ? SvgPicture.network(
                  fit: BoxFit.contain,
                  badgeImgUrl,
                  width: 150.sp,
                  placeholderBuilder: (BuildContext context) => Container(
                      width: 150,
                      height: 150,
                      padding: const EdgeInsets.all(30.0),
                      child:
                          const CircularProgressIndicator(color: skyBlueColor)),
                  headers: imageNetworkHeader,
                )
              : CachedNetworkImage(
                  imageUrl: badgeImgUrl,
                  placeholder: (context, url) => Container(
                      width: 150,
                      height: 150,
                      padding: const EdgeInsets.all(30.0),
                      child:
                          const CircularProgressIndicator(color: skyBlueColor)),
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
            TextSpan(
              children: [
                TextSpan(
                    text: 'check_badge'.tr(),
                    style: TextStyle(color: skyBlueColor)),
                TextSpan(text: 'check_badge_2'.tr()),
              ],
            ),
          ),
        ),
      ],
    ),
    actions: [
      Expanded(
        child: GazagoButton(
          buttonText: 'confirm'.tr(),
          onTap: () async {
            Get.back();
          },
        ),
      ),
    ],
  );
}

Future<void> showChallengeBadgeAcquisitionAlert(
    PushMessageChallengeSuccessModel pushMessageData) async {
  showAlert(
    isScrollControlled: true,
    title: 'challenge_badge_awarded'.tr(),
    contentWidget: Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 30.sp, bottom: 30.sp),
          child: pushMessageData.badgeImageUrl != null &&
                  pushMessageData.badgeImageUrl!.contains('.svg')
              ? SvgPicture.network(
                  fit: BoxFit.contain,
                  pushMessageData.badgeImageUrl!,
                  width: 150.sp,
                  placeholderBuilder: (BuildContext context) => const Center(
                      child: SizedBox.square(
                          dimension: 40,
                          child:
                              CircularProgressIndicator(color: skyBlueColor))),
                  headers: imageNetworkHeader,
                )
              : CachedNetworkImage(
                  imageUrl: pushMessageData.badgeImageUrl!,
                  placeholder: (context, url) => const Center(
                      child: SizedBox.square(
                          dimension: 40,
                          child:
                              CircularProgressIndicator(color: skyBlueColor))),
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
            'challenge_completed'.tr(args: [pushMessageData.challengeTitle!]),
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
            TextSpan(
              children: [
                TextSpan(
                    text: 'check_badge'.tr(),
                    style: TextStyle(color: skyBlueColor)),
                TextSpan(text: 'check_badge_2'.tr()),
              ],
            ),
          ),
        ),
      ],
    ),
    actions: [
      Expanded(
        child: GazagoButton(
          buttonText: 'confirm'.tr(),
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
    title: 'exercise_record_deletion'.tr(),
    contentText: 'exercise_record_deletion_warning'.tr(),
    actions: [
      Expanded(
        child: GazagoButton(
          onTap: () => Get.back(),
          buttonText: 'cancel'.tr(),
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
          buttonText: 'delete'.tr(),
          buttonColor: skyBlueColor,
        ),
      ),
    ],
  );
}

void showLogoutAlert(PreferenceController controller) {
  showAlert(
    title: 'logout_confirmation'.tr(),
    contentText: 'logout_warning'.tr(),
    actions: [
      Expanded(
        child: GazagoButton(
          onTap: () => controller.onLogout(),
          buttonText: 'yes'.tr(),
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
          buttonText: 'no'.tr(),
          buttonColor: skyBlueColor,
        ),
      ),
    ],
  );
}

void showConfirmWithdrawAlert(WithdrawConfirmController controller) {
  showAlert(
    title: 'withdrawal_confirmation'.tr(),
    contentText: 'withdrawal_message'.tr(),
    actions: [
      Expanded(
        child: GazagoButton(
          onTap: () => Get.back(),
          buttonText: 'cancel'.tr(),
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
          buttonText: 'confirm'.tr(),
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
                      padding: EdgeInsets.only(
                          top: 26.sp, left: 18.sp, right: 18.sp, bottom: 22.sp),
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
                              'ongoing_exercise'.tr(),
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
                            buttonText: 'continue_exercise'.tr(),
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
                          text: 'exercise_end_instruction'.tr(),
                          children: [
                            TextSpan(text: 'end_button'.tr()),
                            TextSpan(
                                text: 'end_button_2'.tr(),
                                style: TextStyle(color: skyBlueColor)),
                          ],
                        ),
                      ),
                    ),
                    Obx(() {
                      return GestureDetector(
                        onTapDown: (tapDownDetail) => controller.onTapDownStop(
                            tapDownDetail, controller.selectedCourse.value,
                            controller: controller,
                            source: 'pendingExerciseDialog'),
                        onTapUp: (tapUpDetail) =>
                            controller.onTapUpStop(tapUpDetail),
                        child: Stack(
                          children: [
                            CircularButton(
                              radius: 104.sp,
                              color: Colors.white,
                              child: Icon(Icons.stop,
                                  color: Colors.black, size: 64.sp),
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

void itemPurchaseAlert(
    ShopDetailController controller, double remainMyAsset, tradeSymbol) {
  showAlert(
    title: 'purchase_confirmation'.tr(),
    isScrollControlled: true,
    contentWidget: Obx(() {
      return Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
                top: AppDoubleData.regular().numberSpacing8.sp,
                bottom: AppDoubleData.regular().numberSpacing16.sp),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                controller.selectedItem.value.itemCategory == 'DISPOSABLE'
                    ? Text(
                        '${formatDecimalPlaces(controller.purchaseItemSumPrice.value.toDouble(), 0)} ',
                        style: AppTextStyleData.regular()
                            .koHeadingSemiboldXl
                            .copyWith(
                              color: AppColorData.regular().colorTextPrimary,
                            ),
                      )
                    : Text(
                        '${formatDecimalPlaces(controller.selectedItem.value.price, controller.selectedItem.value.tradeSymbol == 'STIK' ? 2 : 0, isAutoDecimal: true)} ',
                        style: AppTextStyleData.regular()
                            .koHeadingSemiboldXl
                            .copyWith(
                              color: AppColorData.regular().colorTextPrimary,
                            ),
                      ),
                if (controller.selectedItem.value.tradeSymbol != null)
                  Text(
                    controller.selectedItem.value.tradeSymbol!,
                    style:
                        AppTextStyleData.regular().koHeadingMediumXl.copyWith(
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
                  padding: EdgeInsets.symmetric(
                      vertical: 15.0.sp, horizontal: 20.sp),
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
                            StyledText(
                              'challenge_item'.tr(),
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
                            StyledText(
                              'auto_equip_and_join'.tr(),
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
                            StyledText(
                              'one_per_person'.tr(),
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
              padding: EdgeInsets.only(
                  top: AppDoubleData.regular().numberSpacing12.sp),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'go_accumulation'.tr(),
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
              padding: EdgeInsets.only(
                  top: AppDoubleData.regular().numberSpacing12.sp),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'durability_resistance'.tr(),
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
              padding: EdgeInsets.only(
                  top: AppDoubleData.regular().numberSpacing12.sp),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'stamina_resistance'.tr(),
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
              padding: EdgeInsets.only(
                  top: AppDoubleData.regular().numberSpacing12.sp),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'luck'.tr(),
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
                                    controller.purchaseItemCount.value =
                                        controller.purchaseItemCount.value - 1;
                                  }
                                },
                                child: Container(
                                  width: 26.sp,
                                  height: 26.sp,
                                  decoration: BoxDecoration(
                                    color:
                                        controller.purchaseItemCount.value > 1
                                            ? skyBlueColor
                                            : lightGrayColor,
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
                                padding:
                                    EdgeInsets.symmetric(horizontal: 5.0.sp),
                                child: SizedBox(
                                  width: 80.sp,
                                  child: Center(
                                    child: StyledText(
                                      controller.purchaseItemCount.value
                                          .toString(),
                                      fontSize: 20,
                                      lineHeight: 26,
                                      fontWeight: 600,
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  if (remainMyAsset -
                                          controller.selectedItem.value.price >=
                                      controller.purchaseItemSumPrice.value) {
                                    controller.purchaseItemCount.value =
                                        controller.purchaseItemCount.value + 1;
                                  }
                                  return;
                                },
                                child: Container(
                                  width: 26.sp,
                                  height: 26.sp,
                                  decoration: BoxDecoration(
                                    color: remainMyAsset -
                                                controller
                                                    .selectedItem.value.price >=
                                            controller
                                                .purchaseItemSumPrice.value
                                        ? skyBlueColor
                                        : lightGrayColor,
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
                'balance'.tr(),
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
                      'nft_purchase_minting'.tr(),
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
                        'zero_royalty'.tr(),
                        style: AppTextStyleData.regular()
                            .koBodyMediumMd
                            .copyWith(
                              color: AppColorData.regular().colorTextSecondary,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ] else
            remainMyAsset - controller.selectedItem.value.price >=
                    controller.purchaseItemSumPrice.value
                ? Padding(
                    padding: EdgeInsets.only(top: 55.0.sp, bottom: 25.sp),
                    child: StyledText(
                      'purchase_non_refundable'.tr(),
                      fontSize: 14,
                      lineHeight: 14,
                      fontWeight: 500,
                      color: skyBlueColor,
                    ),
                  )
                : Padding(
                    padding: EdgeInsets.only(top: 55.0.sp, bottom: 25.sp),
                    child: StyledText(
                      'limited_purchase'.tr(),
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
          buttonText: 'cancel'.tr(),
          textColor: Colors.white,
          buttonColor: popupBgColor,
        ),
      ),
      SizedBox(
        width: 9.sp,
      ),
      Expanded(
        child: GazagoButton(
          onTap: () => controller
              .handlePurchaseShopItem(controller.selectedItem.value.id),
          buttonText: 'purchase'.tr(),
          buttonColor: skyBlueColor,
        ),
      ),
    ],
  );
}

void itemPurchaseShortBalanceAlert(
    ShopDetailController controller, double remainMyTik, tradeSymbol) {
  showAlert(
    allowMultipleBottomSheet: true,
    title: 'check_item_price'.tr(),
    isDangerTitle: true,
    isScrollControlled: true,
    contentWidget: Obx(() {
      return Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
                top: AppDoubleData.regular().numberSpacing8.sp,
                bottom: AppDoubleData.regular().numberSpacing16.sp),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                controller.selectedItem.value.itemCategory == 'DISPOSABLE'
                    ? Text(
                        '${formatDecimalPlaces(controller.purchaseItemSumPrice.value.toDouble(), 0)} ',
                        style: AppTextStyleData.regular()
                            .koHeadingSemiboldXl
                            .copyWith(
                              color: AppColorData.regular().colorTextPrimary,
                            ),
                      )
                    : Text(
                        '${formatDecimalPlaces(controller.selectedItem.value.price, controller.selectedItem.value.tradeSymbol == 'STIK' ? 2 : 0, isAutoDecimal: true)} ',
                        style: AppTextStyleData.regular()
                            .koHeadingSemiboldXl
                            .copyWith(
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
              padding: EdgeInsets.only(
                  top: AppDoubleData.regular().numberSpacing12.sp),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'go_accumulation'.tr(),
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
              padding: EdgeInsets.only(
                  top: AppDoubleData.regular().numberSpacing12.sp),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'durability_resistance'.tr(),
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
              padding: EdgeInsets.only(
                  top: AppDoubleData.regular().numberSpacing12.sp),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'stamina_resistance'.tr(),
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
              padding: EdgeInsets.only(
                  top: AppDoubleData.regular().numberSpacing12.sp),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'luck'.tr(),
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
          //           'purchase_item_count'.tr('${controller.purchaseItemCount.value}'),
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
                'balance'.tr(),
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
          buttonText: 'close'.tr(),
          buttonColor: skyBlueColor,
        ),
      ),
    ],
  );
}

void itemPurchaseCompleteAlert(ShopDetailController controller) {
  showAlert(
    allowMultipleBottomSheet: true,
    title: 'item_purchase_complete'.tr(),
    isScrollControlled: true,
    contentWidget: Obx(() {
      return Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
                top: AppDoubleData.regular().numberSpacing24.sp,
                bottom: AppDoubleData.regular().numberSpacing28.sp),
            child: Column(
              children: [
                SizedBox(
                  width: 174.sp,
                  child: controller.purchaseCompleteItem.value.itemImageUrl
                          .contains('.svg')
                      ? SvgPicture.network(
                          fit: BoxFit.contain,
                          controller.purchaseCompleteItem.value.itemImageUrl,
                          placeholderBuilder: (BuildContext context) =>
                              const Center(
                                  child: SizedBox.square(
                                      dimension: 40,
                                      child: CircularProgressIndicator(
                                          color: skyBlueColor))),
                          headers: imageNetworkHeader,
                        )
                      : CachedNetworkImage(
                          imageUrl: controller
                              .purchaseCompleteItem.value.itemImageUrl,
                          fit: BoxFit.fitWidth,
                          placeholder: (context, url) => const Center(
                              child: SizedBox.square(
                                  dimension: 40,
                                  child: CircularProgressIndicator(
                                      color: skyBlueColor))),
                          errorWidget: (context, url, error) => const Center(
                              child: SizedBox.square(
                                  dimension: 40,
                                  child: CircularProgressIndicator(
                                      color: skyBlueColor))),
                          httpHeaders: imageNetworkHeader,
                        ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                bottom: AppDoubleData.regular().numberSpacing12.sp),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                getItemGradeCircleIcon(
                    controller.purchaseCompleteItem.value.itemGrade),
                if (controller.selectedItem.value.id > 0 &&
                    controller.selectedItem.value.publishType == 'NFT')
                  Padding(
                    padding: EdgeInsets.only(
                        left: AppDoubleData.regular().numberSpacing8.sp),
                    child: SvgPicture.asset(
                        'assets/images/shop/ico_nft_label.svg'),
                  ),
                Padding(
                  padding: EdgeInsets.only(
                      left: AppDoubleData.regular().numberSpacing8.sp),
                  child: Text(
                    controller.purchaseCompleteItem.value.itemName,
                    style: AppTextStyleData.regular().koBodyMediumXl.copyWith(
                          color: AppColorData.regular().colorTextPrimary,
                        ),
                  ),
                ),
                if (controller.purchaseCompleteItem.value.itemCategory ==
                    'DISPOSABLE')
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
              padding: EdgeInsets.symmetric(
                  horizontal: AppDoubleData.regular().numberSpacing8.sp,
                  vertical: AppDoubleData.regular().numberSpacing4.sp),
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
                        if (controller.purchaseCompleteItem.value.itemStat !=
                                null &&
                            controller.purchaseCompleteItem.value.itemStat!
                                    .goProfit! >
                                0)
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  formatDecimalPlaces(
                                      controller.purchaseCompleteItem.value
                                          .itemStat!.goProfit!,
                                      0),
                                  style: AppTextStyleData.regular()
                                      .koBodyMediumXl
                                      .copyWith(
                                        color: AppColorData.regular()
                                            .colorPointCyan,
                                      ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 3.sp),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      iconShopRewardPng,
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: AppDoubleData.regular()
                                                .numberSpacing4
                                                .sp),
                                        child: Text(
                                          'go_accumulation'.tr(),
                                          style: AppTextStyleData.regular()
                                              .koCaptionMediumMd
                                              .copyWith(
                                                color: AppColorData.regular()
                                                    .colorTextBrand,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (controller
                                    .purchaseCompleteItem.value.itemStat !=
                                null &&
                            controller.purchaseCompleteItem.value.itemStat!
                                    .goProfit! >
                                0 &&
                            (controller
                                        .purchaseCompleteItem.value.itemStat!.durability! >
                                    0 ||
                                controller.purchaseCompleteItem.value.itemStat!
                                        .stamina! >
                                    0 ||
                                controller.purchaseCompleteItem.value.itemStat!
                                        .luck! >
                                    0))
                          SizedBox(
                            height: 42.sp,
                            child: VerticalDivider(
                              color: AppColorData.regular().colorBorderPrimary,
                              width: 1,
                              thickness: 1,
                            ),
                          ),
                        if (controller.purchaseCompleteItem.value.itemStat !=
                                null &&
                            controller.purchaseCompleteItem.value.itemStat!
                                    .durability! >
                                0)
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  formatDecimalPlaces(
                                      controller.purchaseCompleteItem.value
                                          .itemStat!.durability!,
                                      0),
                                  style: AppTextStyleData.regular()
                                      .koBodyMediumXl
                                      .copyWith(
                                        color: AppColorData.regular()
                                            .colorPointPurple,
                                      ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 3.sp),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      iconShopDurabilityLightPng,
                                      Padding(
                                        padding: EdgeInsets.only(left: 4.0.sp),
                                        child: Text(
                                          'durability_resistance'.tr(),
                                          style: AppTextStyleData.regular()
                                              .koCaptionMediumMd
                                              .copyWith(
                                                color: AppColorData.regular()
                                                    .colorPointPurple,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (controller.purchaseCompleteItem.value.itemStat !=
                                null &&
                            (controller.purchaseCompleteItem.value.itemStat!
                                        .goProfit! >
                                    0 ||
                                controller.purchaseCompleteItem.value.itemStat!
                                        .durability! >
                                    0) &&
                            (controller.purchaseCompleteItem.value.itemStat!
                                        .stamina! >
                                    0 ||
                                controller.purchaseCompleteItem.value.itemStat!
                                        .luck! >
                                    0))
                          SizedBox(
                            height: 42.sp,
                            child: VerticalDivider(
                              color: AppColorData.regular().colorBorderPrimary,
                              width: 1,
                              thickness: 1,
                            ),
                          ),
                        if (controller.purchaseCompleteItem.value.itemStat !=
                                null &&
                            controller.purchaseCompleteItem.value.itemStat!
                                    .stamina! >
                                0)
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  formatDecimalPlaces(
                                      controller.purchaseCompleteItem.value
                                          .itemStat!.stamina!,
                                      0),
                                  style: AppTextStyleData.regular()
                                      .koBodyMediumXl
                                      .copyWith(
                                        color: AppColorData.regular()
                                            .colorYellowgreen500,
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
                                          'stamina_resistance'.tr(),
                                          style: AppTextStyleData.regular()
                                              .koCaptionMediumMd
                                              .copyWith(
                                                color: AppColorData.regular()
                                                    .colorPointYellowgreen,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (controller
                                    .purchaseCompleteItem.value.itemStat !=
                                null &&
                            controller.purchaseCompleteItem.value.itemStat!
                                    .luck! >
                                0 &&
                            (controller
                                        .purchaseCompleteItem.value.itemStat!.durability! >
                                    0 ||
                                controller.purchaseCompleteItem.value.itemStat!
                                        .stamina! >
                                    0 ||
                                controller.purchaseCompleteItem.value.itemStat!
                                        .goProfit! >
                                    0))
                          SizedBox(
                            height: 42.sp,
                            child: VerticalDivider(
                              color: AppColorData.regular().colorBorderPrimary,
                              width: 1,
                              thickness: 1,
                            ),
                          ),
                        if (controller.purchaseCompleteItem.value.itemStat !=
                                null &&
                            controller.purchaseCompleteItem.value.itemStat!
                                    .luck! >
                                0)
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  formatDecimalPlaces(
                                      controller.purchaseCompleteItem.value
                                          .itemStat!.luck!,
                                      0),
                                  style: AppTextStyleData.regular()
                                      .koBodyMediumXl
                                      .copyWith(
                                        color: AppColorData.regular()
                                            .colorPointPink,
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
                                          'luck'.tr(),
                                          style: AppTextStyleData.regular()
                                              .koCaptionMediumMd
                                              .copyWith(
                                                color: AppColorData.regular()
                                                    .colorPointPink,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (controller.purchaseCompleteItem.value.itemStat!
                                .repairDurability! >
                            0)
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  '+${formatDecimalPlaces(controller.purchaseCompleteItem.value.itemStat!.repairDurability!, 0)}',
                                  style: AppTextStyleData.regular()
                                      .koBodyMediumXl
                                      .copyWith(
                                        color: AppColorData.regular()
                                            .colorPointPurple,
                                      ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 3.sp),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      iconShopDurabilityLightPng,
                                      Padding(
                                        padding: EdgeInsets.only(left: 4.0.sp),
                                        child: Text(
                                          'durability_repair'.tr(),
                                          style: AppTextStyleData.regular()
                                              .koCaptionMediumMd
                                              .copyWith(
                                                color: AppColorData.regular()
                                                    .colorPointPurple,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (controller.purchaseCompleteItem.value.itemStat!
                                .recoveryStamina! >
                            0)
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  '+${formatDecimalPlaces(controller.purchaseCompleteItem.value.itemStat!.recoveryStamina!, 0)}',
                                  style: AppTextStyleData.regular()
                                      .koBodyMediumXl
                                      .copyWith(
                                        color: AppColorData.regular()
                                            .colorPointYellowgreen,
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
                                          'stamina_recovery_2'.tr(),
                                          style: AppTextStyleData.regular()
                                              .koCaptionMediumMd
                                              .copyWith(
                                                color: AppColorData.regular()
                                                    .colorPointYellowgreen,
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
                  if (controller.purchaseCompleteItem.value.challenge != null &&
                      controller.purchaseCompleteItem.value.challenge!.extTxt !=
                          null)
                    Padding(
                      padding: EdgeInsets.only(bottom: 24.0.sp),
                      child: StyledText(
                        controller
                            .purchaseCompleteItem.value.challenge!.extTxt!,
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
                  'purchased_item_location'.tr(),
                  style: AppTextStyleData.regular().koBodyMediumMd.copyWith(
                        color: AppColorData.regular().colorTextSecondary,
                      ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'check_item_location'.tr(),
                      style: AppTextStyleData.regular().koBodyMediumMd.copyWith(
                            color: AppColorData.regular().colorTextBrand,
                          ),
                    ),
                    Text(
                      'check_item_location_2'.tr(),
                      style: AppTextStyleData.regular().koBodyMediumMd.copyWith(
                            color: AppColorData.regular().colorTextSecondary,
                          ),
                    )
                  ],
                ),
              ],
            ),
          ),
          if (controller.purchaseCompleteItem.value.challenge != null &&
              controller.purchaseCompleteItem.value.challenge!.extTxtDetail !=
                  null)
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
      if (controller.purchaseCompleteItem.value.challenge != null &&
          controller.purchaseCompleteItem.value.challenge!.linkUrl != null)
        Expanded(
          child: GazagoButton(
            onTap: () => controller.moveToExternalBrowser(
                controller.purchaseCompleteItem.value.challenge!.linkUrl),
            buttonText:
                controller.purchaseCompleteItem.value.challenge!.extBtnLabel!,
            textColor: Colors.white,
            buttonColor: popupBgColor,
          ),
        ),
      if (controller.purchaseCompleteItem.value.challenge != null &&
          controller.purchaseCompleteItem.value.challenge!.linkUrl != null)
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
          buttonText: 'confirm'.tr(),
          buttonColor: skyBlueColor,
        ),
      ),
    ],
  );
}

void itemPurchaseImpossibleAlert() {
  showAlert(
    allowMultipleBottomSheet: true,
    title: 'purchase_unavailable'.tr(),
    contentWidget: Padding(
      padding: EdgeInsets.only(top: 20.0.sp, bottom: 40.sp),
      child: StyledText(
        'purchase_unavailable_reason'.tr(),
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
          buttonText: 'confirm'.tr(),
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
      child: StyledText(
        'one_per_person_2'.tr(),
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
          buttonText: 'confirm'.tr(),
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
                              color: controller
                                          .isSelectedSortValue.value['value'] ==
                                      entry.value['value']
                                  ? skyBlueColor
                                  : Colors.white,
                            ),
                            if (controller.isSelectedSortValue.value['value'] ==
                                entry.value['value'])
                              iconSortChecked
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
          buttonText: 'cancel'.tr(),
          textColor: Colors.white,
          buttonColor: popupBgColor,
        ),
      ),
      SizedBox(
        width: 9.sp,
      ),
      Expanded(
        child: GazagoButton(
          onTap: () => controller
              .onClickConfirmSortValue(controller.isSelectedSortValue.value),
          buttonText: 'apply'.tr(),
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
          //   child: StyledText(
          //     'category'.tr(),
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
            child: StyledText(
              'filter'.tr(),
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
                          color: controller.isSelectAllItems.value
                              ? Colors.white
                              : popupBgColor,
                          border: Border.all(
                            width: 1,
                            color: Colors.white,
                          ),
                          borderRadius: BorderRadius.circular(20.sp),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 12.0.sp, vertical: 6.sp),
                          child: Text(
                            'all'.tr(),
                            style: AppTextStyleData.regular()
                                .enBodySemiboldMd
                                .copyWith(
                                  color: controller.isSelectAllItems.value
                                      ? Colors.black
                                      : Colors.white,
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
                            onTap: () =>
                                controller.onSelectGrade(entry.value['value']),
                            child: Container(
                              decoration: BoxDecoration(
                                color: controller.selectedGrade.any((element) =>
                                        element == entry.value['value'])
                                    ? getItemGradeColor(entry.value['value']!)
                                    : popupBgColor,
                                border: Border.all(
                                  width: 1,
                                  color:
                                      getItemGradeColor(entry.value['value']!),
                                ),
                                borderRadius: BorderRadius.circular(20.sp),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12.0.sp, vertical: 6.sp),
                                child: Text(
                                  entry.value['title']!,
                                  style: AppTextStyleData.regular()
                                      .enBodySemiboldMd
                                      .copyWith(
                                        color: controller.selectedGrade.any(
                                                (element) =>
                                                    element ==
                                                    entry.value['value'])
                                            ? Colors.black
                                            : getItemGradeColor(
                                                entry.value['value']!),
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
                          color: controller.isSelectNftItems.value
                              ? AppColorData.regular().colorPointOrange
                              : popupBgColor,
                          border: Border.all(
                            width: 1,
                            color: AppColorData.regular().colorPointOrange,
                          ),
                          borderRadius: BorderRadius.circular(20.sp),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 12.0.sp, vertical: 6.sp),
                          child: Text(
                            'NFT',
                            style: AppTextStyleData.regular()
                                .enBodySemiboldMd
                                .copyWith(
                                  color: controller.isSelectNftItems.value
                                      ? Colors.black
                                      : AppColorData.regular().colorPointOrange,
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
          buttonText: 'cancel'.tr(),
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
          buttonText: 'apply'.tr(),
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
            Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: StyledText(
                'carrier_selection'.tr(),
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
          onTap: () =>
              Get.until((route) => Get.currentRoute == Routes.verificationName),
          buttonText: 'confirm'.tr(),
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
          buttonText: 'confirm'.tr(),
          buttonColor: skyBlueColor,
        ),
      ),
    ],
  );
}

void alreadyConnectedDeviceAlert(
    LoginController controller, LoginType socialType, String accessToken) {
  showAlert(
    allowMultipleBottomSheet: true,
    title: 'confirmation_request'.tr(),
    contentWidget: Padding(
      padding: EdgeInsets.only(top: 20.0.sp, bottom: 40.sp),
      child: StyledText(
        'logged_in_on_another_device'.tr(),
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
          buttonText: 'no'.tr(),
          textColor: Colors.white,
          buttonColor: popupBgColor,
        ),
      ),
      SizedBox(
        width: 9.sp,
      ),
      Expanded(
        child: GazagoButton(
          onTap: () => controller.requestLogin(socialType, accessToken,
              forceLogin: true),
          buttonText: 'yes'.tr(),
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
    title: 'confirmation_complete'.tr(),
    contentWidget: Padding(
      padding: EdgeInsets.only(top: 20.0.sp, bottom: 40.sp),
      child: StyledText(
        'session_terminated_due_to_login_on_another_device'.tr(),
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
          buttonText: 'confirm'.tr(),
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
                      padding: EdgeInsets.only(
                          top: 19.sp, left: 18.sp, right: 18.sp, bottom: 50.sp),
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
                              'ad_viewing_tip'.tr(),
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
                                        color:
                                            const Color.fromRGBO(0, 0, 0, 0.85),
                                        offset: const Offset(0, 2),
                                        blurRadius: 0,
                                        spreadRadius: 1.sp,
                                      )
                                    ],
                                    borderRadius: BorderRadius.circular(14.sp),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        top: 32.sp, left: 10.sp, right: 10.sp),
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
                                                text: 'watch_ad_get_go_start'
                                                    .tr(args: [
                                                  challengeId == null ||
                                                          exerciseType.value ==
                                                              ExerciseType
                                                                  .walking.value
                                                      ? '1'
                                                      : '3'
                                                ]),
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
                                  text: 'watch_ad_to_the_end'.tr(),
                                  style: TextStyle(color: skyBlueColor),
                                ),
                                TextSpan(
                                  text: 'recommended'.tr(),
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
                                  text: 'ad_reward_daily_go'.tr(),
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
                                  text: 'ad_button_disabled_after_activity_end'
                                      .tr(),
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
                                  TextSpan(
                                    text: 'zero_go_balance'.tr(),
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
                                  TextSpan(
                                    text: 'past_midnight_kst'.tr(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                        right: 14,
                        top: 14,
                        child: InkWell(
                            onTap: () => Get.back(), child: iconCloseWhite)),
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
                    padding: EdgeInsets.only(
                        top: 49.sp, left: 29.sp, right: 29.sp, bottom: 50.sp),
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
                                    text: 'todays_reward'.tr(),
                                    style: const TextStyle(
                                      color: Color(0xFFFF87B5),
                                      // height: 18.sp,
                                    )),
                                TextSpan(
                                  text: 'todays_reward_description'.tr(),
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
                                'reward_based_on_yesterday_activity'.tr(),
                                color: lightGrayColor,
                                fontSize: 11,
                                lineHeight: 16,
                              ),
                              StyledText(
                                'reward_for_leaderboard_participants'.tr(),
                                color: lightGrayColor,
                                fontSize: 11,
                                lineHeight: 16,
                              ),
                              StyledText(
                                'reward_confirmation_midnight_kst'.tr(),
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
                                  text: 'gajago_team_reward_percentage'.tr(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: 'reward_explanation'.tr(),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w400,
                                        color: lightGrayColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              StyledText(
                                'todays_reward_components'.tr(),
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
                                    text: 'yesterday_tik_usage'.tr(),
                                    children: [
                                      TextSpan(
                                        text: 'total_tik_used'.tr(),
                                        style: const TextStyle(
                                          color: tikColor,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    EdgeInsets.only(top: 5.0.sp, left: 7.0.sp),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    StyledText(
                                      'stamina_recovery'.tr(),
                                      fontSize: 12,
                                      lineHeight: 18,
                                      fontWeight: 400,
                                    ),
                                    StyledText(
                                      'durability_repair_1'.tr(),
                                      fontSize: 12,
                                      lineHeight: 18,
                                      fontWeight: 400,
                                    ),
                                    StyledText(
                                      'general_equipment_purchase'.tr(),
                                      fontSize: 12,
                                      lineHeight: 18,
                                      fontWeight: 400,
                                    ),
                                    StyledText(
                                      'voucher_exchange_cost'.tr(),
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
                                    text: 'leaderboard_participant_bonus'.tr(),
                                    children: [
                                      TextSpan(
                                        text: 'additional_reward'.tr(),
                                        style: const TextStyle(
                                          color: tikColor,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    EdgeInsets.only(top: 5.0.sp, left: 7.0.sp),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    StyledText(
                                      'participant_count_reward'.tr(),
                                      fontSize: 12,
                                      lineHeight: 18,
                                      fontWeight: 400,
                                    ),
                                    StyledText(
                                      'top_rank_reward'.tr(),
                                      fontSize: 12,
                                      lineHeight: 18,
                                      fontWeight: 400,
                                    ),
                                    StyledText(
                                      'surprise_rank_reward'.tr(),
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
                                        text: 'two_months_ago_stik_total'.tr(),
                                        style: const TextStyle(
                                          color: tikColor,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      TextSpan(
                                        text: 'stik_to_tik_conversion'.tr(),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    EdgeInsets.only(top: 5.0.sp, left: 7.0.sp),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    StyledText(
                                      'nft_equipment_purchase'.tr(),
                                      fontSize: 12,
                                      lineHeight: 18,
                                      fontWeight: 400,
                                    ),
                                    StyledText(
                                      'stik_usage_cost'.tr(),
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
                  Positioned(
                      right: 12,
                      top: 20,
                      child: InkWell(
                          onTap: () => Get.back(), child: iconCloseWhite)),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

Future<void> showMainPopupAlert(
    NoticePopupController noticePopupController) async {
  final CarouselSliderController carouselController =
      CarouselSliderController();
  if (Get.isBottomSheetOpen == null ||
      !Get.isBottomSheetOpen! ||
      !Get.isDialogOpen!) {
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
                              onTap: () =>
                                  noticePopupController.moveToWebView(item),
                              child: item.imageUrlKo != null
                                  ? Image.network(
                                      item.imageUrlKo!,
                                      width: double.infinity,
                                    )
                                  : Container(),
                            ),
                          ))
                      .toList(),
                  controller: carouselController,
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
                          padding: EdgeInsets.symmetric(
                              horizontal: 8.0.sp, vertical: 4.0.sp),
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
                        onTap: () =>
                            noticePopupController.onSavePopupCloseDate(),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 28.0.sp, horizontal: 10.sp),
                          child: StyledText(
                            'hide_today'.tr(),
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
                          padding: EdgeInsets.symmetric(
                              vertical: 28.0.sp, horizontal: 10.sp),
                          child: StyledText(
                            'close'.tr(),
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
              'unexpected_store_connection_error'.tr(),
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
          onTap: () => Get.until((route) =>
              Get.isBottomSheetOpen == false && Get.isDialogOpen == false),
          buttonText: 'confirm'.tr(),
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
                                  ? 'payment_in_progress'.tr()
                                  : 'tik_charging'.tr()
                              : 'payment_approval_pending'.tr(),
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
                              padding:
                                  const EdgeInsets.only(top: 14, bottom: 30),
                              child: StyledText(
                                'tik_charge_complete'.tr(),
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
                              padding:
                                  const EdgeInsets.only(top: 14, bottom: 30),
                              child: StyledText(
                                controller.showStoreErrorText.value
                                    ? 'payment_error'.tr()
                                    : 'payment_complete_tik_charge_failed'.tr(),
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
              buttonText: 'confirm'.tr(),
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
              'payment_in_progress_check_wallet'.tr(),
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
          buttonText: 'confirm'.tr(),
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
              'enter_password'.tr(),
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
                passwordInputCompleter
                    .complete(await controller.verifyEndPointPassword());
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
          buttonText: 'cancel'.tr(),
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
            passwordInputCompleter
                .complete(await controller.verifyEndPointPassword());
          },
          buttonText: 'confirm'.tr(),
          buttonColor: skyBlueColor,
        ),
      ),
    ],
  );

  return passwordInputCompleter.future;
}

void showStaikaStatusAlert(
    {required bool hasWallet, TabController? tabController}) {
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
                    text: 'staika_wallet_connected'.tr(),
                    children: [
                      TextSpan(
                          text: 'connected'.tr(),
                          style: TextStyle(
                              color: AppColorData.regular().colorTextBrand)),
                      TextSpan(text: 'created_staika_wallet'.tr()),
                    ],
                  ))
              : Text(
                  'create_staika_wallet'.tr(),
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
                          style: AppTextStyleData.regular()
                              .koBodyMediumLg
                              .copyWith(
                                color: AppColorData.regular().colorTextPrimary,
                              ),
                        ),
                        Expanded(
                          child: Text(
                            'staika_wallet_already_connected'.tr(),
                            style: AppTextStyleData.regular()
                                .koBodyMediumLg
                                .copyWith(
                                  color:
                                      AppColorData.regular().colorTextPrimary,
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
                          style: AppTextStyleData.regular()
                              .koBodyMediumLg
                              .copyWith(
                                color: AppColorData.regular().colorTextPrimary,
                              ),
                        ),
                        Expanded(
                          child: Text(
                            'same_address_password'.tr(),
                            style: AppTextStyleData.regular()
                                .koBodyMediumLg
                                .copyWith(
                                  color:
                                      AppColorData.regular().colorTextPrimary,
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
                          style: AppTextStyleData.regular()
                              .koBodyMediumLg
                              .copyWith(
                                color: AppColorData.regular().colorTextPrimary,
                              ),
                        ),
                        Expanded(
                          child: Text(
                            'smart_asset_management'.tr(),
                            style: AppTextStyleData.regular()
                                .koBodyMediumLg
                                .copyWith(
                                  color:
                                      AppColorData.regular().colorTextPrimary,
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
                          style: AppTextStyleData.regular()
                              .koBodyMediumLg
                              .copyWith(
                                color: AppColorData.regular().colorTextPrimary,
                              ),
                        ),
                        Expanded(
                          child: Text(
                            'transfer_password_setup'.tr(),
                            style: AppTextStyleData.regular()
                                .koBodyMediumLg
                                .copyWith(
                                  color:
                                      AppColorData.regular().colorTextPrimary,
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
                buttonText: 'confirm'.tr(),
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
                      buttonText: 'cancel'.tr(),
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
                      buttonText: 'create_wallet'.tr(),
                      buttonColor: skyBlueColor,
                    ),
                  ),
                ],
              ),
            ),
    ],
  );
}

void showNotSupportedWalletAlert(
    {required String message, required TabController tabController}) {
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
                buttonText: 'confirm'.tr(),
                buttonColor: skyBlueColor,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

void exchangeStikToTikAlert(
    GoWalletController controller, ExchangeStikPriceModel exchangeProduct) {
  GoWalletController controller = Get.find();
  WalletMasterController walletMasterController = Get.find();
  showAlert(
    title: 'exchange_confirmation'.tr(),
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
                        ? SvgPicture.asset('assets/images/wallet/ico_stik.svg',
                            width: 24, height: 24)
                        : SvgPicture.asset('assets/images/wallet/ico_tik.svg',
                            width: 24, height: 24),
                    Padding(
                      padding: EdgeInsets.only(left: 7.0.sp),
                      child: StyledText(
                        formatDecimalPlaces(
                            walletMasterController.clickedAssetButton.value ==
                                    'STAIKA'
                                ? double.parse(
                                    exchangeProduct.fromUiAmountString!)
                                : productSumFeePrice(
                                    exchangeProduct.fromUiAmountString!,
                                    exchangeProduct.uiFeeString!),
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
                  child: SvgPicture.asset(
                      'assets/images/wallet/ico_arrow_bottom.svg',
                      width: 20,
                      height: 20),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    walletMasterController.clickedAssetButton.value == 'STAIKA'
                        ? SvgPicture.asset('assets/images/wallet/ico_tik.svg',
                            width: 24, height: 24)
                        : SvgPicture.asset('assets/images/wallet/ico_stik.svg',
                            width: 24, height: 24),
                    Padding(
                      padding: EdgeInsets.only(left: 7.0.sp),
                      child: walletMasterController.clickedAssetButton.value ==
                              'STAIKA'
                          ? StyledText(
                              formatDecimalPlaces(
                                  productMinusFeePrice(
                                      exchangeProduct.toUiAmountString!,
                                      exchangeProduct.uiFeeString!),
                                  0),
                              fontSize: 30,
                              lineHeight: 32,
                              fontWeight: 600,
                              letterSpacing: -.1,
                            )
                          : StyledText(
                              formatDecimalPlaces(
                                  double.parse(
                                      exchangeProduct.toUiAmountString!),
                                  0),
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
                'base_price'.tr(),
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
              'exchange_cannot_be_cancelled'.tr(),
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
          buttonText: 'cancel'.tr(),
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
          buttonText: 'exchange_assets'.tr(),
          buttonColor: skyBlueColor,
        ),
      ),
    ],
  );
}

void failureChargeStikToTikAlert(
    GoWalletController controller, String errorMsg) {
  showAlert(
    allowMultipleBottomSheet: true,
    title: 'retry_later_1'.tr(),
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
          buttonText: 'confirm'.tr(),
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
              'exchange_complete'.tr(args: [
                walletMasterController.clickedAssetButton.value == 'STAIKA'
                    ? 'TIK'
                    : 'STIK'
              ]),
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
          buttonText: 'confirm'.tr(),
          buttonColor: skyBlueColor,
        ),
      ),
    ],
  );
}

void sendStikToGoWalletAlert(
    StaikaWalletController controller, String password) {
  WalletMasterController walletMasterController = Get.find();
  showAlert(
    allowMultipleBottomSheet: true,
    title: 'send_confirmation'.tr(),
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
                    SvgPicture.asset('assets/images/wallet/ico_stik.svg',
                        width: 24, height: 24),
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
              'send_cannot_be_cancelled'.tr(),
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
          buttonText: 'no'.tr(),
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
          buttonText: 'yes'.tr(),
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
    title: 'send_confirmation'.tr(),
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
                    SvgPicture.asset('assets/images/wallet/ico_stik.svg',
                        width: 24, height: 24),
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
              'send_cannot_be_cancelled'.tr(),
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
          buttonText: 'no'.tr(),
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
          buttonText: 'yes'.tr(),
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
    title: 'insufficient_balance_1'.tr(),
    contentWidget: Padding(
      padding: EdgeInsets.only(top: 20.0.sp, bottom: 40.sp),
      child: StyledText(
        'insufficient_balance_retry'.tr(args: [
          walletMasterController.clickedAssetButton.value == 'STAIKA'
              ? 'STIK'
              : 'TIK'
        ]),
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
          buttonText: 'confirm'.tr(),
          buttonColor: skyBlueColor,
        ),
      ),
    ],
  );
}

void exchangeStikShortBalanceAlert(StaikaWalletController controller) {
  showAlert(
    allowMultipleBottomSheet: true,
    title: 'insufficient_stik_balance'.tr(),
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
                //           child: StyledText(
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
                      StyledText(
                        'requested_stik'.tr(),
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
                      StyledText(
                        'held_stik'.tr(),
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
                      StyledText(
                        'remaining_balance_after_transfer'.tr(),
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
                style: TextStyle(
                    color: lightGrayColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 14.sp,
                    height: 18.sp / 14,
                    letterSpacing: -.1),
                children: [
                  TextSpan(
                    text: 'minimum_solana_balance'.tr(),
                  ),
                  TextSpan(
                    text: '0.0001 STIK',
                  ),
                  TextSpan(
                    text: 'minimum_balance_required'.tr(),
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
          buttonText: 'confirm'.tr(),
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
    title: 'insufficient_balance_1'.tr(),
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
                      StyledText(
                        'requested_amount'.tr(),
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
                      StyledText(
                        'current_balance'.tr(),
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
            child: StyledText(
              'insufficient_stik_retry'.tr(),
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
          buttonText: 'confirm'.tr(),
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
              StyledText(
                'send_request_complete'.tr(),
                fontSize: 18,
                lineHeight: 24,
                fontWeight: 500,
                letterSpacing: .2,
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.0.sp),
                child: StyledText(
                  'check_transaction_history'.tr(),
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
          buttonText: 'confirm'.tr(),
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
              StyledText(
                'request_received'.tr(),
                fontSize: 18,
                lineHeight: 24,
                fontWeight: 500,
                letterSpacing: .2,
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.0.sp),
                child: StyledText(
                  'processing_within_24_hours'.tr(),
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
          buttonText: 'confirm'.tr(),
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
              StyledText(
                'retry_later_1'.tr(),
                fontSize: 18,
                lineHeight: 24,
                fontWeight: 500,
                letterSpacing: .2,
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.0.sp),
                child: StyledText(
                  'blockchain_network_delay'.tr(),
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
          buttonText: 'confirm'.tr(),
          buttonColor: skyBlueColor,
        ),
      ),
    ],
  );
}

void showNeedVerificationAlert(WalletMasterController controller) {
  showAlert(
    title: 'verification_required'.tr(),
    contentText: 'verification_required_for_voucher_exchange'.tr(),
    actions: [
      Expanded(
        child: GazagoButton(
          onTap: () => controller.moveToVerification(),
          buttonText: 'confirm'.tr(),
          buttonColor: skyBlueColor,
        ),
      ),
    ],
  );
}

void showForceUpdateApp() {
  showAlert(
    title: 'new_update_available'.tr(),
    contentText: 'update_required'.tr(),
    allowMultipleBottomSheet: true,
    actions: [
      Expanded(
        child: GazagoButton(
          onTap: () {
            if (Platform.isAndroid || Platform.isIOS) {
              final url = Uri.parse(
                Platform.isAndroid
                    ? "https://gazago.page.link/update_android"
                    : "https://gazago.page.link/update_ios",
              );
              launchUrl(
                url,
                mode: LaunchMode.externalApplication,
              );
            }
          },
          buttonText: 'update'.tr(),
          buttonColor: skyBlueColor,
        ),
      ),
    ],
  );
}

void showRecommendUpdateApp() {
  showAlert(
    title: 'new_update_available'.tr(),
    contentText: 'update_required'.tr(),
    actions: [
      Expanded(
        child: GazagoButton(
          onTap: () => Get.offAllNamed(Routes.home),
          buttonText: 'ignore_update'.tr(),
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
                Platform.isAndroid
                    ? "https://gazago.page.link/update_android"
                    : "https://gazago.page.link/update_ios",
              );
              launchUrl(
                url,
                mode: LaunchMode.externalApplication,
              );
            }
          },
          buttonText: 'update'.tr(),
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
                      padding: EdgeInsets.only(
                          top: 40.sp, left: 20.sp, right: 20.sp, bottom: 32.sp),
                      decoration: BoxDecoration(
                        color: AppColorData.regular().colorBgTertiary,
                        borderRadius: BorderRadius.circular(
                            AppDoubleData.regular().numberRadius20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('ability_guide'.tr(),
                              style: AppTextStyleData.regular()
                                  .koHeadingSemiboldSm
                                  .copyWith(
                                      color: AppColorData.regular()
                                          .colorTextPrimary)),
                          Padding(
                            padding: EdgeInsets.only(top: 8.0.sp),
                            child: Text(
                              'item_ability_random'.tr(),
                              style: AppTextStyleData.regular()
                                  .koBodyMediumMd
                                  .copyWith(
                                      color: AppColorData.regular()
                                          .colorTextPrimary),
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
                                        'go_accumulation'.tr(),
                                        style: AppTextStyleData.regular()
                                            .koBodyMediumMd
                                            .copyWith(
                                              color: AppColorData.regular()
                                                  .colorTextPrimary,
                                              height: 1.1,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 4.0.sp),
                                  child: Text(
                                    'higher_ability_more_go'.tr(),
                                    style: AppTextStyleData.regular()
                                        .koBodyMediumSm
                                        .copyWith(
                                            color: AppColorData.regular()
                                                .colorTextPrimary),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 16.0.sp),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          iconStatDurability,
                                          Padding(
                                            padding:
                                                EdgeInsets.only(left: 6.0.sp),
                                            child: Text(
                                              'durability_resistance'.tr(),
                                              style: AppTextStyleData.regular()
                                                  .koBodyMediumMd
                                                  .copyWith(
                                                    color:
                                                        AppColorData.regular()
                                                            .colorTextPrimary,
                                                    height: 1.1,
                                                  ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 4.0.sp),
                                        child: Text(
                                          'higher_ability_less_durability_loss'
                                              .tr(),
                                          style: AppTextStyleData.regular()
                                              .koBodyMediumSm
                                              .copyWith(
                                                  color: AppColorData.regular()
                                                      .colorTextPrimary),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 16.0.sp),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          iconStatStamina,
                                          Padding(
                                            padding:
                                                EdgeInsets.only(left: 6.0.sp),
                                            child: Text(
                                              'stamina_resistance'.tr(),
                                              style: AppTextStyleData.regular()
                                                  .koBodyMediumMd
                                                  .copyWith(
                                                    color:
                                                        AppColorData.regular()
                                                            .colorTextPrimary,
                                                    height: 1.1,
                                                  ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 4.0.sp),
                                        child: Text(
                                          'higher_ability_less_stamina_loss'
                                              .tr(),
                                          style: AppTextStyleData.regular()
                                              .koBodyMediumSm
                                              .copyWith(
                                                  color: AppColorData.regular()
                                                      .colorTextPrimary),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 16.0.sp),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          iconStatLuck,
                                          Padding(
                                            padding:
                                                EdgeInsets.only(left: 6.0.sp),
                                            child: Text(
                                              'luck'.tr(),
                                              style: AppTextStyleData.regular()
                                                  .koBodyMediumMd
                                                  .copyWith(
                                                    color:
                                                        AppColorData.regular()
                                                            .colorTextPrimary,
                                                    height: 1.1,
                                                  ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 4.0.sp),
                                        child: Text(
                                          'higher_ability_more_lucky_go'.tr(),
                                          style: AppTextStyleData.regular()
                                              .koBodyMediumSm
                                              .copyWith(
                                                  color: AppColorData.regular()
                                                      .colorTextPrimary),
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
                    Positioned(
                        right: 16.8.sp,
                        top: 16.8.sp,
                        child: InkWell(
                            onTap: () => Get.back(), child: iconCloseWhite)),
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

void showMaintenanceAlert(
    {String type = 'ING',
    required String contentText,
    List<Function>? callbacks}) {
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
        description = Padding(
          padding: const EdgeInsets.only(top: 28, bottom: 28),
          child: StyledText(
            'complete_exercise_before_maintenance'.tr(),
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

        description = Padding(
          padding: const EdgeInsets.only(top: 28, bottom: 28),
          child: StyledText(
            'system_maintenance_announcement'.tr(),
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
        description = Padding(
          padding: const EdgeInsets.only(top: 28, bottom: 28),
          child: StyledText(
            'emergency_maintenance'.tr(),
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
        description = Padding(
          padding: const EdgeInsets.only(top: 28, bottom: 28),
          child: StyledText(
            'system_maintenance_announcement'.tr(),
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
                        buttonText: 'close'.tr(),
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
                          child: StyledText(
                            'hide_today'.tr(),
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
                              color: controller
                                          .isSelectedSortValue.value['value'] ==
                                      entry.value['value']
                                  ? skyBlueColor
                                  : Colors.white,
                            ),
                            if (controller.isSelectedSortValue.value['value'] ==
                                entry.value['value'])
                              iconSortChecked
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
          buttonText: 'cancel'.tr(),
          textColor: Colors.white,
          buttonColor: popupBgColor,
        ),
      ),
      SizedBox(
        width: 9.sp,
      ),
      Expanded(
        child: GazagoButton(
          onTap: () => controller
              .onClickConfirmSortValue(controller.isSelectedSortValue.value),
          buttonText: 'apply'.tr(),
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
                      color: controller.isSelectAllItems.value
                          ? Colors.white
                          : popupBgColor,
                      border: Border.all(
                        width: 1,
                        color: Colors.white,
                      ),
                      borderRadius: BorderRadius.circular(25.sp),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 12.0.sp, vertical: 6.sp),
                      child: StyledText(
                        'all'.tr(),
                        fontSize: 14,
                        lineHeight: 16,
                        letterSpacing: .2,
                        fontWeight: 500,
                        color: controller.isSelectAllItems.value
                            ? Colors.black
                            : Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
          Padding(
            padding: EdgeInsets.only(bottom: 20.0.sp),
            child: StyledText(
              'exercise_mode'.tr(),
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
                            onTap: () => controller
                                .onSelectCategory(entry.value['value']),
                            child: Container(
                              decoration: BoxDecoration(
                                color: controller.selectedStatus.any(
                                        (element) =>
                                            element == entry.value['value'])
                                    ? Colors.white
                                    : popupBgColor,
                                border: Border.all(
                                  width: 1,
                                  color: Colors.white,
                                ),
                                borderRadius: BorderRadius.circular(20.sp),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12.0.sp, vertical: 6.sp),
                                child: StyledText(
                                  entry.value['title']!,
                                  fontSize: 14,
                                  lineHeight: 16,
                                  letterSpacing: .2,
                                  fontWeight: 500,
                                  color: controller.selectedStatus.any(
                                          (element) =>
                                              element == entry.value['value'])
                                      ? Colors.black
                                      : Colors.white,
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
          buttonText: 'cancel'.tr(),
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
          buttonText: 'apply'.tr(),
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
      child: Column(
        children: [
          StyledText(
            'item_sold_out'.tr(),
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
          buttonText: 'confirm'.tr(),
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
      child: Column(
        children: [
          StyledText(
            'challenge_ended'.tr(),
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
          buttonText: 'confirm'.tr(),
          buttonColor: skyBlueColor,
        ),
      ),
    ],
  );
}

void moveBuyChallengeItemPageAlert(
    ChallengesDetailController controller, int itemId) {
  showAlert(
    contentWidget: Padding(
      padding: EdgeInsets.only(top: 20.0.sp, bottom: 40.sp),
      child: Column(
        children: [
          StyledText(
            'purchase_item_for_challenge'.tr(),
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
          buttonText: 'no'.tr(),
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
          buttonText: 'yes'.tr(),
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
      child: Column(
        children: [
          StyledText(
            'challenge_participation_possible'.tr(),
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
          buttonText: 'no'.tr(),
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

            if (challengesDetailController
                        .challengeDetails.value.challengeUserState !=
                    'JOINED_UNEQUIPPED_ITEM' &&
                challengesDetailController
                        .challengeDetails.value.challengeState ==
                    'IN_PROGRESS') {
              await challengesDetailController.onFetchJoinChallenge();
            }
            challengesDetailController.fetchEquipItem(
                challengesDetailController.challengeDetails.value.userItem!.id);
          },
          buttonText: 'equip_item'.tr(),
          buttonColor: skyBlueColor,
        ),
      ),
    ],
  );
}

void checkChallengeItemEquip(InventoryController controller, int itemId) {
  showAlert(
    title: 'confirm_1'.tr(),
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
        TextSpan(
          text: 'currently_equipped_item'.tr(),
          children: [
            TextSpan(
                text: 'challenge_exclusion'.tr(),
                style: const TextStyle(color: skyBlueColor)),
          ],
        ),
      ),
    ),
    actions: [
      Expanded(
        child: GazagoButton(
          onTap: () => Get.back(),
          buttonText: 'no'.tr(),
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
          buttonText: 'equip_item'.tr(),
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
          color: AppColorData.regular().colorBgTertiary,
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
                  child: Text(
                      controller.selectedType == 'STAMINA'
                          ? 'recover_stamina'.tr()
                          : 'repair_durability'.tr(),
                      style: AppTextStyleData.regular()
                          .koHeadingMediumSm
                          .copyWith(
                              color: AppColorData.regular().colorTextPrimary)),
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
                                  padding: EdgeInsets.only(
                                      bottom: 10.0.sp,
                                      left: 20.sp,
                                      right: 20.sp),
                                  child: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: AppColorData.regular()
                                          .colorBgSecondary,
                                      border: Border.all(
                                        width: 2.sp,
                                        color: Colors.black,
                                      ),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10.sp),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 14.0.sp,
                                          horizontal: 16.0.sp),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                              Center(
                                                child: Padding(
                                                  padding:
                                                      EdgeInsets.all(10.0.sp),
                                                  child:
                                                      item.itemImageUrl
                                                              .contains('.svg')
                                                          ? SvgPicture.network(
                                                              item.itemImageUrl,
                                                              placeholderBuilder: (BuildContext
                                                                      context) =>
                                                                  const Center(
                                                                      child: SizedBox.square(
                                                                          dimension:
                                                                              40,
                                                                          child:
                                                                              CircularProgressIndicator(color: skyBlueColor))),
                                                            )
                                                          : CachedNetworkImage(
                                                              imageUrl: item
                                                                  .itemImageUrl,
                                                              placeholder: (context,
                                                                      url) =>
                                                                  const Center(
                                                                      child: SizedBox.square(
                                                                          dimension:
                                                                              40,
                                                                          child:
                                                                              CircularProgressIndicator(color: skyBlueColor))),
                                                              errorWidget: (context,
                                                                      url,
                                                                      error) =>
                                                                  Image.asset(
                                                                      "assets/images/@temp_badge.png"),
                                                            ),
                                                ),
                                              ),
                                              if (item.amount! > 1)
                                                Positioned(
                                                  left: 8.sp,
                                                  top: 8.sp,
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color:
                                                          AppColorData.regular()
                                                              .colorBaseBalck,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              AppDoubleData
                                                                      .regular()
                                                                  .numberRadius4
                                                                  .sp),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 2.sp,
                                                              horizontal:
                                                                  6.0.sp),
                                                      child: Text(
                                                        item.amount! > 99
                                                            ? '99+'
                                                            : item.amount
                                                                .toString(),
                                                        style: AppTextStyleData
                                                                .regular()
                                                            .numBodySemiboldSm
                                                            .copyWith(
                                                                color: AppColorData
                                                                        .regular()
                                                                    .colorBaseWhite,
                                                                height: 1.1,
                                                                letterSpacing:
                                                                    -.1),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              Positioned(
                                                right: 8.sp,
                                                top: 8.sp,
                                                width: 18,
                                                height: 18,
                                                child: getItemGradeCircleIcon(
                                                    item.itemGrade),
                                              ),
                                              if (item.expiredDate != null)
                                                Positioned(
                                                  left: 8.sp,
                                                  bottom: 8.sp,
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                      horizontal: 6.sp,
                                                      vertical: 1.sp,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      color: controller
                                                                  .getRemainingDays(item
                                                                      .expiredDate!) ==
                                                              0
                                                          ? AppColorData
                                                                  .regular()
                                                              .colorBgWarningSubtle
                                                          : AppColorData
                                                                  .regular()
                                                              .colorPointBrandgray,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              AppDoubleData
                                                                      .regular()
                                                                  .numberRadius4
                                                                  .sp),
                                                    ),
                                                    child: Text(
                                                      'D-${controller.getRemainingDays(item.expiredDate!)}',
                                                      style: AppTextStyleData
                                                              .regular()
                                                          .koCaptionSemiboldMd
                                                          .copyWith(
                                                            color: AppColorData
                                                                    .regular()
                                                                .colorTextInverse,
                                                          ),
                                                    ),
                                                  ),
                                                ),
                                            ]),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  left: 22.0.sp),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Text(item.itemName,
                                                      style: AppTextStyleData
                                                              .regular()
                                                          .koBodyMediumLg
                                                          .copyWith(
                                                            color: AppColorData
                                                                    .regular()
                                                                .colorTextPrimary,
                                                          )),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 4.sp),
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          'recovery_repair_effect'
                                                              .tr(args: [
                                                            item.itemType ==
                                                                    'RECOVERY'
                                                                ? item.itemStat
                                                                    .recoveryStamina
                                                                    .toInt()
                                                                : item.itemStat
                                                                    .repairDurability
                                                                    .toInt()
                                                          ]),
                                                          style: AppTextStyleData
                                                                  .regular()
                                                              .koBodyMediumMd
                                                              .copyWith(
                                                                color: AppColorData
                                                                        .regular()
                                                                    .colorTextTertiary,
                                                              ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  3.0.sp),
                                                          child: Text(
                                                            item.itemType ==
                                                                    'RECOVERY'
                                                                ? 'recovery'
                                                                    .tr()
                                                                : 'repair'.tr(),
                                                            style: AppTextStyleData
                                                                    .regular()
                                                                .koBodyMediumMd
                                                                .copyWith(
                                                                  color: AppColorData
                                                                          .regular()
                                                                      .colorTextTertiary,
                                                                ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  if (controller
                                                          .getRepairUseItem(
                                                              item.id) !=
                                                      null)
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 8.0.sp),
                                                      child: SizedBox(
                                                        width: double.infinity,
                                                        child: Align(
                                                          alignment: Alignment
                                                              .centerRight,
                                                          child: ItemCounter(
                                                            item: controller
                                                                .getRepairUseItem(
                                                                    item.id),
                                                            callbackFnc: (item,
                                                                    updatedCount) =>
                                                                controller
                                                                    .updateSpendCount(
                                                                        item,
                                                                        updatedCount),
                                                            maxCount:
                                                                item.amount,
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
                        padding: EdgeInsets.only(
                            top: 20.0.sp, left: 20.0.sp, right: 20.0.sp),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              controller.selectedType == 'STAMINA'
                                  ? 'current_stamina_1'.tr()
                                  : 'current_durability'.tr(),
                              style: AppTextStyleData.regular()
                                  .koBodyMediumLg
                                  .copyWith(
                                    color:
                                        AppColorData.regular().colorTextPrimary,
                                  ),
                            ),
                            Text(
                              formatDecimalPlaces(
                                  controller.currentStat.value, 2),
                              style: AppTextStyleData.regular()
                                  .koBodyMediumLg
                                  .copyWith(
                                    color:
                                        AppColorData.regular().colorTextPrimary,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: 14.0.sp, left: 20.0.sp, right: 20.0.sp),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'recovery_amount'.tr(),
                              style: AppTextStyleData.regular()
                                  .koBodyMediumLg
                                  .copyWith(
                                    color:
                                        AppColorData.regular().colorTextPrimary,
                                  ),
                            ),
                            Text(
                              formatDecimalPlaces(
                                  controller.totalStat.toDouble(), 0),
                              style: AppTextStyleData.regular()
                                  .koBodyMediumLg
                                  .copyWith(
                                    color:
                                        AppColorData.regular().colorTextPrimary,
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
                            padding: EdgeInsets.only(
                                bottom: 1.0.sp, left: 20.0.sp, right: 20.0.sp),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  controller.selectedType.value == 'STAMINA'
                                      ? 'stamina_after_recovery'.tr()
                                      : 'durability_after_repair'.tr(),
                                  style: AppTextStyleData.regular()
                                      .koBodyMediumLg
                                      .copyWith(
                                        color: controller.resultStat.value >
                                                controller.currentStat.value
                                            ? controller.resultStat.value > 9999
                                                ? AppColorData.regular()
                                                    .colorTextWarning
                                                : AppColorData.regular()
                                                    .colorTextBrand
                                            : AppColorData.regular()
                                                .colorTextPrimary,
                                      ),
                                ),
                                Text(
                                  formatDecimalPlaces(
                                      controller.resultStat.value, 2),
                                  style: AppTextStyleData.regular()
                                      .koBodyMediumLg
                                      .copyWith(
                                        color: controller.resultStat.value >
                                                controller.currentStat.value
                                            ? controller.resultStat.value > 9999
                                                ? AppColorData.regular()
                                                    .colorTextWarning
                                                : AppColorData.regular()
                                                    .colorTextBrand
                                            : AppColorData.regular()
                                                .colorTextPrimary,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          controller.resultStat.value > 9999
                              ? Padding(
                                  padding:
                                      EdgeInsets.symmetric(vertical: 13.0.sp),
                                  child: StyledText(
                                    'max_recovery_9999'.tr(),
                                    fontSize: 14,
                                    fontWeight: 500,
                                    lineHeight: 14,
                                    color: const Color(0xFFFF2222),
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
                                    buttonText: 'cancel'.tr(),
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
                                      if (controller.resultStat.value <= 9999 &&
                                          controller.totalStat > 0) {
                                        if (controller.selectedType.value ==
                                            'STAMINA') {
                                          if (controller.exerciseState.value !=
                                              ExerciseState.ongoing) {
                                            Get.back();
                                            showAutoRechargeStaminaAlert(
                                                controller);
                                          } else {
                                            Get.back();
                                            controller
                                                .confirmRecoveryOrRepairStat(
                                                    controller
                                                        .selectedType.value);
                                          }
                                        } else {
                                          Get.back();
                                          controller
                                              .confirmRecoveryOrRepairStat(
                                                  controller
                                                      .selectedType.value);
                                        }
                                      }
                                      return;
                                    },
                                    buttonText:
                                        controller.selectedType == 'STAMINA'
                                            ? 'recover_stamina_button'.tr()
                                            : 'repair_durability_button'.tr(),
                                    textColor: Colors.black,
                                    buttonColor:
                                        controller.resultStat.value <= 9999 &&
                                                controller.totalStat > 0
                                            ? skyBlueColor
                                            : const Color(0xFF11A4AD),
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
  HomeMenuController homeMenuController = Get.isRegistered<HomeMenuController>()
      ? Get.find<HomeMenuController>()
      : Get.put(HomeMenuController());
  ShopController shopController = Get.isRegistered<ShopController>()
      ? Get.find<ShopController>()
      : Get.put(ShopController());
  showAlert(
    title:
        itemType == 'STAMINA' ? 'no_recovery_item'.tr() : 'no_repair_item'.tr(),
    contentWidget: Padding(
      padding: EdgeInsets.only(top: 20.0.sp, bottom: 40.sp),
      child: Text(
        'purchase_item_from_shop'.tr(),
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
          buttonText: 'cancel'.tr(),
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
          buttonText: 'go_to_shop'.tr(),
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
                    padding: EdgeInsets.symmetric(
                        horizontal: 20.0.sp, vertical: 30.sp),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: 14.0.sp),
                          child: StyledText(
                            'enter_participation_code_1'.tr(),
                            fontSize: 20,
                            lineHeight: 21,
                            fontWeight: 500,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 35.0.sp),
                          child: StyledText(
                            'participation_code_required'.tr(),
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
                              hintText: 'enter_participation_code'.tr(),
                              hintStyle: const TextStyle(
                                color: deepGrayColor,
                                fontSize: 18,
                                height: 20 / 18,
                                fontWeight: FontWeight.w500,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(10.0)),
                                borderSide: BorderSide(
                                    width: 2,
                                    color: controller.errorMessage.value == ''
                                        ? skyBlueColor
                                        : const Color(0xFFFF4C4C)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(10.0)),
                                borderSide: BorderSide(
                                    width: 2,
                                    color: controller.errorMessage.value == ''
                                        ? Colors.transparent
                                        : const Color(0xFFFF4C4C)),
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 2,
                                    color: controller.errorMessage.value == ''
                                        ? Colors.transparent
                                        : const Color(0xFFFF4C4C)),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(10.0)),
                              ),
                            ),
                            controller: controller.codeTextController,
                            textInputAction: TextInputAction.go,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[a-zaA-Z0-9]')),
                              LengthLimitingTextInputFormatter(6),
                              TextInputFormatter.withFunction(
                                  (oldValue, newValue) {
                                return newValue.copyWith(
                                    text: newValue.text.toUpperCase());
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
                              child: StyledText(controller.errorMessage.value,
                                  fontSize: 14,
                                  color: Colors.redAccent,
                                  fontWeight: 500,
                                  lineHeight: 15),
                            ),
                          );
                        }),
                        Padding(
                          padding: EdgeInsets.only(top: 5.0.sp),
                          child: Row(
                            children: [
                              Expanded(
                                child: GazagoButton(
                                  onTap: () =>
                                      controller.closeParticipateInCodeAlert(),
                                  buttonText: 'cancel'.tr(),
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
                                  buttonText: 'confirm'.tr(),
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
                Padding(
                  padding: const EdgeInsets.only(
                    top: 18.0,
                    bottom: 30,
                  ),
                  child: StyledText(
                    'gajago_fair_play'.tr(),
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
                    buttonText: 'acknowledged'.tr(),
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
    title: 'notification'.tr(),
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
          text: 'account_blocked'.tr(),
        ),
      ),
    ),
    actions: [
      Expanded(
        child: GazagoButton(
          buttonText: 'confirm'.tr(),
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
              'stamina_recovery_confirmation'.tr(),
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
          buttonText: 'cancel'.tr(),
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
            controller
                .confirmRecoveryOrRepairStat(controller.selectedType.value);
          },
          buttonText: 'confirm'.tr(),
          buttonColor: skyBlueColor,
        ),
      ),
    ],
  );
}

void crewJoinInfoAlert(CrewModel crew) async {
  await showAlert(
    title: 'crew_join_guide'.tr(),
    contentWidget: Padding(
      padding: EdgeInsets.only(top: 22.sp, bottom: 49.sp),
      child: StyledText(
        'crew_join_confirmation'.tr(),
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
          buttonText: 'no'.tr(),
          textColor: Colors.white,
          buttonColor: popupBgColor,
        ),
      ),
      SizedBox(
        width: 9.sp,
      ),
      Expanded(
        child: GazagoButton(
          buttonText: 'yes'.tr(),
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
      child: StyledText(
        'already_participating_in_challenge'.tr(),
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
          buttonText: 'confirm'.tr(),
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
            foregroundImage: (crew.iconImageUrl == null ||
                    crew.iconImageUrl == '')
                ? Image.asset(
                    'assets/images/ic_launcher.png',
                    width: 50.sp,
                  ).image
                : crew.iconImageUrl!.contains('.svg')
                    ? sp.Svg(crew.iconImageUrl!, source: sp.SvgSource.network)
                        as ImageProvider
                    : CachedNetworkImageProvider(
                        crew.iconImageUrl!,
                        headers: imageNetworkHeader,
                      ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20.0.sp),
            child: StyledText(
              'welcome_to_crew'.tr(),
              fontWeight: 500,
              fontSize: 22,
              lineHeight: 22,
              letterSpacing: -.1,
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20.0.sp),
            child: StyledText(
              'welcome_to_crew_redirect'.tr(),
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
          buttonText: 'confirm'.tr(),
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
            foregroundImage:
                (controller.myCrew.value!['crew'].iconImageUrl == null ||
                        controller.myCrew.value!['crew'].iconImageUrl == '')
                    ? Image.asset(
                        'assets/images/ic_launcher.png',
                        width: 50.sp,
                      ).image
                    : controller.myCrew.value!['crew'].iconImageUrl!
                            .contains('.svg')
                        ? sp.Svg(controller.myCrew.value!['crew'].iconImageUrl!,
                            source: sp.SvgSource.network) as ImageProvider
                        : CachedNetworkImageProvider(
                            controller.myCrew.value!['crew'].iconImageUrl!,
                            headers: imageNetworkHeader,
                          ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20.0.sp),
            child: StyledText(
              'crew_creation_celebration'.tr(),
              fontWeight: 500,
              fontSize: 22,
              lineHeight: 22,
              letterSpacing: -.1,
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20.0.sp),
            child: StyledText(
              'crew_creation_celebration_redirect'.tr(),
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
          buttonText: 'confirm'.tr(),
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
    title: 'insufficient_funds'.tr(),
    contentWidget: Padding(
      padding: EdgeInsets.only(top: 22.sp, bottom: 49.sp),
      child: StyledText(
        'free_creation_via_sharing'.tr(),
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
          buttonText: 'close'.tr(),
          textColor: Colors.white,
          buttonColor: popupBgColor,
        ),
      ),
      // SizedBox(
      //   width: 9.sp,
      // ),
      // Expanded(
      //   child: GazagoButton(
      //     buttonText: 'recharge_1'.tr(),
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
            foregroundImage: (controller.selectedCrew.value!.iconImageUrl ==
                        null ||
                    controller.selectedCrew.value!.iconImageUrl == '')
                ? Image.asset(
                    'assets/images/ic_launcher.png',
                    width: 50.sp,
                  ).image
                : controller.selectedCrew.value!.iconImageUrl!.contains('.svg')
                    ? sp.Svg(controller.selectedCrew.value!.iconImageUrl!,
                        source: sp.SvgSource.network) as ImageProvider
                    : CachedNetworkImageProvider(
                        controller.selectedCrew.value!.iconImageUrl!,
                        headers: imageNetworkHeader,
                      ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20.0.sp),
            child: StyledText(
              'challenge_completion_regret'.tr(),
              fontWeight: 500,
              fontSize: 22,
              lineHeight: 22,
              letterSpacing: -.1,
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20.0.sp),
            child: StyledText(
              'crew_relay_auto_ended'.tr(),
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
          buttonText: 'confirm'.tr(),
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
                foregroundImage: (controller.selectedCrew.value!.iconImageUrl ==
                            null ||
                        controller.selectedCrew.value!.iconImageUrl == '')
                    ? Image.asset(
                        'assets/images/ic_launcher.png',
                        width: 50.sp,
                      ).image
                    : controller.selectedCrew.value!.iconImageUrl!
                            .contains('.svg')
                        ? sp.Svg(controller.selectedCrew.value!.iconImageUrl!,
                            source: sp.SvgSource.network) as ImageProvider
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
            child: StyledText(
              'restrict_crew_recruitment'.tr(),
              fontWeight: 500,
              fontSize: 22,
              lineHeight: 30,
              letterSpacing: -.1,
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20.0.sp),
            child: StyledText(
              'restrict_crew_recruitment_confirmation'.tr(),
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
          buttonText: 'no'.tr(),
          textColor: Colors.white,
          buttonColor: popupBgColor,
        ),
      ),
      SizedBox(
        width: 9.sp,
      ),
      Expanded(
        child: GazagoButton(
          buttonText: 'yes'.tr(),
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
                foregroundImage: (controller.selectedCrew.value!.iconImageUrl ==
                            null ||
                        controller.selectedCrew.value!.iconImageUrl == '')
                    ? Image.asset(
                        'assets/images/ic_launcher.png',
                        width: 50.sp,
                      ).image
                    : controller.selectedCrew.value!.iconImageUrl!
                            .contains('.svg')
                        ? sp.Svg(controller.selectedCrew.value!.iconImageUrl!,
                            source: sp.SvgSource.network) as ImageProvider
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
            child: StyledText(
              'unrestrict_crew_recruitment'.tr(),
              fontWeight: 500,
              fontSize: 22,
              lineHeight: 30,
              letterSpacing: -.1,
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20.0.sp),
            child: StyledText(
              'unrestrict_crew_recruitment_confirmation'.tr(),
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
          buttonText: 'no'.tr(),
          textColor: Colors.white,
          buttonColor: popupBgColor,
        ),
      ),
      SizedBox(
        width: 9.sp,
      ),
      Expanded(
        child: GazagoButton(
          buttonText: 'yes'.tr(),
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
          buttonText: 'confirm'.tr(),
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
            foregroundImage:
                (controller.myCrew.value!['crew'].iconImageUrl == null ||
                        controller.myCrew.value!['crew'].iconImageUrl == '')
                    ? Image.asset(
                        'assets/images/ic_launcher.png',
                        width: 50.sp,
                      ).image
                    : controller.myCrew.value!['crew'].iconImageUrl!
                            .contains('.svg')
                        ? sp.Svg(controller.myCrew.value!['crew'].iconImageUrl!,
                            source: sp.SvgSource.network) as ImageProvider
                        : CachedNetworkImageProvider(
                            controller.myCrew.value!['crew'].iconImageUrl!,
                            headers: imageNetworkHeader,
                          ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20.0.sp),
            child: StyledText(
              'challenge_ended_announcement'.tr(),
              fontWeight: 500,
              fontSize: 22,
              lineHeight: 22,
              letterSpacing: -.1,
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20.0.sp),
            child: StyledText(
              'challenge_completion_announcement'.tr(),
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
          buttonText: 'confirm'.tr(),
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
                    ? sp.Svg(iconList[i].imageUrl, source: sp.SvgSource.network)
                        as ImageProvider
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
                  border: Border.all(
                      color:
                          iconList[i].id == controller.selectedMarkIconId.value
                              ? skyBlueColor
                              : Colors.transparent,
                      width: 2),
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
                          child: StyledText(
                            'create_crew'.tr(),
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
                          TextSpan(
                            text: 'create_crew_description'.tr(),
                            children: [
                              TextSpan(
                                  text: 'three_blocks_reward'.tr(),
                                  style: TextStyle(color: skyBlueColor)),
                              TextSpan(
                                  text: 'three_blocks_reward_description'.tr()),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 4.0.sp),
                          child: StyledText(
                            'crew_creation_cost'.tr(),
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
                              padding: EdgeInsets.only(
                                  top: 33.0.sp, bottom: 8.0.sp, left: 5.sp),
                              child: StyledText(
                                'crew_mark'.tr(),
                                fontSize: 16,
                                lineHeight: 18,
                                color: lightGrayColor,
                                fontWeight: 500,
                              ),
                            ),
                            Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 16.0.sp, horizontal: 20.sp),
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
                              padding: EdgeInsets.only(
                                  top: 22.0.sp, bottom: 8.sp, left: 5.sp),
                              child: StyledText(
                                'crew_name'.tr(),
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
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                hintText: 'crew_name_input'.tr(),
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
                              onChanged: (name) =>
                                  controller.updateCrewName(name),
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
                                border: Border.all(
                                    width: 2.sp, color: skyBlueColor),
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
                                child: Center(
                                  child: Column(
                                    children: [
                                      StyledText(
                                        'create_crew_1'.tr(),
                                        fontSize: 18,
                                        lineHeight: 18,
                                        fontWeight: 600,
                                        color: Colors.white,
                                      ),
                                      const StyledText(
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
                          buttonText: 'free_crew_creation'.tr(),
                          onTap: () =>
                              controller.handleCreateCrewType('INVITE'),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8.0.sp),
                    child: GazagoButton(
                      onTap: () => Get.back(),
                      buttonText: 'cancel'.tr(),
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
                        controller.challengeDetails.value
                                    .challengeActivationType ==
                                'CREW'
                            ? 'free_crew_creation_via_kakao'.tr()
                            : 'free_challenge_entry_via_kakao'.tr(),
                        textAlign: TextAlign.center,
                        fontWeight: 500,
                        fontSize: 20,
                        lineHeight: 30,
                      ),
                      StyledText(
                        'self_share_not_allowed'.tr(),
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
                          buttonText: 'close'.tr(),
                          textColor: Colors.white,
                          buttonColor: popupBgColor,
                        ),
                      ),
                      SizedBox(
                        width: 9.sp,
                      ),
                      Expanded(
                        child: GazagoButton(
                          buttonText: 'share_link'.tr(),
                          onTap: () async {
                            Get.back();

                            if (controller.challengeDetails.value
                                    .challengeActivationType ==
                                'CREW') {
                              controller.shareChallenge(
                                  challengeType: ChallengeType.crew,
                                  shareSource: ShareSource.createCrew);
                              await Future.delayed(const Duration(seconds: 2));
                              // askSharedCompleteDialog(controller, challengeType: ChallengeType.crew, shareSource: ShareSource.createCrew);
                            } else {
                              if (controller
                                      .challengeDetails.value.challengeType ==
                                  'PAYMENT') {
                                controller.shareChallenge(
                                    challengeType: ChallengeType.payment,
                                    shareSource: ShareSource.mirae);
                                await Future.delayed(
                                    const Duration(seconds: 2));
                                // askSharedCompleteDialog(controller, challengeType: ChallengeType.payment, shareSource: ShareSource.mirae);
                              } else {
                                controller.shareChallenge(
                                    challengeType: ChallengeType.payment,
                                    shareSource: ShareSource.spot);
                                await Future.delayed(
                                    const Duration(seconds: 2));
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

void askSharedCompleteDialog(ChallengesDetailController controller,
    {required ChallengeType challengeType, required ShareSource shareSource}) {
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
                        StyledText(
                          'share_complete_confirmation'.tr(),
                          textAlign: TextAlign.center,
                          fontWeight: 500,
                          fontSize: 20,
                          lineHeight: 30,
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 12.0.sp),
                          child: StyledText(
                            controller.challengeDetails.value
                                        .challengeActivationType ==
                                    'CREW'
                                ? 'free_crew_creation_on_complete'.tr()
                                : 'free_challenge_entry_on_complete'.tr(),
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
                        buttonText: 'cancel'.tr(),
                        textColor: Colors.white,
                        buttonColor: popupBgColor,
                      ),
                    ),
                    SizedBox(
                      width: 9.sp,
                    ),
                    Expanded(
                      child: GazagoButton(
                        buttonText: 'complete_action'.tr(),
                        onTap: () {
                          Get.back();
                          controller.validateKakaoShareResult(
                              challengeType: challengeType,
                              shareSource: shareSource);
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

void unableShareMyselfDialog(ChallengesDetailController controller,
    {required ChallengeType challengeType, required ShareSource shareSource}) {
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
                        'self_share_prohibited'.tr(),
                        textAlign: TextAlign.center,
                        fontWeight: 500,
                        fontSize: 20,
                        lineHeight: 30,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 17.0.sp),
                        child: StyledText(
                          'self_share_invalid'.tr(),
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
                      buttonText: 'close'.tr(),
                      textColor: Colors.white,
                      buttonColor: popupBgColor,
                    ),
                  ),
                  SizedBox(
                    width: 9.sp,
                  ),
                  Expanded(
                    child: GazagoButton(
                      buttonText: 'reshare_link'.tr(),
                      onTap: () async {
                        Get.back();
                        controller.shareChallenge(
                            challengeType: challengeType,
                            shareSource: shareSource);
                        await Future.delayed(const Duration(seconds: 2));
                        askSharedCompleteDialog(controller,
                            challengeType: challengeType,
                            shareSource: shareSource);
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

void unableSharedHistoryDialog(ChallengesDetailController controller,
    {required ChallengeType challengeType, required ShareSource shareSource}) {
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
                        'share_verification_failed'.tr(),
                        textAlign: TextAlign.center,
                        fontWeight: 500,
                        fontSize: 20,
                        lineHeight: 30,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 17.0.sp),
                        child: StyledText(
                          'share_history_not_found'.tr(),
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
                      buttonText: 'close'.tr(),
                      textColor: Colors.white,
                      buttonColor: popupBgColor,
                    ),
                  ),
                  SizedBox(
                    width: 9.sp,
                  ),
                  Expanded(
                    child: GazagoButton(
                      buttonText: 'reshare_link'.tr(),
                      onTap: () async {
                        Get.back();
                        controller.shareChallenge(
                            challengeType: challengeType,
                            shareSource: shareSource);
                        await Future.delayed(const Duration(seconds: 2));
                        askSharedCompleteDialog(controller,
                            challengeType: challengeType,
                            shareSource: shareSource);
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
                      StyledText(
                        'invite_to_crew_challenge'.tr(),
                        textAlign: TextAlign.center,
                        fontWeight: 500,
                        fontSize: 20,
                        lineHeight: 30,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 12.0.sp),
                        child: StyledText(
                          'invite_link_requirement'.tr(),
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
                      buttonText: 'close'.tr(),
                      textColor: Colors.white,
                      buttonColor: popupBgColor,
                    ),
                  ),
                  SizedBox(
                    width: 9.sp,
                  ),
                  Expanded(
                    child: GazagoButton(
                      buttonText: 'share_link'.tr(),
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
    title: 'nickname_change_confirmation'.tr(),
    contentWidget: Center(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 14.sp, bottom: 30.sp),
            child: StyledText(
              'nickname_change_limit'.tr(),
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
          buttonText: 'cancel'.tr(),
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
          buttonText: 'change_nickname'.tr(),
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
                      child: StyledText(
                        'identity_verification'.tr(),
                        fontSize: 20,
                        lineHeight: 20,
                        fontWeight: 500,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 12.0.sp),
                      child: StyledText(
                        'identity_verification_required_for_challenge'.tr(),
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
                              buttonText: 'close'.tr(),
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
                              buttonText: 'confirm'.tr(),
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
                      child: StyledText(
                        'identity_verification'.tr(),
                        fontSize: 20,
                        lineHeight: 20,
                        fontWeight: 500,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 12.0.sp),
                      child: StyledText(
                        'identity_verification_required_for_purchase'.tr(),
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
                              buttonText: 'close'.tr(),
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
                              buttonText: 'confirm'.tr(),
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
                          controller.isShortTokenBalance.value
                              ? 'insufficient_balance_2'.tr()
                              : 'challenge_participation_confirmation'.tr(),
                          color: controller.isShortTokenBalance.value
                              ? dangerColor
                              : Colors.white,
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
                          text: formatDecimalPlaces(
                              controller.challengeDetails.value.entryFee!
                                  .toDouble(),
                              0),
                          children: const [
                            TextSpan(
                                text: 'TIK',
                                style: TextStyle(fontWeight: FontWeight.w400)),
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
                  padding:
                      EdgeInsets.only(left: 20.sp, right: 20.sp, bottom: 20.sp),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          StyledText(
                            'balance'.tr(),
                            fontSize: 18,
                            fontWeight: 500,
                            letterSpacing: -.1,
                            color: controller.isShortTokenBalance.value
                                ? dangerColor
                                : Colors.white,
                          ),
                          Row(
                            children: [
                              StyledText(
                                formatDecimalPlaces(
                                    double.parse(controller
                                        .walletMasterController
                                        .tik
                                        .value
                                        .uiAmountString!),
                                    0),
                                fontSize: 20,
                                fontWeight: 700,
                                letterSpacing: -.1,
                                color: controller.isShortTokenBalance.value
                                    ? dangerColor
                                    : Colors.white,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 4.0.sp),
                                child: StyledText(
                                  'TIK',
                                  fontSize: 20,
                                  fontWeight: 400,
                                  letterSpacing: -.1,
                                  color: controller.isShortTokenBalance.value
                                      ? dangerColor
                                      : Colors.white,
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
                                'non_refundable_participation_fee'.tr(),
                                fontSize: 14,
                                color: controller.isShortTokenBalance.value
                                    ? dangerColor
                                    : skyBlueColor,
                              )
                            : Container(),
                      ),
                      Row(
                        children: [
                          if (!controller.isShortTokenBalance.value)
                            Expanded(
                              child: GazagoButton(
                                onTap: () => controller.onFetchJoinChallenge(),
                                buttonText: 'participate_in_challenge'.tr(),
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
                              buttonText: 'free_participation'.tr(),
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
                          buttonText: 'cancel'.tr(),
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

void showChallengeLandingPopup(
    ChallengesDetailController controller, ChallengeLandingModel landingInfo) {
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
                    placeholder: (context, url) => const Center(
                        child: SizedBox.square(
                            dimension: 40,
                            child: CircularProgressIndicator(
                                color: skyBlueColor))),
                    errorWidget: (context, url, error) => const Center(
                        child: SizedBox.square(
                            dimension: 40,
                            child: CircularProgressIndicator(
                                color: skyBlueColor))),
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
                        child: Center(
                          child: StyledText(
                            'close'.tr(),
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

void showModalWebview(controller, context,
    {String? title, String linkUrl = ''}) {
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
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0)),
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
                  gestureRecognizers: Set()
                    ..add(Factory<VerticalDragGestureRecognizer>(
                        () => VerticalDragGestureRecognizer())),
                  initialUrlRequest: URLRequest(url: WebUri(linkUrl)),
                  onWebViewCreated: (InAppWebViewController webviewController) {
                    inAppWebViewController = webviewController;
                  },
                  onProgressChanged:
                      (InAppWebViewController webviewController, int progress) {
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
          buttonText: 'confirm'.tr(),
          buttonColor: skyBlueColor,
        ),
      ),
    ],
  );
}

void showNeedVerificationExchangeAlert() {
  showAlert(
    title: 'verification_required'.tr(),
    contentText: 'identity_verification_redirect'.tr(),
    actions: [
      Expanded(
        child: GazagoButton(
          onTap: () => moveToVerification(),
          buttonText: 'confirm'.tr(),
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
      child: Column(
        children: [
          StyledText(
            'underage_verification_restriction'.tr(),
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
          buttonText: 'confirm'.tr(),
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
            child: StyledText(
              'minimum_stik_transfer'.tr(),
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
          buttonText: 'confirm'.tr(),
          buttonColor: skyBlueColor,
        ),
      ),
    ],
  );
}

void showRefetchGetSpendingWalletAlert() {
  WalletMasterController walletMasterController =
      Get.isRegistered<WalletMasterController>()
          ? Get.find<WalletMasterController>()
          : Get.put(WalletMasterController());
  showAlert(
    allowMultipleBottomSheet: true,
    contentWidget: Padding(
      padding: EdgeInsets.only(top: 20.0.sp, bottom: 40.sp),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 20.0.sp),
            child: StyledText(
              'wallet_info_retrieval_failed'.tr(),
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
          buttonText: 'confirm'.tr(),
          buttonColor: skyBlueColor,
        ),
      ),
    ],
  );
}

Future<void> showFailureGetSpendingWalletAlert() async {
  WalletMasterController walletMasterController =
      Get.isRegistered<WalletMasterController>()
          ? Get.find<WalletMasterController>()
          : Get.put(WalletMasterController());
  showAlert(
    allowMultipleBottomSheet: true,
    contentWidget: Padding(
      padding: EdgeInsets.only(top: 0.0.sp, bottom: 32.sp),
      child: Column(
        children: [
          iconPopupExclamationMark,
          Padding(
            padding: EdgeInsets.only(top: 16.0.sp),
            child: Text('wallet_info_retrieval_error'.tr(),
                style: AppTextStyleData.regular()
                    .koHeadingMediumSm
                    .copyWith(color: AppColorData.regular().colorTextPrimary)),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20.0.sp),
            child: Text(
              'temporary_wallet_error'.tr(),
              style: AppTextStyleData.regular()
                  .koBodyMediumLg
                  .copyWith(color: AppColorData.regular().colorTextPrimary),
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
          buttonText: 'cancel'.tr(),
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
            walletMasterController.getSpendingWalletBalances();
          },
          buttonText: 'retry_wallet_retrieval'.tr(),
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
            padding: EdgeInsets.only(
                left: 20.0.sp, right: 20.sp, top: 36.0.sp, bottom: 24.sp),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 16.sp),
                  child: Text(
                    'allow_app_tracking_for_ads'.tr(),
                    style:
                        AppTextStyleData.regular().koHeadingSemiboldSm.copyWith(
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
                      'allow_tracking_instructions'.tr(),
                      style: AppTextStyleData.regular().koBodyMediumMd.copyWith(
                            color: AppColorData.regular().colorTextSecondary,
                          ),
                      textAlign: TextAlign.center,
                    )),
                Padding(
                    padding: EdgeInsets.only(top: 8.0.sp, bottom: 24.sp),
                    child: InkWell(
                      onTap: () {
                        Get.toNamed(Routes.webView, arguments: {
                          'linkUrl':
                              'https://ltechpin.notion.site/883801b0ca0e465d976f9a0062d080df?pvs=4'
                        });
                      },
                      child: Text(
                        'tracking_permission_not_found'.tr(),
                        style: AppTextStyleData.regular()
                            .koBodyMediumMd
                            .copyWith(
                              color: AppColorData.regular().colorTextTertiary,
                              decoration: TextDecoration.underline,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    )),
                GazagoButton(
                  onTap: () {
                    controller.moveAppSettings();
                  },
                  buttonText: 'confirm'.tr(),
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
            padding: EdgeInsets.only(
                left: 20.0.sp, right: 20.sp, top: 36.0.sp, bottom: 24.sp),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 16.sp),
                  child: Text(
                    'allow_app_tracking_for_ads'.tr(),
                    style:
                        AppTextStyleData.regular().koHeadingSemiboldSm.copyWith(
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
                      'alternative_tracking_instructions'.tr(),
                      style: AppTextStyleData.regular().koBodyMediumMd.copyWith(
                            color: AppColorData.regular().colorTextSecondary,
                          ),
                      textAlign: TextAlign.center,
                    )),
                Padding(
                    padding: EdgeInsets.only(top: 8.0.sp, bottom: 24.sp),
                    child: InkWell(
                      onTap: () {
                        Get.toNamed(Routes.webView, arguments: {
                          'linkUrl':
                              'https://ltechpin.notion.site/883801b0ca0e465d976f9a0062d080df?pvs=4'
                        });
                      },
                      child: Text(
                        'tracking_permission_not_found'.tr(),
                        style: AppTextStyleData.regular()
                            .koBodyMediumMd
                            .copyWith(
                              color: AppColorData.regular().colorTextTertiary,
                              decoration: TextDecoration.underline,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    )),
                GazagoButton(
                  onTap: () {
                    controller.moveAppSettings();
                    // Get.back();
                  },
                  buttonText: 'confirm'.tr(),
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
  ActivityController controller = Get.isRegistered<ActivityController>()
      ? Get.find<ActivityController>()
      : Get.put(ActivityController());
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
                borderRadius: BorderRadius.circular(
                    AppDoubleData.regular().numberRadius20),
              ),
              child: Padding(
                padding: EdgeInsets.only(
                    left: 20.0.sp, right: 20.sp, bottom: 32.sp, top: 36.sp),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    StyledText(
                      'gps_troubleshooting'.tr(),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                        buttonText: 'confirm'.tr(),
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
              'poor_gps_signal'.tr(),
              fontWeight: 500,
              fontSize: 20,
              lineHeight: 28,
              textAlign: TextAlign.center,
            ),
          ),
          StyledText(
            'gps_issue_solution1'.tr(),
            fontWeight: 500,
            fontSize: 16,
            lineHeight: 22,
            textAlign: TextAlign.center,
          ),
          Padding(
            padding: EdgeInsets.only(top: 12.0.sp),
            child: StyledText(
              'gps_issue_solution2'.tr(),
              fontWeight: 500,
              fontSize: 16,
              lineHeight: 22,
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 12.0.sp),
            child: StyledText(
              'gps_issue_solution3'.tr(),
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
          buttonText: 'confirm'.tr(),
          buttonColor: skyBlueColor,
        ),
      ),
    ],
  );
}

void requireShowEmailAlert() {
  showAlert(
    allowMultipleBottomSheet: true,
    title: 'email_verification_failed'.tr(),
    contentWidget: Padding(
      padding: EdgeInsets.only(top: 20.0.sp, bottom: 32.sp),
      child: StyledText(
        'email_verification_instructions'.tr(),
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
          buttonText: 'confirm'.tr(),
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
            'send_to_go_wallet_confirmation'.tr(),
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
                    'free_transfer_fee'.tr(),
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
                    'go_wallet_item_visibility'.tr(),
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
          buttonText: 'cancel'.tr(),
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
          buttonText: 'send_item'.tr(),
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
            'equipped_item_transfer_restriction'.tr(),
            style: AppTextStyleData.regular().koHeadingSemiboldSm.copyWith(
                  color: AppColorData.regular().colorTextPrimary,
                ),
            textAlign: TextAlign.center,
          ),
          Padding(
            padding: EdgeInsets.only(top: 8.sp, bottom: 28.sp),
            child: Text(
              'unequip_item_and_retry'.tr(),
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
          buttonText: 'cancel'.tr(),
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
          buttonText: 'go_to_my_equipment'.tr(),
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
            'incompatible_item'.tr(),
            style: AppTextStyleData.regular().koHeadingSemiboldSm.copyWith(
                  color: AppColorData.regular().colorTextPrimary,
                ),
            textAlign: TextAlign.center,
          ),
          Padding(
            padding: EdgeInsets.only(top: 8.sp, bottom: 28.sp),
            child: Text(
              'reselect_item'.tr(),
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
          buttonText: 'cancel'.tr(),
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
          buttonText: 'choose_item_again'.tr(),
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
              'send_request_complete_1'.tr(),
              style: AppTextStyleData.regular().koHeadingMediumSm.copyWith(
                    color: AppColorData.regular().colorTextPrimary,
                  ),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20.sp, bottom: 32.sp),
            child: Text(
              isOnChain
                  ? 'item_equippable_after_send'.tr()
                  : 'item_visible_in_staika_wallet'.tr(),
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
            Get.until((route) =>
                Get.currentRoute == Routes.walletNftList ||
                Get.currentRoute == Routes.home);
            Get.bus.fire(RefreshNftListEvent());
          },
          buttonText: 'confirm'.tr(),
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
            'blockchain_network_error'.tr(),
            style: AppTextStyleData.regular().koHeadingMediumSm.copyWith(
                  color: AppColorData.regular().colorTextPrimary,
                ),
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 20.sp, bottom: 32.sp),
          child: Text(
            'retry_later_2'.tr(),
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
          buttonText: 'confirm'.tr(),
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
          'check_transfer_fee'.tr(),
          style: AppTextStyleData.regular().koHeadingMediumSm.copyWith(
                color: AppColorData.regular().colorTextPrimary,
              ),
          textAlign: TextAlign.center,
        ),
        Padding(
          padding: EdgeInsets.only(top: 20.sp, bottom: 32.sp),
          child: Text(
            'nft_transfer_fee_confirmation'.tr(),
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
          buttonText: 'confirm'.tr(),
          buttonColor: AppColorData.regular().colorBgInteractivePrimary,
        ),
      ),
    ],
  );
}

void showSendToStaikaConfirmAlert(
    InventoryController controller, InventoryItemModel item) {
  showAlert(
    title: 'send_to_staika_wallet_confirmation'.tr(),
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
            padding: EdgeInsets.only(
                top: AppDoubleData.regular().numberSpacing12.sp),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'go_accumulation'.tr(),
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
            padding: EdgeInsets.only(
                top: AppDoubleData.regular().numberSpacing12.sp),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'durability_resistance'.tr(),
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
            padding: EdgeInsets.only(
                top: AppDoubleData.regular().numberSpacing12.sp),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'stamina_resistance'.tr(),
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
            padding: EdgeInsets.only(
                top: AppDoubleData.regular().numberSpacing12.sp),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'luck'.tr(),
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
            padding: EdgeInsets.only(
                top: AppDoubleData.regular().numberSpacing12.sp),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'current_durability'.tr(),
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
          padding:
              EdgeInsets.only(top: AppDoubleData.regular().numberSpacing12.sp),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'transfer_fee'.tr(),
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
                'free_transfer_fee'.tr(),
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
                    'staika_wallet_item_invisibility'.tr(),
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
          buttonText: 'cancel'.tr(),
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
          buttonText: 'send_item'.tr(),
          buttonColor: AppColorData.regular().colorBgInteractivePrimary,
        ),
      ),
    ],
  );
}

void showConfirmCollectionRewardAlert(CollectionDetailController controller) {
  showAlert(
    isScrollControlled: true,
    title: 'reward_claim_confirmation'.tr(),
    contentWidget: Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 30.sp),
          child: controller.renderCollectionImage(
              controller.detailCollection.value.gatheringReward),
        ),
        Padding(
          padding: EdgeInsets.only(
              top: controller.detailCollection.value.gatheringReward.type ==
                          'ITEM' ||
                      controller.detailCollection.value.gatheringReward.type ==
                          'BADGE'
                  ? 16.sp
                  : 10.0.sp),
          child: Container(
              decoration: BoxDecoration(
                color: AppColorData.regular().colorBgPrimary,
                borderRadius: BorderRadius.all(
                  Radius.circular(AppDoubleData.regular().numberRadius8),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(
                    left: 16.0.sp, right: 16.sp, top: 9.sp, bottom: 12.sp),
                child: Text(
                  controller.gatheringRewardName(
                      controller.detailCollection.value.gatheringReward),
                  style: AppTextStyleData.regular().koBodyMediumLg.copyWith(
                        color: AppColorData.regular().colorTextPrimary,
                      ),
                ),
              )),
        ),
        Padding(
            padding: EdgeInsets.only(top: 16.sp, bottom: 32.sp),
            child: Text(
              'reward_collection_material_loss'.tr(),
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
          buttonText: 'cancel'.tr(),
          textColor: Colors.white,
          buttonColor: popupBgColor,
        ),
      ),
      SizedBox(
        width: 9.sp,
      ),
      Expanded(
        child: GazagoButton(
          buttonText: 'claim_reward'.tr(),
          onTap: () async {
            Get.back();
            controller
                .getCollectionReward(controller.detailCollection.value.id);
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
    title: 'reward_obtained'.tr(),
    contentWidget: Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 30.sp),
          child: controller.renderCollectionImage(responseData),
        ),
        Padding(
          padding: EdgeInsets.only(
              top: responseData.type == 'ITEM' || responseData.type == 'BADGE'
                  ? 16.sp
                  : 10.0.sp),
          child: Container(
              decoration: BoxDecoration(
                color: AppColorData.regular().colorBgPrimary,
                borderRadius: BorderRadius.all(
                  Radius.circular(AppDoubleData.regular().numberRadius8),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(
                    left: 16.0.sp, right: 16.sp, top: 9.sp, bottom: 12.sp),
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
              children: responseData.type == 'BADGE' ||
                      responseData.type == 'ITEM'
                  ? [
                      TextSpan(text: 'collection_reward_location'.tr()),
                    ]
                  : responseData.type == 'STIK'
                      ? [
                          TextSpan(
                              text: 'wallet_go_staika_location'.tr(),
                              style: TextStyle(
                                  color:
                                      AppColorData.regular().colorTextBrand)),
                          TextSpan(text: 'item_523'.tr()),
                        ]
                      : [
                          TextSpan(
                              text: 'wallet_go_taika_location'.tr(),
                              style: TextStyle(
                                  color:
                                      AppColorData.regular().colorTextBrand)),
                          TextSpan(text: 'item_523'.tr()),
                        ],
            ),
          ),
        ),
      ],
    ),
    actions: [
      Expanded(
        child: GazagoButton(
          buttonText: 'confirm'.tr(),
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
    title: 'temporary_error_occurred'.tr(),
    contentWidget: Padding(
      padding: EdgeInsets.only(top: 20.0.sp, bottom: 32.sp),
      child: Text(
        'retry_later_short'.tr(),
        style: AppTextStyleData.regular().koBodyMediumLg.copyWith(
              color: AppColorData.regular().colorTextPrimary,
            ),
      ),
    ),
    actions: [
      Expanded(
        child: GazagoButton(
          onTap: () => Get.back(),
          buttonText: 'confirm'.tr(),
          buttonColor: skyBlueColor,
        ),
      ),
    ],
  );
}

void showNotEnoughGatheringConditionErrorAlert() {
  showAlert(
    allowMultipleBottomSheet: true,
    title: 'collection_material_request'.tr(),
    contentWidget: Padding(
      padding: EdgeInsets.only(top: 20.0.sp, bottom: 32.sp),
      child: Text(
        'more_collection_materials_needed'.tr(),
        style: AppTextStyleData.regular().koBodyMediumLg.copyWith(
              color: AppColorData.regular().colorTextPrimary,
            ),
      ),
    ),
    actions: [
      Expanded(
        child: GazagoButton(
          onTap: () => Get.back(),
          buttonText: 'confirm'.tr(),
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
            padding: EdgeInsets.only(
                left: 20.0.sp, right: 20.sp, top: 36.0.sp, bottom: 36.sp),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 16.sp),
                  child: Text(
                    'service_under_maintenance'.tr(),
                    style:
                        AppTextStyleData.regular().koHeadingSemiboldSm.copyWith(
                              color: AppColorData.regular().colorTextPrimary,
                            ),
                    textAlign: TextAlign.center,
                  ),
                ),
                StyledText(
                  'apology_for_inconvenience'.tr(),
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
