import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/constants/routes.dart';
import 'package:gaza_go/platform/controllers/home_menu_controller.dart';
import 'package:gaza_go/platform/firebase/remote_config.dart';
import 'package:gaza_go/platform/models/user_account_model.dart';
import 'package:gaza_go/platform/services/uaa_service.dart';
import 'package:gaza_go/platform/stores/hive_store.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kakao_flutter_sdk_share/kakao_flutter_sdk_share.dart';
import 'package:package_info_plus/package_info_plus.dart';

Future<bool> isForceUpdateTarget() async {
  String remoteAppVersion = getConfig(dataType: ConfigType.string, configKey: 'minimum_app_version');
  return await compareVersion(remoteAppVersion);
}

Future<bool> isRecommendUpdateTarget() async {
  String remoteAppVersion = getConfig(dataType: ConfigType.string, configKey: 'recommended_app_version');
  return await compareVersion(remoteAppVersion);
}

Future<bool> compareVersion(String versionString) async {
  String remoteAppVersion = versionString;
  PackageInfo packageInfo = await PackageInfo.fromPlatform();

  List<int> splitVersionString(String versionString) {
    return versionString.split('.').map((element) => int.parse(element)).toList();
  }

  List<int> targetAppVersion = splitVersionString(remoteAppVersion);
  List<int> deviceAppVersion = splitVersionString(packageInfo.version);

  bool isUnderTargetVersion = false;

  for (int i = 0; i < targetAppVersion.length; i++) {
    if (targetAppVersion[i] > deviceAppVersion[i]) {
      isUnderTargetVersion = true;
      break;
    } else if (targetAppVersion[i] < deviceAppVersion[i]) {
      break;
    }
  }
  return isUnderTargetVersion;
}

String formatDate(String? isoDateString) {
  if (isoDateString != null) {
    return DateFormat("yyyy.MM.dd HH:mm:ss").format(DateTime.parse(isoDateString).toLocal());
  } else {
    return '';
  }
}

String formatDateUntilDay(String? isoDateString) {
  if (isoDateString != null) {
    return DateFormat("yyyy-MM-dd").format(DateTime.parse(isoDateString).toLocal());
  } else {
    return '';
  }
}

String formatDateUntilTime(String? isoDateString) {
  if (isoDateString != null) {
    return DateFormat("yy.MM.dd HH:mm").format(DateTime.parse(isoDateString).toLocal());
  } else {
    return '';
  }
}

String formatDateMonthUntilTime(String? isoDateString) {
  if (isoDateString != null) {
    return DateFormat("MM.dd (HH:mm)").format(DateTime.parse(isoDateString).toLocal());
  } else {
    return '';
  }
}

String calculateDuration(String? fromDateString, String? toDateString) {
  if (fromDateString == null || toDateString == null) return '0';
  DateTime fromDate = DateTime.parse(fromDateString).toLocal();
  DateTime toDate = DateTime.parse(toDateString).toLocal();
  DateTime formattedFromDate = DateTime(fromDate.year, fromDate.month, fromDate.day);
  DateTime formattedToDate = DateTime(toDate.year, toDate.month, toDate.day);

  return (formattedToDate.difference(formattedFromDate).inDays + 1).toString();
}

String coordinatesToString(List<LatLng> coordinates) {
  List<List<double>> coordinateStringList = List.empty(growable: true);
  for (LatLng coordinate in coordinates) {
    coordinateStringList.add([coordinate.latitude, coordinate.longitude]);
  }
  return coordinateStringList.toString();
}

List<LatLng> locationListToLatLng(List<dynamic> locationList) {
  List<LatLng> coordinates = List.empty(growable: true);
  for (List location in locationList) {
    LatLng coordination = LatLng(location[0], location[1]);
    coordinates.add(coordination);
  }
  return coordinates;
}

String getUiAmountString(int val, int decimalPlaces) {
  num mod = pow(10.0, decimalPlaces);
  double formattedNumber = (val.toDouble() / mod);

  return formattedNumber.toString();
}

String formatDecimalPlaces(double val, int decimalPlaces, {RoundType roundType = RoundType.round, bool isAutoDecimal = false}) {
  num mod = pow(10.0, decimalPlaces);

  double? formattedNumber;
  switch (roundType) {
    case RoundType.round:
      formattedNumber = ((val * mod).round().toDouble() / mod);
      break;
    case RoundType.ceil:
      formattedNumber = ((val * mod).ceilToDouble() / mod);
      break;
    case RoundType.floor:
      formattedNumber = ((val * mod).floorToDouble() / mod);
      break;
  }

  NumberFormat formatter;
  if (decimalPlaces != 0) {
    if (val == 0) {
      formatter = NumberFormat('0');
    } else {
      if (isAutoDecimal) {
        formatter = NumberFormat('#,##0.${"#" * decimalPlaces}');
      } else {
        formatter = NumberFormat('#,##0.${"0" * decimalPlaces}');
      }
    }
  } else {
    formatter = NumberFormat('#,###');
  }

  return formatter.format(formattedNumber);
}

String getNumberToCommaFromCurrency(double value, Currency currency) {
  if (value == 0) {
    return '0';
  }

  late NumberFormat format;
  switch (currency) {
    case Currency.krw:
      format = NumberFormat('###,###,###,###');
      break;

    case Currency.usd:
      format = NumberFormat('###,###,###,###.##');
      break;
  }
  return format.format(value);
}

String formatSeconds(int time) {
  Duration seconds = Duration(seconds: time);
  return seconds.toString().split('.').first.padLeft(8, "0");
}

String generateRandomString(int length) {
  final random = Random();
  const availableChars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  final randomString = List.generate(length, (index) => availableChars[random.nextInt(availableChars.length)]).join();

  return randomString;
}

void validateTimer(Timer timer, HiveKey hiveKey) {
  int? timerHash = HiveStore.load(key: hiveKey.name);

  if (timerHash != null && timer.hashCode != timerHash) {
    timer.cancel();
  }
}

void toggleBottomNav(ScrollController scroll) {
  HomeMenuController controller = Get.find<HomeMenuController>();

  if (scroll.position.pixels.floor() == 0) {
    controller.hideBottomNav.value = false;
  } else {
    if (scroll.position.userScrollDirection == ScrollDirection.reverse) {
      controller.hideBottomNav.value = true;
    } else if (scroll.position.userScrollDirection == ScrollDirection.forward) {
      controller.hideBottomNav.value = false;
    }
  }
}

String formatMeterToKilometer(int meter) {
  String kilometer;

  if (meter == 0) {
    kilometer = '0';
  } else {
    kilometer = (meter / 1000).toString();
  }

  return kilometer;
}

void handleRoute(String route) {
  if ((Get.currentRoute != Routes.login || Get.currentRoute != Routes.loading) && Get.isRegistered<HomeMenuController>()) {
    if (route.contains('challenge')) {
      Get.find<HomeMenuController>().selectMenu(0);
    } else if (route.contains('inventory')) {
      Get.find<HomeMenuController>().selectMenu(1);
    } else if (route.contains('shop')) {
      Get.find<HomeMenuController>().selectMenu(3);
    } else if (route.contains('leaderboard')) {
      Get.find<HomeMenuController>().selectMenu(4);
    }

    if (Get.currentRoute != Routes.home) {
      Get.until((route) => Get.currentRoute == Routes.home);
    }

    Get.toNamed(route);
  } else {
    HiveStore.save(key: HiveKey.dynamicLinkRoute.name, value: route);
  }
}

void handlePendingDynamicLink() {
  String? pendingRoute = HiveStore.loadString(key: HiveKey.dynamicLinkRoute.name);

  if (pendingRoute != null) {
    handleRoute(pendingRoute);
    HiveStore.deleteKey(key: HiveKey.dynamicLinkRoute.name);
  }
}

Future<bool> handleCheckUserVerified() async {
  bool isVerified = HiveStore.load(key: HiveKey.certified.name) ?? false;

  if (!isVerified) {
    await UaaService.getAccountInfo(
      successCallback: (UserAccountModel user) {
        if (user.authorities!.contains('ROLE_CERTIFIED_USER')) {
          HiveStore.save(key: HiveKey.certified.name, value: true);
          isVerified = true;
        } else {
          isVerified = false;
        }
      },
    );
  }

  return isVerified;
}

void moveToVerification() {
  print(Get.currentRoute);
  HiveStore.save(key: HiveKey.enteredRoute.name, value: Get.currentRoute);
  Get.back();
  Get.toNamed(Routes.verificationTerms);
}

FeedTemplate? generateFeedTemplate(Uri shareUrl, {required ChallengeType challengeType, required ShareSource shareSource, String? crewName}) {
  FeedTemplate? template;
  switch (challengeType) {
    case ChallengeType.crew:
    default:
      switch (shareSource) {
        case ShareSource.shareAppbar:
          template = FeedTemplate(
            content: Content(
              imageUrl: Uri.parse('https://s3.ap-northeast-2.amazonaws.com/image.staika.io/social/share_crew_relay.png'),
              imageHeight: 400,
              imageWidth: 400,
              title: '세상에 없던 가자고 단체전 챌린지⚡',
              description: '친구와 같이 걸음블럭을 쌓으며 즐기는 단체전 챌린지! 지금 확인 해 보세요!',
              link: Link(
                webUrl: shareUrl,
                mobileWebUrl: shareUrl,
              ),
            ),
            buttonTitle: '크루릴레이 구경하기',
          );
          break;
        case ShareSource.createCrew:
          template = FeedTemplate(
            content: Content(
              imageUrl: Uri.parse('https://s3.ap-northeast-2.amazonaws.com/image.staika.io/social/share_crew_relay.png'),
              imageHeight: 400,
              imageWidth: 400,
              title: '너를 초대하면 3000TIK을 아낄 수 있더라구…🙄',
              description: '꼭.. 와달라는건 아니구...구경해보고 맘에 들면 말해줘.. 블럭 받게 해줄게!',
              link: Link(
                webUrl: shareUrl,
                mobileWebUrl: shareUrl,
              ),
            ),
            buttonTitle: '크루릴레이 구경하기',
          );
          break;
        case ShareSource.crewDetail:
          template = FeedTemplate(
            content: Content(
              imageUrl: Uri.parse('https://s3.ap-northeast-2.amazonaws.com/image.staika.io/social/share_crew.png'),
              imageHeight: 400,
              imageWidth: 400,
              title: '너, ${crewName!} 크루가 돼라!🎯\n${crewName} 크루에서 당신을 초대했어요.',
              description: '지금 참여하면 걸음블럭 2개를 쌓을 수 있어요!',
              link: Link(
                webUrl: shareUrl,
                mobileWebUrl: shareUrl,
              ),
            ),
            buttonTitle: '크루릴레이 참여하기',
          );
          break;
      }
      break;
  }
  return template;
}
