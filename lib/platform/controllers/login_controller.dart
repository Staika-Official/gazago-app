import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/constants/routes.dart';
import 'package:gaza_go/platform/helpers/alert_helper.dart';
import 'package:gaza_go/platform/models/access_token_model.dart';
import 'package:gaza_go/platform/models/social_login_info_model.dart';
import 'package:gaza_go/platform/services/member_service.dart';
import 'package:gaza_go/platform/services/uaa_service.dart';
import 'package:gaza_go/platform/stores/hive_store.dart';
import 'package:gaza_go/presentations/components/alert_ui_list.dart';
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

  Future<void> requestLogin(LoginType loginType, String accessToken, {bool forceLogin = false}) async {
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
      forceLogin: forceLogin,
    );
    print('forceforceforce$forceLogin');
    await UaaService.socialLogin(
      loginInfo,
      successCallback: (AccessTokenModel token, int statusCode) async {
        print('access token: ${token.accessToken}');
        print('refresh token: ${token.refreshToken}');

        if (statusCode == 200) {
          print(token.accountStatus);
          if (token.accountStatus == 'TERMINATION_REQUESTED') {
            Get.toNamed(Routes.accountRestore);
          } else if (token.accountStatus == 'ALREADY_CONNECTED_DEVICE') {
            showDuplicateLoginWarning(loginType, accessToken);
          } else {
            HiveStore.save(key: HiveKey.accessToken.name, value: token.accessToken);
            HiveStore.save(key: HiveKey.refreshToken.name, value: token.refreshToken);

            await initUserInfo();
            bool? permissionRequestBefore = HiveStore.load(key: HiveKey.permissionRequestOnFirstLaunch.name);
            if (permissionRequestBefore != null && permissionRequestBefore) {
              Get.offNamed(Routes.loading);
            } else {
              Get.offNamed(Routes.permissions);
            }
          }
        } else {
          HiveStore.save(key: HiveKey.accessToken.name, value: token.accessToken);
          HiveStore.save(key: HiveKey.refreshToken.name, value: token.refreshToken);
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

  void showDuplicateLoginWarning(loginType, accessToken) {
    alreadyConnectedDeviceAlert(this, loginType, accessToken);
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
