import 'dart:io';

import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:gaza_go/constants/routes.dart';
import 'package:gaza_go/platform/helpers/alert_helper.dart';
import 'package:gaza_go/platform/helpers/base_helper.dart';
import 'package:gaza_go/platform/models/archive_detail_item_model.dart';
import 'package:gaza_go/platform/models/archive_list_item_model.dart';
import 'package:gaza_go/platform/services/archive_service.dart';
import 'package:gaza_go/presentations/components/alert_ui_list.dart';
import 'package:get/get.dart';

class ArchiveController extends GetxController with ScrollMixin {
  RxList<ArchiveListItemModel> archiveList = RxList.empty();
  RxInt page = RxInt(0);
  RxBool stopLoading = RxBool(false);
  RxBool dataGetLoading = RxBool(false);
  Rx<ArchiveDetailItemModel> selectedItem = Rx(ArchiveDetailItemModel());
  RxList<LatLng> get locations {
    List<LatLng> locations = locationStringToLatLng(selectedItem.value.locations!);
    if (selectedItem.value.locations != null && locations.length > 1) {
      return RxList(locations);
    } else {
      return RxList.empty();
    }
  }

  @override
  void onInit() async {
    await initController();
    super.onInit();
  }

  Future<void> initController() async {
    await getArchiveList();
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
    await ArchiveService.getArchiveItem(id, Platform.operatingSystem, successCallback: (archive) {
      selectedItem.value = archive;
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
    }

    void errorCallback() {
      showToastPopup('기록 삭제에 실패했습니다.');
    }

    ArchiveService.deleteArchiveItem(id, successCallback: successCallback, errorCallback: errorCallback);
  }

  void showConfirmDelete(int id) {
    showDeleteRecordAlert(this, id);
  }

  getArchiveTypeImage(archiveType) {
    switch (archiveType) {
      case 'FAMOUS_MOUNTAIN_100':
        return const Svg('assets/images/archive/ico_mountain_100.svg');
      case 'WALKING':
        return const Svg('assets/images/archive/ico_walking.svg');
      case 'HIKING':
        return const Svg('assets/images/archive/ico_hiking.svg');
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
    print('top reached');
    return Future.delayed(
      const Duration(milliseconds: 10),
      () {
        print('top reached');
      },
    );
  }
}
