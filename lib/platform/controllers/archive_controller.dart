import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:gaza_go/platform/models/error_response_data_model.dart';
import 'package:gaza_go/platform/models/request/get_exercise_reward_request_model.dart';
import 'package:gaza_go/platform/models/treasure_model.dart';
import 'package:gaza_go/platform/services/treasure_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:gaza_go/constants/routes.dart';
import 'package:gaza_go/platform/controllers/loader_controller.dart';
import 'package:gaza_go/platform/helpers/alert_helper.dart';
import 'package:gaza_go/platform/helpers/base_helper.dart';
import 'package:gaza_go/platform/helpers/location_helper.dart';
import 'package:gaza_go/platform/helpers/map_mixin.dart';
import 'package:gaza_go/platform/models/archive_detail_item_model.dart';
import 'package:gaza_go/platform/models/archive_list_item_model.dart';
import 'package:gaza_go/platform/services/archive_service.dart';
import 'package:gaza_go/presentations/components/alert_ui_list.dart';
import 'package:gaza_go/presentations/styles/icons.dart';
import 'package:get/get.dart' hide Trans;
import 'package:jiffy/jiffy.dart';
import 'package:easy_localization/easy_localization.dart';

class ArchiveController extends GetxController with ScrollMixin, MapMixin {
  LoaderController loaderController = Get.put(LoaderController());
  RxList<ArchiveListItemModel> archiveList = RxList.empty();
  RxInt page = RxInt(0);
  RxBool stopLoading = RxBool(false);
  RxBool dataGetLoading = RxBool(false);
  Rx<ArchiveDetailItemModel> selectedItem = Rx(ArchiveDetailItemModel());
  RxList<LatLng> locations = RxList.empty();

  /// reward tab content fields
  RxList<TreasureModel> rewards = <TreasureModel>[].obs;
  var rewardPage = 0;
  var totalPages = 1;
  var isLoading = false.obs;

  @override
  void onInit() async {
    await initController();
    super.onInit();
  }

  @override
  void onClose() {
    scroll.removeListener(() => toggleBottomNav(scroll));
    super.onClose();
  }

  Future<void> initController() async {
    await getArchiveList();

    scroll.addListener(() => toggleBottomNav(scroll));
  }

  Future<void> refreshController() async {
    archiveList = RxList.empty();
    page.value = 0;
    stopLoading.value = false;
    await getArchiveList();
  }

  Future<void> getArchiveList() async {
    dataGetLoading.value = true;
    await ArchiveService.getArchiveList(
      page.value,
      successCallback: (records) {
        if (records.length < 20) {
          stopLoading.value = true;
        }
        archiveList.addAll(records);
        dataGetLoading.value = false;
      },
    );
  }

  void toDetail(int id) async {
    loaderController.isLoading.value = true;
    dataGetLoading.value = true;
    final twoMonthAgo = Jiffy.now().subtract(months: 2);
    await ArchiveService.getArchiveItem(id, Platform.operatingSystem,
        successCallback: (archive) async {
      loaderController.isLoading.value = false;
      dataGetLoading.value = false;
      if (archive != null) {
        selectedItem.value = archive;
        final targetDate =
            Jiffy.parse(archive.endedDate ?? DateTime.now().toString());
        selectedItem.value.isTwoMonthAgo = targetDate.isBefore(twoMonthAgo);
        if (targetDate.isBefore(twoMonthAgo)) {
          locations.value = RxList.empty();
        } else {
          await initialiseLocations();
        }
        Get.toNamed(Routes.archiveDetail);
      }
    });
  }

  void recordMapCreated(
      GoogleMapController controller, RxList<LatLng> locations) {
    if (locations.length > 1) {
      double highestLat = locations
          .reduce((previousValue, element) =>
              previousValue.latitude > element.latitude
                  ? previousValue
                  : element)
          .latitude;
      double lowestLat = locations
          .reduce((previousValue, element) =>
              previousValue.latitude < element.latitude
                  ? previousValue
                  : element)
          .latitude;
      double highestLng = locations
          .reduce((previousValue, element) =>
              previousValue.longitude > element.longitude
                  ? previousValue
                  : element)
          .longitude;
      double lowestLng = locations
          .reduce((previousValue, element) =>
              previousValue.longitude < element.longitude
                  ? previousValue
                  : element)
          .longitude;
      controller.animateCamera(
        CameraUpdate.newLatLngBounds(
            LatLngBounds(
              northeast: LatLng(highestLat, highestLng),
              southwest: LatLng(lowestLat, lowestLng),
            ),
            50),
      );
      // controller.moveCamera(
      //   CameraUpdate.fitBounds(
      //     LatLngBounds(
      //       northeast: LatLng(highestLat, highestLng),
      //       southwest: LatLng(lowestLat, lowestLng),
      //     ),
      //     padding: 50,
      //   ),
      // );
    }
  }

  void deleteItem(int id) {
    void successCallback() {
      archiveList.removeWhere((archive) => archive.id == id);
      Get.until((route) => Get.isBottomSheetOpen == false);
      Get.back();
      showToastPopup('record_deleted_successfully'.tr());
      Timer(const Duration(milliseconds: 200), () {
        if (scroll.hasClients) toggleBottomNav(scroll);
      });
    }

    void errorCallback() {
      showToastPopup('record_deletion_failed'.tr());
    }

    ArchiveService.deleteArchiveItem(id,
        successCallback: successCallback, errorCallback: errorCallback);
  }

  void showConfirmDelete(int id) {
    showDeleteRecordAlert(this, id);
  }

  getArchiveTypeImage(archive) {
    if (archive.type == 'HIKING') {
      if (archive.challengeId != null) {
        return iconArchiveMountain;
      } else {
        return iconArchiveHiking;
      }
    } else {
      return iconArchiveWalking;
    }
  }

  Future<void> initialiseLocations() async {
    locations.value = RxList.empty();
    List<dynamic> locationArray = List.empty(growable: true);
    List<LatLng> coordinates = List.empty(growable: true);
    LatLng coordinate;
    if (selectedItem.value.locationsStr != null) {
      locationArray = json.decode(selectedItem.value.locationsStr!);
    } else {
      locationArray = await getLocationsData(selectedItem.value.id!);
    }
    for (List location in locationArray) {
      if (location[0].runtimeType == String ||
          location[1].runtimeType == String) {
        coordinate =
            LatLng(double.parse(location[0]), double.parse(location[1]));
      } else {
        coordinate = LatLng(location[0], location[1]);
      }

      coordinates.add(coordinate);
    }
    locations.addAll(coordinates);
  }

  /// Get anti-cheat violation message based on antiCheatType
  String getAntiCheatMessage(String antiCheatType) {
    switch (antiCheatType) {
      case 'CHEAT_REGION_MISMATCH':
        return 'anti_cheat_region_mismatch'.tr();
      case 'CHEAT_SPEED_TOO_LOW':
        return 'anti_cheat_speed_too_low'.tr();
      case 'CHEAT_SPEED_TOO_HIGH':
        return 'anti_cheat_speed_too_high'.tr();
      case 'CHEAT_DISTANCE_NOT_INCREASED':
        return 'anti_cheat_distance_not_increased'.tr();
      case 'CHEAT_DISTANCE_INCONSISTENT':
        return 'anti_cheat_distance_inconsistent'.tr();
      case 'CHEAT_MIN_STEPS_NOT_MET':
        return 'anti_cheat_min_steps_not_met'.tr();
      case 'CHEAT_INVALID_STATE_TRANSITION':
        return 'anti_cheat_invalid_state_transition'.tr();
      case 'CHEAT_SHOES_BROKEN':
        return 'anti_cheat_shoes_broken'.tr();
      case 'CHEAT_NO_STAMINA':
        return 'anti_cheat_no_stamina'.tr();
      case 'CHEAT_DAILY_DISTANCE_LIMIT':
        return 'anti_cheat_daily_distance_limit'.tr();
      default:
        return 'anti_cheat_violation'.tr();
    }
  }

  /// Check if the exercise has anti-cheat violations
  bool hasAntiCheatViolation() {
    return selectedItem.value.antiCheatType != null &&
        selectedItem.value.antiCheatType != 'VALID';
  }

  Future<void> fetchRewards({bool refresh = false}) async {
    if (isLoading.value) return;
    if (!refresh && rewardPage >= totalPages) return;

    // Don't fetch rewards if exercise has anti-cheat violations
    if (hasAntiCheatViolation()) return;

    isLoading.value = true;

    try {
      if (refresh) {
        rewardPage = 0;
        rewards.clear();
      }

      final req = GetExerciseRewardRequestModel(
        userId: selectedItem.value.userId ?? -1,
        userExerciseId: selectedItem.value.id ?? -1,
        page: rewardPage,
      );

      await TreasureService.getExerciseRewards(
        req: req,
        successCallback: (response) {
          rewards.addAll(response.content);
          totalPages = response.totalPages;
          rewardPage++;
        },
        errorCallback: (ErrorResponseDataModel? error) {},
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  Future<void> onEndScroll() async {
    if (!stopLoading.value) {
      page.value++;
      await getArchiveList();
    }
  }

  @override
  Future<void> onTopScroll() {
    return Future.delayed(
      const Duration(milliseconds: 10),
      () {},
    );
  }
}
