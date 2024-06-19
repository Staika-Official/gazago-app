import 'dart:async';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/cupertino.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/platform/controllers/loader_controller.dart';
import 'package:gaza_go/platform/controllers/preference_controller.dart';
import 'package:gaza_go/platform/helpers/alert_helper.dart';
import 'package:gaza_go/platform/helpers/preference_mixin.dart';
import 'package:gaza_go/platform/models/error_response_data_model.dart';
import 'package:gaza_go/platform/models/user_account_model.dart';
import 'package:gaza_go/platform/services/uaa_service.dart';
import 'package:gaza_go/platform/stores/hive_store.dart';
import 'package:gaza_go/presentations/components/alert_ui_list.dart';
import 'package:get/get.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart' as ph;

class MyPageController extends GetxController with PreferenceMixin {
  final PreferenceController preferenceController = Get.find();
  
  final ImagePicker _picker = ImagePicker();
  final Rx<XFile?> pickedImage = Rx(null);
  final RxBool isEditMode = RxBool(false);
  final TextEditingController nicknameTextController = TextEditingController();
  final int maxNickNameLength = 20;
  RxString provider = RxString('');
  final FocusNode focusNode = FocusNode();

  @override
  void onInit() async {
    Get.arguments != null ? provider.value = Get.arguments['provider'] : provider.value = '';

    await getProfileInfo();

    super.onInit();
  }

  void checkAvailableNicknameChange() {
    if (!profile.value.availableChangeNickname!) {
      focusNode.unfocus();
      showToastPopup('닉네임 수정 이력이 있어요.\n닉네임은 최초 1회 이후 수정할 수 없어요');
      return;
    }
  }

  Future<void> modifyMyAccountInfo() async {
    if (pickedImage.value == null && profile.value.nickname == originalNickname.value) {
      toggleEditMode();
      return;
    }

    String? uploadUrl = profile.value.profileImageUrl;

    if (pickedImage.value != null) {
      String imagePath = pickedImage.value!.path;
      dio.MultipartFile profileImage = await dio.MultipartFile.fromFile(imagePath, contentType: MediaType('image', imagePath.split('.').last));
      File file = File(imagePath);

      await UaaService.fetchUploadImageUrl(
        profileImage.filename!,
        successCallback: (Map<String, dynamic> data) async {
          uploadUrl = data['uploadUrl'];
          await UaaService.uploadToS3bucket(
            uploadUrl!,
            file,
            imagePath.split('.').last,
          );
        },
        errorCallback: () {
          showToastPopup('이미지 업로드에 실패했습니다.');
          return;
        },
      );
    }

    Uri profileImageUrl = Uri.parse(uploadUrl ?? 'https://image.staika.io/ic_launcher.png');
    profile.value.profileImageUrl = profileImageUrl.origin + profileImageUrl.path;

    final Map<String, String> params = {};
    if (profile.value.nickname != originalNickname.value) {
      params['nickname'] = profile.value.nickname!;
    }

    // parameter2가 null이 아닌 경우에만 params에 추가
    if (profile.value.profileImageUrl != null) {
      params['profileImageUrl'] = profile.value.profileImageUrl!;
    }
    await UaaService.modifyAccountInfo(
      params,
      successCallback: (UserAccountModel account) {
        preferenceController.onInit();
        HiveStore.save(key: HiveKey.profileImageUrl.name, value: account.profileImageUrl);
        HiveStore.save(key: HiveKey.nickname.name, value: account.nickname);
        showToastPopup('수정되었습니다.');
        Get.back();
      },
      errorCallback: (ErrorResponseDataModel data) {
        showToastPopup(data.errorMessage!);
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
        maxHeight: 1080,
        maxWidth: 1920,
        imageQuality: 100,
      );

      if (pickedImage.value != null) {
        double mbSize = await getImageSizeMB(pickedImage.value!);

        if (mbSize > 2) {
          showToastPopup('첨부된 사진의 크기가 너무 큽니다.');
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
    if (!profile.value.availableChangeNickname!) {
      nicknameTextController.text = originalNickname.value;
      showToastPopup('닉네임 수정 이력이 있어요.\n닉네임은 최초 1회 이후 수정할 수 없어요');
      return;
    }
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

  void validateProfileEdit() {
    focusNode.unfocus();
    if (profile.value.availableChangeNickname! && profile.value.nickname != originalNickname.value) {
      if (profile.value.nickname!.length < 3) {
        showToastPopup('닉네임은 3자 이상 입력해주세요.');
        return;
      }
      showConfirmNicknameChange(this);
    } else {
      modifyMyAccountInfo();
    }
  }
}
