import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:gaza_go/constants/routes.dart';
import 'package:gaza_go/platform/helpers/base_helper.dart';
import 'package:gaza_go/platform/models/archive_detail_item_model.dart';
import 'package:gaza_go/platform/models/archive_list_item_model.dart';
import 'package:gaza_go/platform/services/archive_service.dart';
import 'package:get/get.dart';

class ArchiveController extends GetxController {
  RxList<ArchiveListItemModel> archiveList = RxList.empty();
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
  void onInit() {
    getArchiveList();
    super.onInit();
  }

  Future<void> getArchiveList() async {
    archiveList.value = await ArchiveService.getArchiveList();
    return Future(() => null);
  }

  void toDetail(int id) async {
    selectedItem.value = await ArchiveService.getArchiveItem(id);
    Get.toNamed(Routes.archiveDetail);
  }
}
