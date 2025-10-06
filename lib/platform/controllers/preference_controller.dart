import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/platform/helpers/login_helper.dart';
import 'package:gaza_go/platform/helpers/preference_mixin.dart';
import 'package:gaza_go/platform/models/user_account_model.dart';
import 'package:gaza_go/platform/models/referral_config_model.dart';
import 'package:gaza_go/platform/services/uaa_service.dart';
import 'package:gaza_go/platform/services/referral_service.dart';
import 'package:gaza_go/platform/stores/hive_store.dart';
import 'package:gaza_go/presentations/components/alert_ui_list.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

class PreferenceController extends GetxController with PreferenceMixin {
  final RxString appVersion = RxString('');
  final RxBool isAbleLuckSound = RxBool(false);
  final Rx<ReferralConfigModel?> referralConfig =
      Rx<ReferralConfigModel?>(null);
  final RxBool isReferralConfigLoading = RxBool(true);

  @override
  void onInit() async {
    isAbleLuckSound.value =
        HiveStore.load(key: HiveKey.luckSound.name) ?? false;
    await getProfileInfo();
    // getAccountInfo();
    getAppVersion();
    await fetchReferralConfig();

    super.onInit();
  }

  void getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    appVersion.value = packageInfo.version;
  }

  Future<void> getAccountInfo() async {
    await UaaService.getAccountInfo(
      successCallback: (UserAccountModel user) {
        HiveStore.save(key: HiveKey.authorities.name, value: user.authorities);
        HiveStore.save(
            key: HiveKey.certified.name,
            value: user.authorities!.contains('ROLE_CERTIFIED_USER'));
      },
    );
  }

  void showLogoutConfirmation() {
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

  Future<void> fetchReferralConfig() async {
    isReferralConfigLoading.value = true;

    await ReferralService.getReferralConfig(
      successCallback: (ReferralConfigModel config) {
        referralConfig.value = config;
        isReferralConfigLoading.value = false;
      },
      errorCallback: (error) {
        // If error, default to show referral (existing behavior)
        referralConfig.value = null;
        isReferralConfigLoading.value = false;
      },
    );
  }

  bool get shouldShowReferral {
    // If still loading or error occurred, show referral (existing behavior)
    if (isReferralConfigLoading.value || referralConfig.value == null) {
      return true;
    }
    // Only show referral if isActive is true
    return referralConfig.value!.isActive;
  }

  void toggleLuckSoundAlarm(val) {
    isAbleLuckSound.value = val;
    HiveStore.save(key: HiveKey.luckSound.name, value: val);
  }
}
