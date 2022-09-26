import 'package:gaza_go/constants/routes.dart';
import 'package:gaza_go/platform/models/archive_item_model.dart';
import 'package:gaza_go/platform/services/archive_service.dart';
import 'package:get/get.dart';

class ArchiveController extends GetxController {
  RxList<ArchiveItemModel> archiveList = RxList.empty();
  Rx<ArchiveItemModel> selectedItem = Rx(ArchiveItemModel());
  // Rx<List<LatLng>> get locations {
  //   if (selectedItem.value.locations != null) {
  //     List<String> locationsArray = selectedItem.value.locations!.split(',');
  //     List<LatLng> parsedList = List.empty(growable: true);
  //     locationsArray.forEach((locationString) {
  //       List<String> coordinates = locationString.split(',');
  //       parsedList.add(LatLng(double.parse(coordinates[0]), double.parse(coordinates[1])));
  //     });
  //     return Rx(parsedList);
  //   } else {
  //     return Rx(List.empty());
  //   }
  // }

  @override
  void onInit() {
    getArchiveList();
    super.onInit();
  }

  void getArchiveList() async {
    archiveList.value = await ArchiveService.getArchiveList();
  }

  void toDetail(int id) {
    selectedItem.value = archiveList.firstWhere((archive) => archive.id == id);
    Get.toNamed(Routes.archiveDetail);
  }
}
