import 'package:get/get.dart';
import 'package:step_go/constants/routes.dart';
import 'package:step_go/platform/models/inventory_badge_model.dart';
import 'package:step_go/platform/models/stat_model.dart';

class InventoryController extends GetxController {
  final RxList<StatModel> statList = RxList.empty();
  RxList<InventoryBadgeModel> syntheticBadgeList = RxList.empty();
  RxList<InventoryBadgeModel> myBadgeList = RxList.empty();
  final RxBool isShoe = RxBool(true);
  Rx<InventoryBadgeModel> selectedBadge = Rx(InventoryBadgeModel(
    id: 1,
    badgeImageUrl: 'assets/images/@temp_badge.png',
    badgeName: '소래산 등정 뱃지',
    effect: 3,
    getDate: '2022.08.29',
    level: 1,
  ));

  @override
  void onInit() {
    initStats();
    getSyntheticBadgeList();
    getMyBadgeList();
    super.onInit();
  }

  void getSyntheticBadgeList() {
    syntheticBadgeList.value = [
      InventoryBadgeModel(
        id: 1,
        badgeImageUrl: 'assets/images/@temp_badge.png',
        badgeName: '소래산 등정 뱃지',
        effect: 3,
        getDate: '2022.08.29',
        level: 1,
      ),
      InventoryBadgeModel(
        id: 2,
        badgeImageUrl: 'assets/images/@temp_badge.png',
        badgeName: '소래산 등정 뱃지',
        effect: 3,
        getDate: '2022.08.29',
        level: 1,
      ),
    ];
  }

  void getMyBadgeList() {
    myBadgeList.value = [
      InventoryBadgeModel(
        id: 1,
        badgeImageUrl: 'assets/images/@temp_badge.png',
        badgeName: '소래산 등정 뱃지',
        effect: 3,
        getDate: '2022.08.29',
        level: 1,
      ),
      InventoryBadgeModel(
        id: 2,
        badgeImageUrl: 'assets/images/@temp_badge.png',
        badgeName: '소래산 등정 뱃지',
        effect: 3,
        getDate: '2022.08.29',
        level: 1,
      ),
    ];
  }

  void initStats() {
    statList.value = [
      StatModel(name: '이동 보상율', currentStat: 78),
      StatModel(name: '행운지수율', currentStat: 78),
    ];
  }

  void toBadgeDetail(int id) {
    selectedBadge.value = myBadgeList.firstWhere((badge) => badge.id == id);
    Get.toNamed(Routes.badgeDetail);
  }

  void toSyntheticBadgeDetail(int id) {
    selectedBadge.value = myBadgeList.firstWhere((badge) => badge.id == id);
    Get.toNamed(Routes.syntheticBadge);
  }
}
