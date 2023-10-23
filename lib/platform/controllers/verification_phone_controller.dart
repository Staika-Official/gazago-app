import 'package:flutter/material.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/constants/routes.dart';
import 'package:gaza_go/platform/helpers/alert_helper.dart';
import 'package:gaza_go/platform/services/identity_service.dart';
import 'package:gaza_go/platform/stores/hive_store.dart';
import 'package:gaza_go/presentations/components/alert_ui_list.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';

import '../models/verification_user_model.dart';

class VerificationPhoneController extends GetxController {
  final Rxn<MobileCompany> mobileCompany = Rxn();
  final RxString userMobileNumber = RxString('');
  final RxBool isFormValid = RxBool(false);

  TextEditingController textEditingController = TextEditingController();

  late VerificationUserModel verificationUserModel;

  @override
  void onInit() {
    super.onInit();

    verificationUserModel = Get.arguments['verificationUserModel'];

    isFormValid.bindStream(CombineLatestStream.combine2<MobileCompany?, String, bool>(
        mobileCompany.stream, userMobileNumber.stream, (mobileCompany, number) => (userMobileNumber.value.length == 11) && (mobileCompany != null)));

    userMobileNumber.value = verificationUserModel.mobileNumber;
    textEditingController.text = userMobileNumber.value;
    if (verificationUserModel.mobileCompany.isNotEmpty) {
      mobileCompany.value = MobileCompany.values.where((element) => element.name.toUpperCase() == verificationUserModel.mobileCompany).first;
    }
  }

  void updateMobileNumber(String mobileNumber) {
    userMobileNumber.value = mobileNumber;
  }

  void updateTelecom(MobileCompany mobileCompany) {
    this.mobileCompany.value = mobileCompany;
    Get.back();
  }

  void sendIdentityCode() async {
    verificationUserModel.mobileCompany = mobileCompany.value!.name.toUpperCase();
    verificationUserModel.mobileNumber = userMobileNumber.value;
    verificationUserModel.clientId = 'GAZAGO';

    if (HiveStore.load(key: HiveKey.userId.name) == null) {
      showToastPopup('유저 정보가 없습니다');
    } else {
      await IdentityService.sendIdentityCode(verificationUserModel, successCallback: (requestId) {
        Get.toNamed(Routes.verificationCertCode, arguments: {'requestId': requestId, 'verificationUserModel': verificationUserModel});
      }, errorCallback: (res) {
        if (['IDENTITY_REQUEST_BLOCKED_ABUSE', 'REQUEST_LIMIT_EXCEEDED'].any((element) => element == res.data['errorCode'])) {
          showToastPopup(res.data['errorMessage']);
        } else {
          showInvalidVerifyCode(res.data['errorMessage']);
        }

        // showToastPopup('인증코드가 재전송되었습니다.');
      });
    }
    // _useCase.sendIdentityCode(_model).then((value) {
    //   // Get.toNamed(Routes.verificationCertCode, arguments: {'requestId': value.requestId, 'model': _model});
    // }, onError: (err) {
    //   invalidInformationCallback(err.toString());
    // });
  }
}
