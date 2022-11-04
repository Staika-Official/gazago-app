import 'package:flutter/material.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/constants/routes.dart';
import 'package:gaza_go/platform/models/user_account_model.dart';
import 'package:gaza_go/platform/services/uaa_service.dart';
import 'package:gaza_go/platform/stores/hive_store.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
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
    Get.bottomSheet(
      Container(
        height: 240,
        decoration: const BoxDecoration(
          color: Color(0xff363841),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 20),
          child: Center(
            child: Column(
              children: [
                const Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: StyledText(
                    '로그아웃 하시겠습니까?',
                    fontSize: 22,
                    lineHeight: 24,
                    fontWeight: 500,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 12.0),
                  child: StyledText(
                    '로그아웃 시 진행 중\n운동은 자동 정지되어 저장됩니다.',
                    fontSize: 16,
                    lineHeight: 22,
                    fontWeight: 500,
                    textAlign: TextAlign.center,
                    color: Color(0xFFBFBFBF),
                  ),
                ),
                Spacer(),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF363841),
                            border: Border.all(width: 2, color: Colors.black),
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black,
                                offset: Offset(0, 3),
                              )
                            ],
                          ),
                          child: InkWell(
                            onTap: () => onLogout(),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 12.0),
                              child: Center(
                                  child: StyledText(
                                '네',
                                fontSize: 18,
                                lineHeight: 18,
                              )),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF0EE6F3),
                          border: Border.all(width: 2, color: Colors.black),
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black,
                              offset: Offset(0, 3),
                            )
                          ],
                        ),
                        child: InkWell(
                          onTap: () => Get.back(),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12.0),
                            child: Center(
                                child: StyledText(
                              '아니요',
                              fontSize: 18,
                              lineHeight: 18,
                              color: Colors.black,
                            )),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onLogout() async {
    await UaaService.fetchLogout(
      successCallback: () {
        HiveStore.deleteMultipleKeys(keys: [
          HiveKey.accessToken.name,
          HiveKey.refreshToken.name,
          HiveKey.userState.name,
          HiveKey.exerciseData.name,
          HiveKey.savedStepCount.name,
          HiveKey.dummyStepCount.name,
          HiveKey.savedStepInitialized.name,
        ]);
        Get.offAllNamed(Routes.login);
      },
      errorCallback: () {},
    );
  }
}
