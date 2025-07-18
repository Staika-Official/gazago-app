import 'package:flutter/material.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/constants/routes.dart';
import 'package:gaza_go/platform/stores/hive_store.dart';
import 'package:get/get.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    String? accessToken = HiveStore.loadString(key: HiveKey.accessToken.name);
    bool? redirectToRestore = HiveStore.load(key: HiveKey.isAccountLocked.name);
    if (accessToken == null) {
      if (route != Routes.login) {
        return const RouteSettings(name: Routes.login);
      }

      return null;
    } else if (route == Routes.login) {
      if (redirectToRestore != null && redirectToRestore) {
        return null;
      }

      return const RouteSettings(name: Routes.loading);
    } else {
      return null;
    }
  }
}
