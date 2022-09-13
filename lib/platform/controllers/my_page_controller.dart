import 'package:get/get.dart';
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
}
