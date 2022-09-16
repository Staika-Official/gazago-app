import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:gaza_go/platform/models/profile_model.dart';

class PreferenceController extends GetxController {
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
  final RxString appVersion = RxString('');

  @override
  void onInit() {
    getProfileInfo();
    getAppVersion();
    super.onInit();
  }

  void getProfileInfo() {
    profile.value = ProfileModel(
      id: 1,
      nickname: '헬로스텝',
      profileImageUrl: 'https://placeimg.com/20/20/any',
      walletAddress: 'soifje2039jf09acj092w3jc0a923r',
      socialAccounts: 'GOOGLE',
      email: 'hello@gazaGo.io',
      gender: 'MALE',
      age: 21,
      weight: 70.4,
      height: 177.3,
    );
  }

  void getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    appVersion.value = packageInfo.version;
  }

  void showLogoutConfirmation() {
    print('logout!');
  }
}
