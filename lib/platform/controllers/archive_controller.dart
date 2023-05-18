import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:gaza_go/constants/routes.dart';
import 'package:gaza_go/platform/controllers/loader_controller.dart';
import 'package:gaza_go/platform/helpers/alert_helper.dart';
import 'package:gaza_go/platform/helpers/base_helper.dart';
import 'package:gaza_go/platform/helpers/location_helper.dart';
import 'package:gaza_go/platform/models/archive_detail_item_model.dart';
import 'package:gaza_go/platform/models/archive_list_item_model.dart';
import 'package:gaza_go/platform/services/archive_service.dart';
import 'package:gaza_go/presentations/components/alert_ui_list.dart';
import 'package:get/get.dart';

class ArchiveController extends GetxController with ScrollMixin {
  LoaderController loaderController = Get.put(LoaderController());
  RxList<ArchiveListItemModel> archiveList = RxList.empty();
  RxInt page = RxInt(0);
  RxBool stopLoading = RxBool(false);
  RxBool dataGetLoading = RxBool(false);
  Rx<ArchiveDetailItemModel> selectedItem = Rx(ArchiveDetailItemModel());
  RxList<LatLng> locations = RxList.empty();

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
    await ArchiveService.getArchiveItem(id, Platform.operatingSystem, successCallback: (archive) async {
      loaderController.isLoading.value = false;
      dataGetLoading.value = false;
      selectedItem.value = archive;
      await initialiseLocations();
      Get.toNamed(Routes.archiveDetail);
    });
  }

  void recordMapCreated(NaverMapController controller, RxList<LatLng> locations) {
    if (locations.length > 1) {
      double highestLat = locations.reduce((previousValue, element) => previousValue.latitude > element.latitude ? previousValue : element).latitude;
      double lowestLat = locations.reduce((previousValue, element) => previousValue.latitude < element.latitude ? previousValue : element).latitude;
      double highestLng = locations.reduce((previousValue, element) => previousValue.longitude > element.longitude ? previousValue : element).longitude;
      double lowestLng = locations.reduce((previousValue, element) => previousValue.longitude < element.longitude ? previousValue : element).longitude;

      controller.moveCamera(
        CameraUpdate.fitBounds(
          LatLngBounds(
            northeast: LatLng(highestLat, highestLng),
            southwest: LatLng(lowestLat, lowestLng),
          ),
          padding: 50,
        ),
      );
    }
  }

  void deleteItem(int id) {
    void successCallback() {
      archiveList.removeWhere((archive) => archive.id == id);
      Get.until((route) => Get.isBottomSheetOpen == false);
      Get.back();
      showToastPopup('기록을 성공적으로 삭제했습니다.');
      Timer(const Duration(milliseconds: 200), () {
        toggleBottomNav(scroll);
      });
    }

    void errorCallback() {
      showToastPopup('기록 삭제에 실패했습니다.');
    }

    ArchiveService.deleteArchiveItem(id, successCallback: successCallback, errorCallback: errorCallback);
  }

  void showConfirmDelete(int id) {
    showDeleteRecordAlert(this, id);
  }

  getArchiveTypeImage(archive) {
    if (archive.type == 'HIKING') {
      if (archive.challengeId != null) {
        return const Svg('assets/images/archive/ico_mountain_100.svg');
      } else {
        return const Svg('assets/images/archive/ico_hiking.svg');
      }
    } else {
      return const Svg('assets/images/archive/ico_walking.svg');
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
      if (location[0].runtimeType == String || location[1].runtimeType == String) {
        coordinate = LatLng(double.parse(location[0]), double.parse(location[1]));
      } else {
        coordinate = LatLng(location[0], location[1]);
      }

      coordinates.add(coordinate);
    }
    locations.addAll(coordinates);
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
    print('top reached');
    return Future.delayed(
      const Duration(milliseconds: 10),
      () {
        print('top reached');
      },
    );
  }
}
