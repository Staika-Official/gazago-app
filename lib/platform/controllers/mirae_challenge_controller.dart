import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/constants/routes.dart';
import 'package:gaza_go/platform/controllers/challenges_controller.dart';
import 'package:gaza_go/platform/helpers/alert_helper.dart';
import 'package:gaza_go/platform/helpers/challenge_mixin.dart';
import 'package:gaza_go/platform/models/company_challenge_available_model.dart';
import 'package:gaza_go/platform/models/new_challenge_model.dart';
import 'package:gaza_go/platform/services/activity_service.dart';
import 'package:gaza_go/platform/services/crew_service.dart';
import 'package:gaza_go/platform/stores/hive_store.dart';
import 'package:gaza_go/presentations/components/alert_ui_list.dart';
import 'package:gaza_go/presentations/components/mirae/alert_ui_list.dart';
import 'package:get/get.dart';

class MiraeChallengeController extends GetxController with GetTickerProviderStateMixin, ChallengeMixin {
  ChallengesController challengesController = Get.isRegistered<ChallengesController>() ? Get.find<ChallengesController>() : Get.put(ChallengesController());
  final TextEditingController codeTextController = TextEditingController(text: '');
  final TextEditingController nameTextController = TextEditingController(text: '');
  final Rx<FormStatus> codeFormStatus = Rx(FormStatus.empty);
  final Rx<FormStatus> nameFormStatus = Rx(FormStatus.empty);
  final RxString memberCode = RxString('');
  final RxString name = RxString('');
  final RxString part = RxString('');
  final FocusNode nameFocusNode = FocusNode();
  final FocusNode codeFocusNode = FocusNode();
  final RxString nameErrorMessage = RxString('');
  final RxString codeErrorMessage = RxString('');

  @override
  void onInit() async {

    super.onInit();
  }

  void setCode(value) {

    memberCode.value = value;
  }

  void setName(value) {
print(value);
    name.value = value;
  }

  void onFetchJoinChallenge(int challengeId) async {


    // nameErrorMessage.value = '';
    // codeErrorMessage.value = '';
    await CrewService.joinCompanyCrewChallenge(challengeId, memberCode.value, name.value,
        successCallback: (data) {
          print(data);
          // Get.back();
          // Get.toNamed(Routes.companyChallengeDetail.replaceAll(':id', challengeId.toString()));
          challengesController.getChallengesList();
          Get.until((route) => Get.isDialogOpen == false);
          Get.toNamed(Routes.companyChallengeDetail.replaceAll(':id', challengeId.toString()));
          showToastPopup('챌린지에 참가했습니다.');
        },
        errorCallback: (res) {
          showToastPopup(res.data['errorMessage']);

        });
  }

  void checkOnAvailableChallenge(int challengeId) async {

    if(name.value.isEmpty || memberCode.value.isEmpty){
      nameErrorMessage.value = '이름 확인 후 다시 입력해 주세요';
      codeErrorMessage.value = '사번 확인 후 다시 입력해 주세요';

      showErrorToast();
      return;

    }
    await CrewService.checkAvailableCompanyCrewChallenge(challengeId, memberCode.value, name.value,
        successCallback: (CompanyChallengeAvailableModel data) {
          part.value = data.departName;
          Get.back();
          showConfirmMiraeMemberChallenge(this, challengeId);
        },
        errorCallback: (res) {
          print(res);
          if (res.data['errorCode'] == 'ALREADY_COMPANY_EMPLOYEE_USED') {
            onCloseJoinPopup();
            alreadyVerifiedCompanyChallenge();
            challengesController.getChallengesList();
          } else {
            showErrorToast();

            nameErrorMessage.value = '이름 확인 후 다시 입력해 주세요';
            codeErrorMessage.value = '사번 확인 후 다시 입력해 주세요';
          }

        });
  }

  void showErrorToast(){
    if(Platform.isIOS){
      Fluttertoast.showToast(
        timeInSecForIosWeb: 2,
        msg: '회원정보 확인 후 다시 입력해주세요',
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.black.withOpacity(0.9),
        textColor: Colors.white,
        fontSize: 18.0,
      );
    } else {
      showToastPopup('회원정보 확인 후 다시 입력해주세요');
    }
  }

  void onCloseJoinPopup(){
    Get.back();
    name.value = '';
    memberCode.value = '';
    nameTextController.value = TextEditingValue.empty;
    codeTextController.value = TextEditingValue.empty;
    nameErrorMessage.value = '';
    codeErrorMessage.value = '';
  }

  String maskMiddleCharacter(String str) {
    int mid = str.length ~/ 2;
    return str.substring(0, mid) + '*' + str.substring(mid + (str.length % 2 == 0 ? 0 : 1));
  }

  FormStatus verifyConfirmName(String name) {
    if (name.isEmpty) {
      return FormStatus.empty;
    }
    if (!nameRegExp.hasMatch(name)) {
      return FormStatus.insufficient;
    }
    return FormStatus.sufficient;
  }

}
RegExp nameRegExp = RegExp(r'[a-zA-Z가-힣]');