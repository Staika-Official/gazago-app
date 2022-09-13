import 'package:get/get.dart';
import 'package:step_go/platform/models/inventory_item_model.dart';

class InventoryController extends GetxController {
  final RxList<InventoryItemModel> statList = RxList.empty();

  @override
  void onInit() {
    initStats();
    super.onInit();
  }

  void initStats() {
    statList.value = [
      InventoryItemModel(name: '아이템 마모율', currentStat: 78),
      InventoryItemModel(name: '이동 보상율', currentStat: 78),
      InventoryItemModel(name: '체력 보상율', currentStat: 78),
    ];
  }
}
