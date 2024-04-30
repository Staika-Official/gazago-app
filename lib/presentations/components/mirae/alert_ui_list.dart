
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gaza_go/constants/config.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/constants/routes.dart';
import 'package:gaza_go/platform/controllers/challenges_controller.dart';
import 'package:gaza_go/platform/controllers/challenges_detail_controller.dart';
import 'package:gaza_go/platform/controllers/company_crew_controller.dart';
import 'package:gaza_go/platform/controllers/mirae_challenge_controller.dart';
import 'package:gaza_go/platform/helpers/alert_helper.dart';
import 'package:gaza_go/presentations/components/gazago_button.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/icons.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:gaza_go/theme/theme.g.dart';
import 'package:get/get.dart';




void showConfirmMiraeMemberChallenge(MiraeChallengeController controller, int challengeId){
  Get.dialog(
      WillPopScope(
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
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0.sp, vertical: 32.0.sp),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top:4.0.sp, bottom: 28.sp),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              StyledText(
                                '회원 정보 확인',
                                fontWeight: 600,
                                fontSize: 20,
                                lineHeight: 28,
                              ),
                              Padding(
                                padding: EdgeInsets.only(top:12.0.sp),
                                child: StyledText(
                                  '${controller.part}',
                                  fontWeight: 500,
                                  fontSize: 18,
                                  lineHeight: 25,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top:2.0.sp),
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
                          padding: EdgeInsets.only(top:0.0.sp),
                          child: Row(children: [
                            Expanded(
                              child: GazagoButton(
                                onTap: () {
                                  controller.onCloseJoinPopup();
                                  // Get.back();
                                  participateInMiraeChallengeByCodeAlert(challengeId);
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
                                buttonText: '확인 후 참가',
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
      ));

}




void miraeAssetAlert(ChallengesController controller , int challengeId, String? challengeUserState) {


  Get.dialog(
    barrierColor: subBg01Color.withOpacity(0.2),
    useSafeArea: false,
    barrierDismissible: false,
    WillPopScope(
      onWillPop: () async => false,
      child: Dialog(
        insetPadding: EdgeInsets.zero,
        backgroundColor: subBg01Color.withOpacity(0.2),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            CachedNetworkImage(
              fit: BoxFit.fill,
              width: double.infinity,
              imageUrl: 'https://s3.ap-northeast-2.amazonaws.com/image.stage.staika.io/popups/image_miraeasset_challenge_popup.png',
              placeholder: (context, url) => const Center(child: SizedBox.square(dimension: 30, child: CircularProgressIndicator())),
              httpHeaders: imageNetworkHeader,
            ),

            Positioned(
              left: 20.sp,
              right: 20.sp,
              bottom:30.sp,
              child:  challengeUserState == 'JOIN_CLOSED' ? GazagoButton(
                onTap: () => null,
                buttonText: '챌린지 참가 마감',
                buttonColor: deepGrayColor,
              ) : GazagoButton(
                onTap: () {
                  // participateInMiraeChallengeByCodeAlert(challengeId);
                  controller.getChallengeDetail(challengeId);
                },
                buttonText: '챌린지 참가',
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
    barrierColor: subBg01Color.withOpacity(0.5),
    useSafeArea: false,
    barrierDismissible: false,
    WillPopScope(
      onWillPop: () async => false,
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
                              '회원 정보 입력',
                              fontSize: 20,
                              lineHeight: 21,
                              fontWeight: 500,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 28.0.sp),
                            child: const StyledText(
                              '미래에셋 기업전용 챌린지 입니다.',
                              fontSize: 16,
                              lineHeight: 17,
                              fontWeight: 500,
                            ),
                          ),
                          Obx(() {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left:5.0.sp, bottom: 8.sp),
                                  child: StyledText('이름', fontWeight: 500, fontSize: 14, lineHeight: 20, color: AppColorData.regular().colorTextSecondary,),
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextField(

                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: subBg01Color,
                                          hintText: '이름을 입력해주세요.',
                                          hintStyle: const TextStyle(
                                            color: deepGrayColor,
                                            fontSize: 18,
                                            height: 20 / 18,
                                            fontWeight: FontWeight.w500,
                                          ),
                                            suffixIcon: controller.nameErrorMessage.value != '' ? IconButton(
                                            icon: const Icon(Icons.clear, color: Colors.red),
                                            onPressed: () => controller.codeTextController.clear(),
                                            ) : null,
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                                            borderSide: BorderSide(width: 2, color: controller.nameErrorMessage.value == '' ? skyBlueColor : const Color(0xFFFF4C4C)),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                                            borderSide: BorderSide(width: 2, color: controller.nameErrorMessage.value == '' ? Colors.transparent : const Color(0xFFFF4C4C)),
                                          ),
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(width: 2, color: controller.nameErrorMessage.value == '' ? Colors.transparent : const Color(0xFFFF4C4C)),
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
                                    ),
                                    Obx(() => validateName(controller.nameFormStatus.value)),
                                  ]
                                ),
                                if(controller.nameErrorMessage.value != '')
                                  SizedBox(
                                    height: 20.sp,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(vertical: 10.0.sp, horizontal: 5.sp),
                                      child: StyledText(controller.nameErrorMessage.value, fontSize: 14, color: Colors.redAccent, fontWeight: 500, lineHeight: 15),
                                    ),
                                  ),
                                Padding(
                                  padding: EdgeInsets.only(top:20.0.sp),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(left:5.0.sp, bottom: 8.sp),
                                        child: StyledText('사번', fontWeight: 500, fontSize: 14, lineHeight: 20, color: AppColorData.regular().colorTextSecondary,),
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: TextField(
                                              decoration: InputDecoration(
                                                filled: true,
                                                fillColor: subBg01Color,
                                                hintText: '사번을 입력해주세요.',
                                                hintStyle: const TextStyle(
                                                  color: deepGrayColor,
                                                  fontSize: 18,
                                                  height: 20 / 18,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                suffixIcon: controller.codeErrorMessage.value != '' ? IconButton(
                                                  icon: const Icon(Icons.clear, color: Colors.red),
                                                  onPressed: () => controller.codeTextController.clear(),
                                                ) : null,
                                                focusedBorder: OutlineInputBorder(
                                                  borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                                                  borderSide: BorderSide(width: 2, color: controller.codeErrorMessage.value == '' ? skyBlueColor : const Color(0xFFFF4C4C)),
                                                ),
                                                enabledBorder: OutlineInputBorder(
                                                  borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                                                  borderSide: BorderSide(width: 2, color: controller.codeErrorMessage.value == '' ? Colors.transparent : const Color(0xFFFF4C4C)),
                                                ),
                                                border: OutlineInputBorder(
                                                  borderSide: BorderSide(width: 2, color: controller.codeErrorMessage.value == '' ? Colors.transparent : const Color(0xFFFF4C4C)),
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
                                          ),
                                          Obx(() => validateName(controller.codeFormStatus.value)),
                                        ],
                                      ),
                                      if(controller.codeErrorMessage.value != '')
                                        SizedBox(
                                          height: 20.sp,
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(vertical: 10.0.sp, horizontal: 5.sp),
                                            child: StyledText(controller.codeErrorMessage.value, fontSize: 14, color: Colors.redAccent, fontWeight: 500, lineHeight: 15),
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
                                      // Get.back();
                                      controller.checkOnAvailableChallenge(challengeId);
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
    ),
  );
}

void alreadyVerifiedCompanyChallenge(){
  Get.dialog(
      WillPopScope(
        onWillPop: () async => false,
        child: Dialog(
          insetPadding: EdgeInsets.zero,
          shadowColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          child: Padding(
            padding: EdgeInsets.all(25.0.sp),
            child: Container(

              decoration: BoxDecoration(
                color: popupBgColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0.sp, vertical: 30.0.sp),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    StyledText(
                      '회원 정보 확인 요청',
                      fontWeight: 600,
                      fontSize: 20,
                      lineHeight: 28,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top:20.0.sp, bottom: 30.sp),
                      child: StyledText(
                        '이미 인증된 회원입니다.\n 회원 정보를 다시 입력해주세요.',
                        fontWeight: 500,
                        fontSize: 18,
                        lineHeight: 26,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    GazagoButton(
                      buttonText: '확인',
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
      ));

}

void notOpenCompanyChallenge(){
  Get.dialog(

      WillPopScope(
        onWillPop: () async => false,
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
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0.sp, vertical: 30.0.sp),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top:0.0.sp, bottom: 25.sp),
                        child: Column(
                          children: [
                            StyledText(
                              '챌린지 접수 전',
                              fontWeight: 600,
                              fontSize: 20,
                              lineHeight: 28,
                            ),
                            Padding(
                              padding: EdgeInsets.only(top:15.0.sp),
                              child: StyledText(
                                '챌린지 모집 기간에 다시\n참가해주세요.',
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
                        buttonText: '홈화면으로 이동',
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

void closedCompanyChallenge(){
  Get.dialog(

      WillPopScope(
        onWillPop: () async => false,
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
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0.sp, vertical: 30.0.sp),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top:10.0.sp, bottom: 30.sp),
                        child: Column(
                          children: [
                            StyledText(
                              '챌린지가 끝났어요.',
                              fontWeight: 600,
                              fontSize: 20,
                              lineHeight: 28,
                            ),

                          ],
                        ),
                      ),
                      GazagoButton(
                        buttonText: '홈화면으로 이동',
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