import 'dart:async';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/cupertino.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/platform/controllers/preference_controller.dart';
import 'package:gaza_go/platform/helpers/alert_helper.dart';
import 'package:gaza_go/platform/models/user_account_model.dart';
import 'package:gaza_go/platform/services/uaa_service.dart';
import 'package:gaza_go/platform/stores/hive_store.dart';
import 'package:gaza_go/presentations/components/alert_ui_list.dart';
import 'package:get/get.dart';
import 'package:http_parser/http_parser.dart';
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
      String imagePath = pickedImage.value!.path;
      dio.MultipartFile profileImage = await dio.MultipartFile.fromFile(imagePath, contentType: MediaType('image', imagePath.split('.').last));
      dio.FormData formData = dio.FormData.fromMap({
        'profileImage': profileImage,
      });
      await UaaService.fetchUploadImage(formData, successCallback: (res) {
        profile.value.profileImageUrl = res?.profileImageUrl;
      }, errorCallback: () {
        showToastPopup('이미지 업로드에 실패했습니다.');
        return;
      });
    }

    if (profile.value.profileImageUrl == null || profile.value.profileImageUrl == '') {
      profile.value.profileImageUrl = 'https://image.staika.io/ic_launcher.png';
    }

    await UaaService.modifyAccountInfo(profile.value.nickname!, profile.value.profileImageUrl, successCallback: (UserAccountModel account) {
      preferenceController.onInit();
      HiveStore.save(key: HiveKey.profileImageUrl.name, value: account.profileImageUrl);
      showToastPopup('프로필이 수정되었습니다.');
      Get.back();
    }, errorCallback: (res) {
      showToastPopup(res.message);
    });
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
    ph.PermissionStatus permissionStatus;
    final AndroidDeviceInfo? androidInfo = Platform.isAndroid ? await DeviceInfoPlugin().androidInfo : null;
    if (Platform.isAndroid && androidInfo != null && androidInfo.version.sdkInt <= 32) {
      permissionStatus = await ph.Permission.storage.status;
    } else {
      permissionStatus = await ph.Permission.photos.status;
    }
    hasPhotoPermission = [ph.PermissionStatus.granted, ph.PermissionStatus.restricted, ph.PermissionStatus.limited].any((permission) => permission == permissionStatus);
    if (!hasPhotoPermission) {
      hasPhotoPermission = await showGalleryPermissionAlert(this);
    }

    if (hasPhotoPermission) {
      pickedImage.value = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 50,
      );

      if (pickedImage.value != null) {
        double mbSize = await getImageSizeMB(pickedImage.value!);

        if (mbSize > 2) {
          showToastPopup('2MB이하의 사진을 첨부해주세요');
          pickedImage.value = null;
        }
      }
    }
  }

  Future<bool> requestPhotoPermission() async {
    ph.PermissionStatus permissionStatus;
    final AndroidDeviceInfo? androidInfo = Platform.isAndroid ? await DeviceInfoPlugin().androidInfo : null;
    if (Platform.isAndroid && androidInfo != null && androidInfo.version.sdkInt <= 32) {
      permissionStatus = await ph.Permission.storage.request();
    } else {
      permissionStatus = await ph.Permission.photos.request();
    }
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

  Future<double> getImageSizeMB(XFile image) async {
    final bytes = await image.length();
    final kb = bytes / 1024;
    final mb = kb / 1024;
    return mb;
  }
}
