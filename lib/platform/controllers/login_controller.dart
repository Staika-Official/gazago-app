import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/constants/routes.dart';
import 'package:gaza_go/platform/helpers/alert_helper.dart';
import 'package:gaza_go/platform/models/access_token_model.dart';
import 'package:gaza_go/platform/models/social_login_info_model.dart';
import 'package:gaza_go/platform/services/member_service.dart';
import 'package:gaza_go/platform/services/uaa_service.dart';
import 'package:gaza_go/platform/stores/hive_store.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class LoginController extends GetxController {
  void login(LoginType loginType) async {
    // showDuplicateLoginWarning();
    switch (loginType) {
      case LoginType.google:
        await signInWithGoogle();
        break;
      case LoginType.apple:
        await signInWithApple();
        break;
      default:
        await emailLogin();
        break;
    }
  }

  Future<void> emailLogin() async {
    AccessTokenModel token = await UaaService.emailLogin();
    HiveStore.save(key: HiveKey.accessToken.name, value: token.accessToken);
    HiveStore.save(key: HiveKey.refreshToken.name, value: token.refreshToken);

    await initUserInfo();
    Get.offNamed(Routes.loading);
  }

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn(scopes: [
        'email',
        'profile',
      ]).signIn();

      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      await requestLogin(LoginType.google, credential.idToken!);
    } catch (e) {
      print(e);
    }
  }

  Future<void> signInWithApple() async {
    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final credential = OAuthProvider("apple.com").credential(
        accessToken: appleCredential.authorizationCode,
        idToken: appleCredential.identityToken,
      );
      await requestLogin(LoginType.apple, credential.accessToken!);
    } catch (e) {
      print(e);
    }
  }

  Future<void> getUserInfo() async {
    await UaaService.getAccountInfo(
      successCallback: (user) {
        HiveStore.save(key: HiveKey.userId.name, value: user.id.toString());
        HiveStore.save(key: HiveKey.email.name, value: user.email);
        HiveStore.save(key: HiveKey.profileImageUrl.name, value: user.profileImageUrl);
        HiveStore.save(key: HiveKey.nickname.name, value: user.nickname);
      },
    );
  }

  Future<void> initUserInfo() async {
    await getUserInfo();

    String? email = HiveStore.loadString(key: HiveKey.email.name);
    String? profileImageUrl = HiveStore.loadString(key: HiveKey.profileImageUrl.name);
    String? nickname = HiveStore.loadString(key: HiveKey.nickname.name);
    await MemberService.initializeUserData(email, nickname, profileImageUrl, errorCallback: () {
      HiveStore.deleteMultipleKeys(keys: [
        HiveKey.accessToken.name,
        HiveKey.refreshToken.name,
      ]);
      Get.toNamed(Routes.login);
    });
  }

  Future<void> requestLogin(LoginType loginType, String accessToken) async {
    String deviceId = HiveStore.loadString(key: HiveKey.uuid.name)!;
    String fcmToken = HiveStore.loadString(key: HiveKey.fcmToken.name)!;
    String appVersion = await PackageInfo.fromPlatform().then((info) => info.version);
    String platform = Platform.operatingSystem;
    SocialLoginInfoModel loginInfo = SocialLoginInfoModel(
      provider: loginType.name.toUpperCase(),
      deviceId: deviceId,
      fcmToken: fcmToken,
      token: accessToken,
      appVersion: appVersion,
      platform: platform,
      clientId: 'GAZAGO',
      forceLogin: true,
    );

    await UaaService.socialLogin(
      loginInfo,
      successCallback: (AccessTokenModel token, int statusCode) async {
        print('access token: ${token.accessToken}');
        print('refresh token: ${token.refreshToken}');
        HiveStore.save(key: HiveKey.accessToken.name, value: token.accessToken);
        HiveStore.save(key: HiveKey.refreshToken.name, value: token.refreshToken);

        if (statusCode == 200) {
          if (token.accountStatus == 'TERMINATION_REQUESTED') {
            Get.toNamed(Routes.accountRestore);
          } else {
            await initUserInfo();
            bool? permissionRequestBefore = HiveStore.load(key: HiveKey.permissionRequestOnFirstLaunch.name);
            if (permissionRequestBefore != null && permissionRequestBefore) {
              Get.offNamed(Routes.loading);
            } else {
              Get.offNamed(Routes.permissions);
            }
          }
        } else {
          HiveStore.save(key: HiveKey.isNewUser.name, value: true);
          await initUserInfo();
          Get.offNamed(Routes.joinTerms);
        }
      },
      errorCallback: (int statusCode, String statusMessage) {
        showToastPopup(statusMessage);
      },
    );
  }

  void showDuplicateLoginWarning() {
    Get.dialog(
      AlertDialog(
        title: const Text('확인해 주세요'),
        content: const Text('댜른 기기에 로그인 되어있습니다.\n해당 기기의 로그인을 헤제 후 로그인 하시겠습니까?'),
        actions: [
          ElevatedButton(onPressed: () => showLogoutConfirmation(), child: const Text('아니요')),
          ElevatedButton(onPressed: () => Get.offNamed(Routes.onBoarding), child: const Text('네')),
        ],
      ),
    );
  }

  void showLogoutConfirmation() {
    Get.back();
    Get.dialog(
      AlertDialog(
        title: const Text('알림'),
        content: const Text('사용 중인 계정이 다른 기기에서.\n접속이 종료 되었습니다.?'),
        actions: [
          ElevatedButton(onPressed: () => Get.back(), child: const Text('확인')),
        ],
      ),
    );
  }

  void handleFetchWithdrawCancel() async {
    await UaaService.fetchWithdrawCancel(
      successCallback: () async {
        await initUserInfo();
        Get.offNamed(Routes.loading);
        // print('성공');
      },
      errorCallback: () {},
    );
    // Get.toNamed(Routes.withdrawCompleted)
  }
}
