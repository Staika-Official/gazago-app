import 'package:flutter/material.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/constants/routes.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart' as RX;

import '../models/verification_user_model.dart';

class VerificationDetailController extends GetxController {
  final RxString userBirthday = RxString('');
  final Rx<Gender> userGender = Rx(Gender.none);
  RxBool isValidNext = RxBool(false);

  TextEditingController textEditingController = TextEditingController();
  late VerificationUserModel verificationUserModel;

  @override
  void onInit() {
    super.onInit();

    isValidNext
        .bindStream(RX.CombineLatestStream.combine2<Gender, String, bool>(userGender.stream, userBirthday.stream, (gender, birthDay) => (gender != Gender.none) && (userBirthday.value.length == 8)));

    verificationUserModel = Get.arguments['verificationUserModel'];
    userBirthday.value = verificationUserModel.birthday.isNotEmpty ? verificationUserModel.birthday.replaceAll('-', '') : '';
    textEditingController.text = userBirthday.value;
    if (verificationUserModel.gender.isNotEmpty) {
      userGender.value = Gender.values.where((element) => element.genderValue == verificationUserModel.gender).first;
    }
  }

  void updateBirthday(String dob) {
    userBirthday.value = dob;
  }

  void updateGender(Gender gender) {
    userGender.value = gender;
  }

  void nextStep() {
    final String birth = userBirthday.value;
    verificationUserModel.birthday = '${birth.substring(0, 4)}-${birth.substring(4, 6)}-${birth.substring(6, 8)}';
    verificationUserModel.gender = userGender.value.genderValue;
    Get.toNamed(Routes.verificationPhone, arguments: {'verificationUserModel': verificationUserModel});
  }
}
