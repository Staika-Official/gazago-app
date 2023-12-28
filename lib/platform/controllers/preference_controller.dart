import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/platform/helpers/login_helper.dart';
import 'package:gaza_go/platform/helpers/preference_mixin.dart';
import 'package:gaza_go/platform/models/user_account_model.dart';
import 'package:gaza_go/platform/services/uaa_service.dart';
import 'package:gaza_go/platform/stores/hive_store.dart';
import 'package:gaza_go/presentations/components/alert_ui_list.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

class PreferenceController extends GetxController with PreferenceMixin {

  final RxString appVersion = RxString('');
  final RxBool isAbleLuckSound = RxBool(false);

  @override
  void onInit() {
    isAbleLuckSound.value = HiveStore.load(key: HiveKey.luckSound.name) ?? false;
    getProfileInfo();
    getAppVersion();
    super.onInit();
  }

  void getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    appVersion.value = packageInfo.version;
  }

  void showLogoutConfirmation() {
    print('logout!');
    showLogoutAlert(this);
  }

  void onLogout() async {
    await UaaService.fetchLogout(
      successCallback: () {
        forceLogout();
      },
      errorCallback: () {},
    );
  }

  void toggleLuckSoundAlarm(val) {
    isAbleLuckSound.value = val;
    HiveStore.save(key: HiveKey.luckSound.name, value: val);
  }
}
