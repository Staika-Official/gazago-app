import 'package:gaza_go/constants/routes.dart';
import 'package:gaza_go/platform/models/archive_item_model.dart';
import 'package:gaza_go/platform/services/archive_service.dart';
import 'package:get/get.dart';

class ArchiveController extends GetxController {
  RxList<ArchiveItemModel> archiveList = RxList.empty();
  Rx<ArchiveItemModel> selectedItem = Rx(ArchiveItemModel());
  // RxList<LatLng> get locations {
  //   if (selectedItem.value.locations != null) {
  //     return RxList(locationStringToLatLng(selectedItem.value.locations!));
  //   } else {
  //     return RxList.empty();
  //   }
  // }

  @override
  void onInit() {
    getArchiveList();
    super.onInit();
  }

  Future<void> getArchiveList() async {
    archiveList.value = await ArchiveService.getArchiveList();
    return Future(() => null);
  }

  void toDetail(int id) {
    selectedItem.value = archiveList.firstWhere((archive) => archive.id == id);
    Get.toNamed(Routes.archiveDetail);
  }
}
