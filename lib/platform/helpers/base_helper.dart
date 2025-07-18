import 'dart:async';
import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/constants/routes.dart';
import 'package:gaza_go/platform/controllers/challenges_controller.dart';
import 'package:gaza_go/platform/controllers/home_menu_controller.dart';
import 'package:gaza_go/platform/firebase/remote_config.dart';
import 'package:gaza_go/platform/models/new_challenge_detail_model.dart';
import 'package:gaza_go/platform/models/user_account_model.dart';
import 'package:gaza_go/platform/services/activity_service.dart';
import 'package:gaza_go/platform/services/uaa_service.dart';
import 'package:gaza_go/platform/stores/hive_store.dart';
import 'package:gaza_go/presentations/components/mirae/alert_ui_list.dart';
import 'package:gaza_go/theme/theme.g.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:get/get.dart' hide Trans;
import 'package:intl/intl.dart';
import 'package:kakao_flutter_sdk_share/kakao_flutter_sdk_share.dart';
import 'package:package_info_plus/package_info_plus.dart';

Future<bool> isForceUpdateTarget() async {
  await FirebaseRemoteConfig.instance.fetchAndActivate();
  String remoteAppVersion =
      getConfig(dataType: ConfigType.string, configKey: 'minimum_app_version');
  return await compareVersion(remoteAppVersion);
}

Future<bool> isRecommendUpdateTarget() async {
  String remoteAppVersion = getConfig(
      dataType: ConfigType.string, configKey: 'recommended_app_version');
  return await compareVersion(remoteAppVersion);
}

Future<bool> compareVersion(String versionString) async {
  String remoteAppVersion = versionString;
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  List<int> splitVersionString(String versionString) {
    return versionString
        .split('.')
        .map((element) => int.parse(element))
        .toList();
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
    return DateFormat("yyyy.MM.dd HH:mm:ss")
        .format(DateTime.parse(isoDateString).toLocal());
  } else {
    return '';
  }
}

String formatHipenDate(String? isoDateString) {
  if (isoDateString != null) {
    return DateFormat("yyyy-MM-dd HH:mm:ss")
        .format(DateTime.parse(isoDateString).toLocal());
  } else {
    return '';
  }
}

String formatDateUntilDay(String? isoDateString) {
  if (isoDateString != null) {
    return DateFormat("yyyy-MM-dd")
        .format(DateTime.parse(isoDateString).toLocal());
  } else {
    return '';
  }
}

String formatDateUntilTime(String? isoDateString) {
  if (isoDateString != null) {
    return DateFormat("yyyy-MM-dd HH:mm")
        .format(DateTime.parse(isoDateString).toLocal());
  } else {
    return '';
  }
}

String formatDateMonthUntilTime(String? isoDateString) {
  if (isoDateString != null) {
    return DateFormat("MM.dd (HH:mm)")
        .format(DateTime.parse(isoDateString).toLocal());
  } else {
    return '';
  }
}

String calculateDuration(String? fromDateString, String? toDateString) {
  if (fromDateString == null || toDateString == null) return '0';
  DateTime fromDate = DateTime.parse(fromDateString).toLocal();
  DateTime toDate = DateTime.parse(toDateString).toLocal();
  DateTime formattedFromDate =
      DateTime(fromDate.year, fromDate.month, fromDate.day);
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

String formatDecimalPlaces(double val, int decimalPlaces,
    {RoundType roundType = RoundType.floor, bool isAutoDecimal = false}) {
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
  const availableChars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  final randomString = List.generate(length,
      (index) => availableChars[random.nextInt(availableChars.length)]).join();

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

void handleRoute(String route) async {
  if ((Get.currentRoute != Routes.login ||
          Get.currentRoute != Routes.loading) &&
      Get.isRegistered<HomeMenuController>()) {
    if (route.contains('challenge')) {
      Get.find<HomeMenuController>().selectMenu(0);
    } else if (route.contains('inventory')) {
      Get.find<HomeMenuController>().selectMenu(1);
    } else if (route.contains('shop')) {
      Get.find<HomeMenuController>().selectMenu(3);
    } else if (route.contains('leaderboard')) {
      Get.find<HomeMenuController>().selectMenu(4);
    }
    if (!route.contains('challenge_detail')) {
      if (Get.currentRoute != Routes.home) {
        Get.until((route) => Get.currentRoute == Routes.home);
      }

      Get.toNamed(route);
    }
    if (route.contains('company_challenge_detail')) {
      if (Get.currentRoute != Routes.home) {
        Get.until((route) => Get.currentRoute == Routes.home);
      }

      String? challengeId = route.split('company_challenge_detail/')[1];

      await ActivityService.getChallengeDetails(int.parse(challengeId),
          successCallback: (NewChallengeDetailModel data) {
        // if(Get.isDialogOpen == true){
        //   Get.back();
        // }
        if (data.challengeUserState == null) {
          miraeAssetAlert(int.parse(challengeId), null);
        } else {
          miraeAssetAlert(int.parse(challengeId), data.challengeUserState!);
        }
      });
    }
  } else {
    HiveStore.save(key: HiveKey.dynamicLinkRoute.name, value: route);
  }
}

Future<void> getChallengeDetail(challengeId) async {
  String? userId = HiveStore.loadString(key: HiveKey.userId.name);
  ChallengesController challengesController =
      Get.isRegistered<ChallengesController>()
          ? Get.find<ChallengesController>()
          : Get.put(ChallengesController());
  await ActivityService.getChallengeDetails(int.parse(challengeId),
      successCallback: (NewChallengeDetailModel data) async {
    DatabaseReference userDiInfoRef = FirebaseDatabase.instance
        .ref('crewChallengeLeaderboard/$challengeId/$userId');
    await userDiInfoRef.get().then((DataSnapshot snapshot) async {
      if (snapshot.exists) {
        Get.find<HomeMenuController>().selectMenu(0);
        Get.toNamed(Routes.companyChallengeDetail
            .replaceAll(':id', challengeId.toString()));
      } else {
        if (data.challengeState == 'READY') {
          if (data.challengeUserState == 'REGISTER_READY') {
            notOpenCompanyChallenge();
          } else {
            participateInMiraeChallengeByCodeAlert(challengeId);
          }
        } else if (data.challengeState == 'IN_PROGRESS') {
          if (data.challengeUserState != 'JOIN_CLOSED') {
            closedCompanyChallenge();
          } else {
            participateInMiraeChallengeByCodeAlert(challengeId);
          }
        } else {
          closedCompanyChallenge();
        }
      }
    }).onError((error, stackTrace) {});
  });
}

void handlePendingDynamicLink() {
  String? pendingRoute =
      HiveStore.loadString(key: HiveKey.dynamicLinkRoute.name);

  if (pendingRoute != null) {
    handleRoute(pendingRoute);
    HiveStore.deleteKey(key: HiveKey.dynamicLinkRoute.name);
  }
}

Future<bool> handleCheckUserVerified() async {
  // 한국이 아닌 경우 인증 비활성화
  if (!isKoreaRegion()) {
    return true; // 인증 완료로 처리
  }
  
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

  // 한국 지역인지 확인하는 함수
  bool isKoreaRegion() {
 
   // 1. 디바이스 로케일로 확인
   try {
     String deviceLocale = Get.locale?.languageCode ?? 'ko';
     return deviceLocale == 'ko';
   } catch (e) {
    // 에러 발생 시 기본값으로 한국 설정
    return true;
  }
}

void moveToVerification() {
  HiveStore.save(key: HiveKey.enteredRoute.name, value: Get.currentRoute);
  Get.back();
  Get.toNamed(Routes.verificationTerms);
}

FeedTemplate? generateFeedTemplate(Uri shareUrl,
    {required ChallengeType challengeType,
    required ShareSource shareSource,
    String? crewName}) {
  FeedTemplate? template;
  switch (challengeType) {
    case ChallengeType.crew:
    default:
      switch (shareSource) {
        case ShareSource.shareAppbar:
          template = FeedTemplate(
            content: Content(
              imageUrl: Uri.parse(
                  'https://s3.ap-northeast-2.amazonaws.com/image.staika.io/social/share_crew_relay.png'),
              imageHeight: 400,
              imageWidth: 400,
              title: 'gajago_team_challenge'.tr(),
              description: 'team_challenge_description'.tr(),
              link: Link(
                webUrl: shareUrl,
                mobileWebUrl: shareUrl,
              ),
            ),
            buttonTitle: 'view_crew_relay'.tr(),
          );
          break;
        case ShareSource.createCrew:
          template = FeedTemplate(
            content: Content(
              imageUrl: Uri.parse(
                  'https://s3.ap-northeast-2.amazonaws.com/image.staika.io/social/share_crew_relay.png'),
              imageHeight: 400,
              imageWidth: 400,
              title: 'invite_friend_save_tik'.tr(),
              description: 'crew_invite_optional'.tr(),
              link: Link(
                webUrl: shareUrl,
                mobileWebUrl: shareUrl,
              ),
            ),
            buttonTitle: 'view_crew_relay'.tr(),
          );
          break;
        case ShareSource.crewDetail:
          template = FeedTemplate(
            content: Content(
              imageUrl: Uri.parse(
                  'https://s3.ap-northeast-2.amazonaws.com/image.staika.io/social/share_crew.png'),
              imageHeight: 400,
              imageWidth: 400,
              title: 'crew_invite'.tr(args: [crewName!, crewName]),
              description: 'join_now_get_blocks'.tr(),
              link: Link(
                webUrl: shareUrl,
                mobileWebUrl: shareUrl,
              ),
            ),
            buttonTitle: 'join_crew_relay'.tr(),
          );
          break;
      }
      break;
  }
  return template;
}

double productSumFeePrice(String price, String fee) {
  double result;

  result = double.parse(price) + double.parse(fee);

  return result;
}

double productMinusFeePrice(String price, String fee) {
  double result;

  result = double.parse(price) - double.parse(fee);

  return result;
}

Color renderDifficultyColor(String difficulty) {
  Color color = Colors.transparent;

  switch (difficulty) {
    case 'LEVEL_1':
      color = AppColorData.regular().colorPointGreen;
      break;
    case 'LEVEL_2':
      color = AppColorData.regular().colorPointCyan;
      break;
    case 'LEVEL_3':
      color = AppColorData.regular().colorPointPurple;
      break;
    case 'LEVEL_4':
      color = AppColorData.regular().colorTextWarning;
      break;
  }

  return color;
}

String renderDifficultyText(String difficulty) {
  String text = '';

  switch (difficulty) {
    case 'LEVEL_1':
      text = 'Easy';
      break;
    case 'LEVEL_2':
      text = 'Normal';
      break;
    case 'LEVEL_3':
      text = 'Hard';
      break;
    case 'LEVEL_4':
      text = 'Extreme';
      break;
  }

  return text;
}
