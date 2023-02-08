import 'dart:async';

import 'package:dio/dio.dart' as dio;
import 'package:flutter/cupertino.dart';
import 'package:gaza_go/platform/controllers/preference_controller.dart';
import 'package:gaza_go/platform/helpers/alert_helper.dart';
import 'package:gaza_go/platform/models/user_account_model.dart';
import 'package:gaza_go/platform/services/uaa_service.dart';
import 'package:gaza_go/presentations/components/alert_ui_list.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart' as ph;

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
    await UaaService.getAccountInfo(
      successCallback: (account) {
        profile.update(
          (state) {
            state?.nickname = account.nickname;
            state?.profileImageUrl = account.profileImageUrl;
            state?.provider = account.provider;
            state?.email = account.email;
            state?.id = account.id;
            state?.authorities = account.authorities;
          },
        );
      },
    );
  }

  Future<void> modifyMyAccountInfo() async {
    if (pickedImage.value != null) {
      dynamic imagePath = pickedImage.value!.path;
      dio.MultipartFile profileImage = await dio.MultipartFile.fromFile(imagePath);
      dio.FormData formData = dio.FormData.fromMap({
        'profileImage': profileImage,
      });
      await UaaService.fetchUploadImage(
        formData,
        successCallback: (res) {
          profile.value.profileImageUrl = res?.profileImageUrl;
        },
      );
    }

    if (profile.value.profileImageUrl == null || profile.value.profileImageUrl == '') {
      profile.value.profileImageUrl = 'https://image.staika.io/ic_launcher.png';
    }

    await UaaService.modifyAccountInfo(
      profile.value.nickname!,
      profile.value.profileImageUrl,
      successCallback: (account) {
        preferenceController.onInit();
        showToastPopup('프로필이 수정되었습니다.');
        Get.back();
      },
    );
  }

  void toggleEditMode() {
    if (profile.value.provider == 'APPLE') {
      nicknameTextController.text = profile.value.nickname!.split('@')[0];
      profile.value.nickname = profile.value.nickname!.split('@')[0];
    } else {
      nicknameTextController.text = profile.value.nickname!;
    }

    isEditMode.value = !isEditMode.value;
  }

  void pickImage() async {
    bool hasPhotoPermission = false;
    ph.PermissionStatus permissionStatus = await ph.Permission.photos.status;
    hasPhotoPermission = [ph.PermissionStatus.granted, ph.PermissionStatus.restricted, ph.PermissionStatus.limited].any((permission) => permission == permissionStatus);
    if (!hasPhotoPermission) {
      hasPhotoPermission = await showGalleryPermissionAlert(this);
    }

    if (hasPhotoPermission) {
      pickedImage.value = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 50,
      );
    }
  }

  Future<bool> requestPhotoPermission() async {
    ph.PermissionStatus permissionStatus;
    permissionStatus = await ph.Permission.photos.request();
    if ([ph.PermissionStatus.granted, ph.PermissionStatus.restricted, ph.PermissionStatus.limited].any((permission) => permission == permissionStatus)) {
      return true;
    } else {
      ph.openAppSettings();
      return false;
    }
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
