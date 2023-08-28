import 'package:gaza_go/platform/models/inventory_badge_list_model.dart';
import 'package:gaza_go/platform/services/badge_service.dart';
import 'package:get/get.dart';

class InventoryMixin {
  final RxList<InventoryBadgeListModel> userBadgesList = RxList.empty();
  final RxList userRepairKitList = RxList.empty();

  Future<void> getUserBadgesList() async {
    await BadgeService.getUserBadgesList(
      successCallback: (badges) {
        userBadgesList.value = badges;
      },
    );
  }
}
