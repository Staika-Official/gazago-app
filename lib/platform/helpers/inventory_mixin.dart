import 'dart:developer';

import 'package:gaza_go/platform/models/inventory_badge_model.dart';
import 'package:gaza_go/platform/services/badge_service.dart';
import 'package:get/get.dart';

class InventoryMixin {
  final RxList<InventoryBadgeModel> userBadgesList = RxList.empty();

  void getUserBadgesList() async {
    List<InventoryBadgeModel> badges = await BadgeService.getUserBadgesList();
    userBadgesList.value = badges;
    inspect('1111$badges');
  }
}
