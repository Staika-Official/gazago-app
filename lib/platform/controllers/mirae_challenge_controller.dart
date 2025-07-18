import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/constants/routes.dart';
import 'package:gaza_go/platform/controllers/challenges_controller.dart';
import 'package:gaza_go/platform/helpers/alert_helper.dart';
import 'package:gaza_go/platform/helpers/challenge_mixin.dart';
import 'package:gaza_go/platform/helpers/map_mixin.dart';
import 'package:gaza_go/platform/models/company_challenge_available_model.dart';
import 'package:gaza_go/platform/services/crew_service.dart';
import 'package:gaza_go/presentations/components/mirae/alert_ui_list.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';

class MiraeChallengeController extends GetxController
    with GetTickerProviderStateMixin, MapMixin, ChallengeMixin {
  ChallengesController challengesController =
      Get.isRegistered<ChallengesController>()
          ? Get.find<ChallengesController>()
          : Get.put(ChallengesController());
  final TextEditingController codeTextController =
      TextEditingController(text: '');
  final TextEditingController nameTextController =
      TextEditingController(text: '');
  final Rx<FormStatus> codeFormStatus = Rx(FormStatus.empty);
  final Rx<FormStatus> nameFormStatus = Rx(FormStatus.empty);
  final RxString memberCode = RxString('');
  final RxString name = RxString('');
  final RxString part = RxString('');
  final FocusNode nameFocusNode = FocusNode();
  final FocusNode codeFocusNode = FocusNode();
  final RxString nameErrorMessage = RxString('');
  final RxString codeErrorMessage = RxString('');

  void setCode(value) {
    memberCode.value = value;
  }

  void setName(value) {
    name.value = value;
  }

  void onFetchJoinChallenge(int challengeId) async {
    // nameErrorMessage.value = '';
    // codeErrorMessage.value = '';
    await CrewService.joinCompanyCrewChallenge(
        challengeId, memberCode.value, name.value, successCallback: (data) {
      // Get.back();
      // Get.toNamed(Routes.companyChallengeDetail.replaceAll(':id', challengeId.toString()));
      challengesController.getChallengesList();
      Get.until((route) => Get.isDialogOpen == false);
      Get.toNamed(Routes.companyChallengeDetail
          .replaceAll(':id', challengeId.toString()));
      showToastPopup('joined_challenge'.tr());
    }, errorCallback: (res) {
      showToastPopup(res.data['errorMessage']);
    });
  }

  void checkOnAvailableChallenge(int challengeId) async {
    nameFocusNode.unfocus();
    codeFocusNode.unfocus();
    if (name.value.isEmpty || memberCode.value.isEmpty) {
      nameErrorMessage.value = 'reenter_name'.tr();
      codeErrorMessage.value = 'reenter_employee_id'.tr();

      showToastPopup('reenter_member_info'.tr());
      return;
    }
    await CrewService.checkAvailableCompanyCrewChallenge(
        challengeId, memberCode.value, name.value,
        successCallback: (CompanyChallengeAvailableModel data) {
      part.value = data.departName;
      Get.back();
      showConfirmMiraeMemberChallenge(this, challengeId);
    }, errorCallback: (res) {
      if (res.data['errorCode'] == 'ALREADY_COMPANY_EMPLOYEE_USED') {
        onCloseJoinPopup();
        alreadyVerifiedCompanyChallenge();
        challengesController.getChallengesList();
      } else {
        showToastPopup('reenter_member_info'.tr());

        nameErrorMessage.value = 'reenter_name'.tr();
        codeErrorMessage.value = 'reenter_employee_id'.tr();
      }
    });
  }

  void showErrorToast() {
    if (Platform.isIOS) {
      Fluttertoast.showToast(
        timeInSecForIosWeb: 2,
        msg: 'reenter_member_info'.tr(),
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.black.withOpacity(0.9),
        textColor: Colors.white,
        fontSize: 18.0,
      );
    } else {
      showToastPopup('reenter_member_info'.tr());
    }
  }

  void clearInputName() {
    name.value = '';
    nameTextController.value = TextEditingValue.empty;
    nameTextController.clear();
    nameErrorMessage.value = '';
  }

  void clearInputCode() {
    memberCode.value = '';
    codeTextController.value = TextEditingValue.empty;
    codeTextController.clear();
    codeErrorMessage.value = '';
  }

  void onCloseJoinPopup() {
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
    return '${str.substring(0, mid)}*${str.substring(mid + (str.length % 2 == 0 ? 0 : 1))}';
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
