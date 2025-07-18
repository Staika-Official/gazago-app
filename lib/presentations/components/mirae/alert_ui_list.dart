import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gaza_go/constants/config.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/constants/routes.dart';
import 'package:gaza_go/platform/controllers/challenges_controller.dart';
import 'package:gaza_go/platform/controllers/mirae_challenge_controller.dart';
import 'package:gaza_go/presentations/components/gazago_button.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/icons.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:gaza_go/theme/theme.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:get/get.dart' hide Trans;

void showConfirmMiraeMemberChallenge(MiraeChallengeController controller, int challengeId) {
  Get.dialog(
    PopScope(
      canPop: false,
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
                      Padding(
                        padding: EdgeInsets.only(bottom: 28.sp),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            StyledText(
                              'member_info_check'.tr(),
                              fontWeight: 600,
                              fontSize: 20,
                              lineHeight: 21,
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 14.0.sp),
                              child: StyledText(
                                '${controller.part}',
                                fontWeight: 500,
                                fontSize: 18,
                                lineHeight: 25,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 2.0.sp),
                              child: StyledText(
                                controller.name.value,
                                fontWeight: 500,
                                fontSize: 18,
                                lineHeight: 25,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 0.0.sp),
                        child: Row(children: [
                          Expanded(
                            child: GazagoButton(
                              onTap: () {
                                controller.onCloseJoinPopup();
                                // Get.back();
                                participateInMiraeChallengeByCodeAlert(challengeId);
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
                              buttonText: 'confirm_and_join'.tr(),
                              onTap: () {
                                controller.onFetchJoinChallenge(challengeId);
                              },
                            ),
                          ),
                        ]),
                      )
                    ],
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

void miraeAssetAlert(int challengeId, String? challengeUserState) {
  ChallengesController controller = Get.isRegistered<ChallengesController>() ? Get.find<ChallengesController>() : Get.put(ChallengesController());

  Get.dialog(
    barrierColor: Colors.black.withOpacity(0.8),
    useSafeArea: false,
    barrierDismissible: false,
    PopScope(
      canPop: false,
      child: Dialog(
        key: const Key('miraeAsset'),
        insetPadding: EdgeInsets.zero,
        backgroundColor: subBg01Color.withOpacity(0.2),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            CachedNetworkImage(
              fit: BoxFit.fill,
              width: double.infinity,
              imageUrl: 'https://s3.ap-northeast-2.amazonaws.com/image.stage.staika.io/popups/image_miraeasset_challenge_popup.png',
              placeholder: (context, url) => const Center(child: SizedBox.square(dimension: 30, child: CircularProgressIndicator(color:skyBlueColor))),
              httpHeaders: imageNetworkHeader,
            ),
            Positioned(
              left: 20.sp,
              right: 20.sp,
              bottom: 30.sp,
              child: challengeUserState == 'JOIN_CLOSED'
                  ? GazagoButton(
                      onTap: () => null,
                      buttonText: 'challenge_join_deadline'.tr(),
                      buttonColor: deepGrayColor,
                    )
                  : GazagoButton(
                      onTap: () {
                        // participateInMiraeChallengeByCodeAlert(challengeId);
                        controller.getChallengeDetail(challengeId);
                      },
                      buttonText: 'join_challenge_1'.tr(),
                      buttonColor: skyBlueColor,
                    ),
            ),
            Positioned(
              top: 30,
              right: 10,
              child: IconButton(
                icon: Icon(Icons.close, color: Colors.white, size: 30.sp),
                onPressed: () {
                  Get.back();
                },
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

void participateInMiraeChallengeByCodeAlert(int challengeId) {
  Widget validateName(FormStatus status) {
    return Visibility(
      visible: status != FormStatus.empty,
      child: Padding(
        padding: const EdgeInsets.only(right: 15),
        child: status == FormStatus.insufficient ? iconFieldInvalid : Container(),
      ),
    );
  }

  MiraeChallengeController controller = Get.put(MiraeChallengeController());
  Get.dialog(
    barrierColor: Colors.black.withOpacity(0.8),
    useSafeArea: false,
    barrierDismissible: false,
    PopScope(
      canPop: false,
      child: Dialog(
        insetPadding: EdgeInsets.zero,
        backgroundColor: Colors.transparent,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20.0.sp),
            child: Stack(
              children: [
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                      color: popupBgColor,
                      borderRadius: BorderRadius.all(
                        Radius.circular(AppDoubleData.regular().numberRadius20),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(left: 20.0.sp, right: 20.sp, bottom: 32.sp, top: 36.sp),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(bottom: 14.0.sp),
                            child: StyledText(
                              'member_info_input'.tr(),
                              fontSize: 20,
                              lineHeight: 21,
                              fontWeight: 500,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 28.0.sp),
                            child: StyledText(
                              'corporate_challenge_requires_employee_id'.tr(),
                              fontSize: 16,
                              lineHeight: 22,
                              fontWeight: 500,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Obx(() {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 5.0.sp, bottom: 8.sp),
                                  child: StyledText(
                                    'name'.tr(),
                                    fontWeight: 500,
                                    fontSize: 14,
                                    lineHeight: 20,
                                    color: AppColorData.regular().colorTextSecondary,
                                  ),
                                ),
                                Row(children: [
                                  Expanded(
                                    child: Stack(children: [
                                      TextField(
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: subBg01Color,
                                          hintText: 'enter_name'.tr(),
                                          hintStyle: const TextStyle(
                                            color: deepGrayColor,
                                            fontSize: 18,
                                            height: 20 / 18,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          suffixIcon: controller.name.value != ''
                                              ? Padding(
                                                  padding: EdgeInsets.only(right: controller.nameErrorMessage.value != '' ? 20.0.sp : 0),
                                                  child: IconButton(
                                                    icon: iconInputClear,
                                                    onPressed: () => controller.clearInputName(),
                                                  ),
                                                )
                                              : null,
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                                            borderSide: BorderSide(width: 2, color: controller.nameErrorMessage.value == '' ? skyBlueColor : AppColorData.regular().colorBorderWarning),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                                            borderSide: BorderSide(width: 2, color: controller.nameErrorMessage.value == '' ? Colors.transparent : AppColorData.regular().colorBorderWarning),
                                          ),
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(width: 2, color: controller.nameErrorMessage.value == '' ? Colors.transparent : AppColorData.regular().colorBorderWarning),
                                            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                                          ),
                                        ),
                                        controller: controller.nameTextController,
                                        textInputAction: TextInputAction.go,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18.sp,
                                          height: 20 / 18,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        autofocus: false,
                                        cursorColor: Colors.white,
                                        focusNode: controller.nameFocusNode,
                                        onChanged: (value) => controller.setName(value),
                                        onSubmitted: (val) {
                                          // Get.back();
                                          controller.checkOnAvailableChallenge(challengeId);
                                        },
                                      ),
                                      if (controller.nameErrorMessage.value != '') Positioned(right: 20, top: 26, child: iconInputWarning)
                                    ]),
                                  ),
                                  Obx(() => validateName(controller.nameFormStatus.value)),
                                ]),
                                if (controller.nameErrorMessage.value != '')
                                  SizedBox(
                                    height: 20.sp,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(vertical: 10.0.sp, horizontal: 5.sp),
                                      child: StyledText(controller.nameErrorMessage.value, fontSize: 14, color: AppColorData.regular().colorBorderWarning, fontWeight: 500, lineHeight: 15),
                                    ),
                                  ),
                                Padding(
                                  padding: EdgeInsets.only(top: 20.0.sp),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(left: 5.0.sp, bottom: 8.sp),
                                        child: StyledText(
                                          'employee_id'.tr(),
                                          fontWeight: 500,
                                          fontSize: 14,
                                          lineHeight: 20,
                                          color: AppColorData.regular().colorTextSecondary,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Stack(children: [
                                              TextField(
                                                decoration: InputDecoration(
                                                  filled: true,
                                                  fillColor: subBg01Color,
                                                  hintText: 'enter_employee_id'.tr(),
                                                  hintStyle: const TextStyle(
                                                    color: deepGrayColor,
                                                    fontSize: 18,
                                                    height: 20 / 18,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  suffixIcon: controller.memberCode.value != ''
                                                      ? Padding(
                                                          padding: EdgeInsets.only(right: controller.codeErrorMessage.value != '' ? 20.0.sp : 0),
                                                          child: IconButton(
                                                            icon: iconInputClear,
                                                            onPressed: () => controller.clearInputCode(),
                                                          ),
                                                        )
                                                      : null,
                                                  focusedBorder: OutlineInputBorder(
                                                    borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                                                    borderSide: BorderSide(width: 2, color: controller.codeErrorMessage.value == '' ? skyBlueColor : AppColorData.regular().colorBorderWarning),
                                                  ),
                                                  enabledBorder: OutlineInputBorder(
                                                    borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                                                    borderSide: BorderSide(width: 2, color: controller.codeErrorMessage.value == '' ? Colors.transparent : AppColorData.regular().colorBorderWarning),
                                                  ),
                                                  border: OutlineInputBorder(
                                                    borderSide: BorderSide(width: 2, color: controller.codeErrorMessage.value == '' ? Colors.transparent : AppColorData.regular().colorBorderWarning),
                                                    borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                                                  ),
                                                ),
                                                controller: controller.codeTextController,
                                                textInputAction: TextInputAction.go,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18.sp,
                                                  height: 20 / 18,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                                autofocus: false,
                                                cursorColor: Colors.white,
                                                focusNode: controller.codeFocusNode,
                                                onChanged: (value) => controller.setCode(value),
                                                onSubmitted: (val) {
                                                  // Get.back();
                                                  controller.checkOnAvailableChallenge(challengeId);
                                                },
                                              ),
                                              if (controller.codeErrorMessage.value != '') Positioned(right: 20, top: 26, child: iconInputWarning)
                                            ]),
                                          ),
                                          Obx(() => validateName(controller.codeFormStatus.value)),
                                        ],
                                      ),
                                      if (controller.codeErrorMessage.value != '')
                                        SizedBox(
                                          height: 20.sp,
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(vertical: 10.0.sp, horizontal: 5.sp),
                                            child: StyledText(controller.codeErrorMessage.value, fontSize: 14, color: AppColorData.regular().colorBorderWarning, fontWeight: 500, lineHeight: 15),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }),
                          Padding(
                            padding: EdgeInsets.only(top: 30.0.sp),
                            child: Row(
                              children: [
                                Expanded(
                                  child: GazagoButton(
                                    onTap: () => controller.onCloseJoinPopup(),
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
                                      // Get.back();
                                      controller.checkOnAvailableChallenge(challengeId);
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
    ),
  );
}

void alreadyVerifiedCompanyChallenge() {
  Get.dialog(
    PopScope(
      canPop: false,
      child: Dialog(
        insetPadding: EdgeInsets.zero,
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        child: Padding(
          padding: EdgeInsets.all(25.0.sp),
          child: Container(
            decoration: BoxDecoration(
              color: popupBgColor,
              borderRadius: BorderRadius.circular(AppDoubleData.regular().numberRadius20),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0.sp, vertical: 30.0.sp),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  StyledText(
                    'member_info_request'.tr(),
                    fontWeight: 600,
                    fontSize: 20,
                    lineHeight: 28,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20.0.sp, bottom: 30.sp),
                    child: StyledText(
                      'already_verified_re_enter'.tr(),
                      fontWeight: 500,
                      fontSize: 18,
                      lineHeight: 26,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  GazagoButton(
                    buttonText: 'confirm'.tr(),
                    onTap: () async {
                      Get.back();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

void notOpenCompanyChallenge() {
  Get.dialog(
    PopScope(
      canPop: false,
      child: Dialog(
        insetPadding: EdgeInsets.zero,
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(25.0.sp),
            child: Container(
              decoration: BoxDecoration(
                color: popupBgColor,
                borderRadius: BorderRadius.circular(AppDoubleData.regular().numberRadius20),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0.sp, vertical: 30.0.sp),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 0.0.sp, bottom: 25.sp),
                      child: Column(
                        children: [
                          StyledText(
                            'before_challenge_submission'.tr(),
                            fontWeight: 600,
                            fontSize: 20,
                            lineHeight: 28,
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 15.0.sp),
                            child: StyledText(
                              'rejoin_during_enrollment'.tr(),
                              fontWeight: 500,
                              fontSize: 18,
                              lineHeight: 26,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                    GazagoButton(
                      buttonText: 'go_to_home'.tr(),
                      onTap: () async {
                        Get.offAllNamed(Routes.home);
                      },
                    ),
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

void closedCompanyChallenge() {
  Get.dialog(
      barrierColor: Colors.black.withOpacity(0.8),
      PopScope(
        canPop: false,
        child: Dialog(
          insetPadding: EdgeInsets.zero,
          shadowColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(25.0.sp),
              child: Container(
                decoration: BoxDecoration(
                  color: popupBgColor,
                  borderRadius: BorderRadius.circular(AppDoubleData.regular().numberRadius20),
                ),
                child: Padding(
                  padding: EdgeInsets.only(left: 20.0.sp, right: 20.sp, bottom: 32.sp, top: 36.sp),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 10.0.sp, bottom: 30.sp),
                        child: Column(
                          children: [
                            StyledText(
                              'challenge_ended_2'.tr(),
                              fontWeight: 600,
                              fontSize: 20,
                              lineHeight: 28,
                            ),
                          ],
                        ),
                      ),
                      GazagoButton(
                        buttonText: 'go_to_home'.tr(),
                        onTap: () async {
                          Get.offAllNamed(Routes.home);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ));
}
