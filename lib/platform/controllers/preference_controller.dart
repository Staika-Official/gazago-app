import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/constants/routes.dart';
import 'package:gaza_go/platform/models/user_account_model.dart';
import 'package:gaza_go/platform/services/uaa_service.dart';
import 'package:gaza_go/platform/stores/hive_store.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

class PreferenceController extends GetxController {
  final Rx<UserAccountModel> profile = Rx(
    UserAccountModel(
      id: -1,
      login: '',
      email: '',
      nickname: '',
      profileImageUrl: '',
      provider: '',
    ),
  );
  final RxString appVersion = RxString('');

  @override
  void onInit() {
    getProfileInfo();
    getAppVersion();
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
  }

  void getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    appVersion.value = packageInfo.version;
  }

  void showLogoutConfirmation() {
    print('logout!');
    HiveStore.deleteMultipleKeys(keys: [
      HiveKey.accessToken.name,
      HiveKey.refreshToken.name,
    ]);
    Get.offAllNamed(Routes.login);
  }
}
