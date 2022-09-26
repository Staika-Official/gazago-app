import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/constants/routes.dart';
import 'package:gaza_go/platform/models/token_model.dart';
import 'package:gaza_go/platform/models/user_account_model.dart';
import 'package:gaza_go/platform/services/uaa_service.dart';
import 'package:gaza_go/platform/stores/hive_store.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
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
      case LoginType.kakao:
        break;
      default:
        await emailLogin();
        break;
    }

    await getUserInfo();
  }

  Future<void> emailLogin() async {
    TokenModel token = await UaaService.emailLogin();
    HiveStore.save(key: HiveKey.accessToken.name, value: token.accessToken);
    HiveStore.save(key: HiveKey.refreshToken.name, value: token.refreshToken);
    Get.toNamed(Routes.home);
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn(scopes: [
      'email',
      'profile',
    ]).signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    inspect(credential);
    print(credential.accessToken);
    print(credential.idToken);

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<UserCredential> signInWithApple() async {
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );

    final credential = OAuthProvider("apple.com").credential(
      idToken: appleCredential.identityToken,
      accessToken: appleCredential.authorizationCode,
    );

    inspect(credential);
    print(credential.accessToken);
    print(credential.idToken);

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<void> getUserInfo() async {
    UserAccountModel user = await UaaService.getAccountInfo();
    HiveStore.save(key: HiveKey.userId.name, value: user.id.toString());
    HiveStore.save(key: HiveKey.profileImageUrl.name, value: user.profileImageUrl);
    HiveStore.save(key: HiveKey.nickname.name, value: user.nickname);
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
}
