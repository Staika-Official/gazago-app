import 'dart:async';
import 'dart:io';

import 'package:adjust_sdk/adjust.dart';
import 'package:adjust_sdk/adjust_event.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gaza_go/constants/config.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/constants/routes.dart';
import 'package:gaza_go/flavors.dart';
import 'package:gaza_go/platform/firebase/remote_config.dart';
import 'package:gaza_go/platform/helpers/alert_helper.dart';
import 'package:gaza_go/platform/helpers/login_helper.dart';
import 'package:gaza_go/platform/models/access_token_model.dart';
import 'package:gaza_go/platform/models/error_response_data_model.dart';
import 'package:gaza_go/platform/models/social_login_info_model.dart';
import 'package:gaza_go/platform/models/user_account_model.dart';
import 'package:gaza_go/platform/services/member_service.dart';
import 'package:gaza_go/platform/services/uaa_service.dart';
import 'package:gaza_go/platform/stores/hive_store.dart';
import 'package:gaza_go/presentations/components/alert_ui_list.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginController extends GetxController {


  @override
  void onInit() async {
    bool isInspectionNotice = getConfig(dataType: ConfigType.bool, configKey: 'notice_alert');
    if (isInspectionNotice) {
      String noticeUri = getConfig(dataType: ConfigType.string, configKey: 'notice_alert_address');
      Uri url = Uri.parse(noticeUri);
      if (await canLaunchUrl(url)) {
        showModalNoticeWebview(Get.context, linkUrl: noticeUri);
      }
      return;
    } else {
      Get.back();
    }

    super.onInit();
  }




  void login(LoginType loginType) async {
    Adjust.trackEvent(AdjustEvent('lllyw8'));

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

      await FirebaseAuth.instance.signInWithCredential(credential);
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
        webAuthenticationOptions: WebAuthenticationOptions(
          clientId: F.isDev ? 'io.gazago.stage' : 'io.gazago',
          redirectUri: Uri.parse(
            F.isDev ? 'https://apple-gazago-stage.glitch.me/callbacks/sign_in_with_apple' : 'https://apple-gazago.glitch.me/callbacks/sign_in_with_apple',
          ),
        ),
      );

      final credential = OAuthProvider("apple.com").credential(
        accessToken: appleCredential.authorizationCode,
        idToken: appleCredential.identityToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      await requestLogin(LoginType.apple, credential.accessToken!);
    } catch (e) {
      print(e);
    }
  }

  Future<void> getUserInfo() async {
    await UaaService.getAccountInfo(
      successCallback: (UserAccountModel user) {
        HiveStore.save(key: HiveKey.userId.name, value: user.id.toString());
        HiveStore.save(key: HiveKey.email.name, value: user.email);
        HiveStore.save(key: HiveKey.profileImageUrl.name, value: user.profileImageUrl);
        HiveStore.save(key: HiveKey.nickname.name, value: user.nickname);
        HiveStore.save(key: HiveKey.authorities.name, value: user.authorities);
        HiveStore.save(key: HiveKey.certified.name, value: user.authorities!.contains('ROLE_CERTIFIED_USER'));
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
      Get.offAllNamed(Routes.login);
    });
  }

  Future<void> requestLogin(LoginType loginType, String accessToken, {bool forceLogin = false}) async {
    String deviceId = HiveStore.loadString(key: HiveKey.uuid.name)!;
    String fcmToken = HiveStore.loadString(key: HiveKey.fcmToken.name)!;
    String? inviteUserId = HiveStore.loadString(key: HiveKey.inviteUserId.name);
    String appVersion = await PackageInfo.fromPlatform().then((info) => info.version);

    dynamic deviceInfo;

    if (Platform.isAndroid) {
      deviceInfo = await DeviceInfoPlugin().androidInfo;
    } else if (Platform.isIOS) {
      deviceInfo = await DeviceInfoPlugin().iosInfo;
    }

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
      deviceInfo: deviceInfo.toString(),
      providerEnv: appliedEndpoint != null && appliedEndpoint!['activateStageMode'] ? 'STAGE' : null,
      inviteUserId: inviteUserId,
    );

    await UaaService.socialLogin(
      loginInfo,
      successCallback: (AccessTokenModel token, int statusCode) async {
        if (statusCode == 200) {
          HiveStore.save(key: HiveKey.accessToken.name, value: token.accessToken);
          HiveStore.save(key: HiveKey.refreshToken.name, value: token.refreshToken);

          if (token.accountStatus == 'TERMINATION_COMPLETED') {
            showToastPopup('탈퇴처리된 계정입니다.');
            forceLogout();
          } else if (token.accountStatus == 'TERMINATION_REQUESTED') {
            HiveStore.save(key: HiveKey.isAccountLocked.name, value: true);
            Get.offNamed(Routes.accountRestore);
          } else if (token.accountStatus == 'ALREADY_CONNECTED_DEVICE') {
            showDuplicateLoginWarning(loginType, accessToken);
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
          HiveStore.save(key: HiveKey.accessToken.name, value: token.accessToken);
          HiveStore.save(key: HiveKey.refreshToken.name, value: token.refreshToken);
          HiveStore.save(key: HiveKey.isNewUser.name, value: true);
          await initUserInfo();
          Get.offNamed(Routes.joinTerms, arguments: {'platform': 'gazago'});
        }
      },
      errorCallback: (ErrorResponseDataModel? res) {
        forceLogout();
        if (res != null) {
          if (res.errorCode != null && res.errorCode == 'APP_UPDATE_REQUIRED') {
            showForceUpdateApp();
          }
        }
      },
    );
  }

  void showDuplicateLoginWarning(loginType, accessToken) {
    alreadyConnectedDeviceAlert(this, loginType, accessToken);
  }

  void handleTerminatedCancel() async {
    await UaaService.fetchLogout(
      successCallback: () {
        forceLogout();
      },
      errorCallback: () {},
    );
  }

  void handleFetchWithdrawCancel() async {
    await UaaService.fetchWithdrawCancel(
      successCallback: () async {
        HiveStore.save(key: HiveKey.isAccountLocked.name, value: false);
        await initUserInfo();
        Get.offNamed(Routes.loading);
      },
      errorCallback: () {},
    );
  }
}
