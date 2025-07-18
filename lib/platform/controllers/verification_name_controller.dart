import 'package:flutter/material.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/constants/routes.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart' as rx;

import '../models/verification_user_model.dart';

class VerificationNameController extends GetxController {
  final RxString userName = RxString('');
  final Rx<Nationality> nationality = Rx(Nationality.none);
  final RxBool isValidNext = RxBool(false);
  final TextEditingController userNameTextController = TextEditingController();
  late VerificationUserModel verificationUserModel;

  @override
  void onInit() {
    super.onInit();
    verificationUserModel = VerificationUserModel();
    isValidNext.bindStream(
      rx.CombineLatestStream.combine2<String, Nationality, bool>(
        userName.stream,
        nationality.stream,
        (a, b) => a.isNotEmpty && b != Nationality.none,
      ),
    );
  }

  void updateName(String name) {
    userName.value = name;
  }

  void updateNationality(Nationality nationality) {
    this.nationality.value = nationality;
  }

  void initValue() {
    verificationUserModel = VerificationUserModel();
    userNameTextController.text = '';
    userName.value = '';
    nationality.value = Nationality.none;
  }

  void nextStep() {
    verificationUserModel.name = userName.value;
    verificationUserModel.isForeigner = nationality.value.isForeigner;
    Get.toNamed(Routes.verificationDetail, arguments: {'verificationUserModel': verificationUserModel});
  }
}
