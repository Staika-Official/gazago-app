import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:step_go/platform/models/profile_model.dart';

class MyPageController extends GetxController {
  final Rx<ProfileModel> profile = Rx(
    ProfileModel(
      id: -1,
      nickname: '',
      profileImageUrl: '',
      walletAddress: '',
      email: '',
      socialAccounts: '',
      gender: '',
      age: 0,
      weight: 0.0,
      height: 0.0,
    ),
  );
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

  void getProfileInfo() {
    profile.value = ProfileModel(
      id: 1,
      nickname: '헬로스텝',
      profileImageUrl: 'https://placeimg.com/20/20/any',
      walletAddress: 'soifje2039jf09acj092w3jc0a923r',
      socialAccounts: 'GOOGLE',
      email: 'hello@stepgo.io',
      gender: 'MALE',
      age: 21,
      weight: 70.4,
      height: 177.3,
    );
  }

  void toggleEditMode() {
    nicknameTextController.text = profile.value.nickname;
    isEditMode.value = !isEditMode.value;
  }

  void pickImage() async {
    pickedImage.value = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );
  }

  void updateNickName(nickname) {
    profile.update((profile) {
      profile!.nickname = nickname;
    });
  }

  void selectGender(String gender) {
    profile.update((profile) {
      profile!.gender = gender;
    });
  }

  void updateBiometrics() {
    Get.back();
  }
}
