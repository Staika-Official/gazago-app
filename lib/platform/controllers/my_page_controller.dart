import 'dart:developer';

import 'package:dio/dio.dart' as dio;
import 'package:flutter/cupertino.dart';
import 'package:gaza_go/platform/controllers/preference_controller.dart';
import 'package:gaza_go/platform/helpers/base_helper.dart';
import 'package:gaza_go/platform/models/user_account_model.dart';
import 'package:gaza_go/platform/services/uaa_service.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class MyPageController extends GetxController {
  // final PreferenceController? preferenceController;
  //
  // MyPageController([this.preferenceController]);
  final PreferenceController preferenceController = Get.find();
  final Rx<UserAccountModel> profile = Rx(UserAccountModel(
    id: -1,
    login: '',
    email: '',
    nickname: '',
    profileImageUrl: '',
    provider: '',
  ));
  final ImagePicker _picker = ImagePicker();
  final Rx<XFile?> pickedImage = Rx(null);
  final RxBool isEditMode = RxBool(false);
  final TextEditingController nicknameTextController = TextEditingController();
  final int maxNickNameLength = 20;

  @override
  void onInit() {
    getProfileInfo();
    super.onInit();
  }

  void getProfileInfo() async {
    UserAccountModel account = await UaaService.getAccountInfo();
    profile.update((state) {
      state?.nickname = account.nickname;
      state?.profileImageUrl = account.profileImageUrl;
      state?.provider = account.provider;
      state?.email = account.email;
      state?.id = account.id;
    });
    inspect(profile);
  }

  Future<void> modifyMyAccountInfo() async {
    if (pickedImage.value != null) {
      dynamic imagePath = pickedImage.value!.path;
      dio.MultipartFile profileImage = await dio.MultipartFile.fromFile(imagePath);
      dio.FormData formData = dio.FormData.fromMap({
        'profileImageUrl': profileImage,
      });
      inspect(formData);
      var res = await UaaService.fetchUploadImage(formData);
      inspect('이미지유알엘$res');
      profile.value.profileImageUrl = res?.profileImageUrl;
    }
    UserAccountModel account = await UaaService.modifyAccountInfo(profile.value.nickname!, profile.value.profileImageUrl!);
    inspect(account);
    preferenceController.onInit();
    showToastPopup('프로필이 수정되었습니다.');
    Get.back();
  }

  void toggleEditMode() {
    nicknameTextController.text = profile.value.nickname!;
    isEditMode.value = !isEditMode.value;
  }

  void pickImage() async {
    pickedImage.value = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );
    inspect(pickedImage.value?.path);
  }

  void updateNickName(nickname) {
    profile.update((profile) {
      profile!.nickname = nickname;
    });
  }

  // void selectGender(String gender) {
  //   profile.update((profile) {
  //     profile!.gender = gender;
  //   });
  // }

  void updateBiometrics() {
    Get.back();
  }
}
