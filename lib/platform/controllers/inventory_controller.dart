import 'package:gaza_go/constants/routes.dart';
import 'package:gaza_go/platform/apis/badge.dart';
import 'package:gaza_go/platform/models/inventory_badge_item_model.dart';
import 'package:gaza_go/platform/models/inventory_badge_model.dart';
import 'package:gaza_go/platform/models/stat_model.dart';
import 'package:get/get.dart';

class InventoryController extends GetxController {
  final RxList<StatModel> statList = RxList.empty();
  RxList<InventoryBadgeModel> syntheticBadgeList = RxList.empty();
  RxList<InventoryBadgeModel> userBadgesList = RxList.empty();
  final RxBool isShoe = RxBool(true);
  RxInt count = 0.obs;
  Rx<InventoryBadgeModel> selectedBadge = Rx(
    InventoryBadgeModel(
      id: -1,
      userId: -1,
      state: '',
      createdBy: '',
      createdDate: '',
      lastModifiedBy: '',
      lastModifiedDate: '',
      badge: InventoryBadgeItemModel(
        id: -1,
        level: 0,
        rewardRate: 0.0,
        luckRate: 0.0,
        source: '',
        issueType: '',
        issueState: '',
        issueStartedTime: '',
        issueEndedTime: '',
        description: '',
        state: '',
        address: '',
        imageUrl: 'imageUrl',
        createdBy: 'createdBy',
        createdDate: 'createdDate',
        lastModifiedBy: 'lastModifiedBy',
        lastModifiedDate: 'lastModifiedDate',
      ),
    ),
  );

  @override
  void onInit() {
    once(count, (_) => print('한번만 호출'));
    initStats();

    getSyntheticBadgeList();
    getUserBadgesList();
    super.onInit();
  }

  void getSyntheticBadgeList() {
    syntheticBadgeList.value = [];
  }

  void getUserBadgesList() async {
    List<InventoryBadgeModel> badges = await BadgeService.getUserBadgesList(3);
    userBadgesList.value = badges;
    print(userBadgesList.length);
  }

  void initStats() {
    statList.value = [
      StatModel(name: '이동 보상율', currentStat: 78),
      StatModel(name: '행운지수율', currentStat: 78),
    ];
  }

  void toBadgeDetail(int id) {
    selectedBadge.value = userBadgesList.firstWhere((item) => item.badge.id == id);
    Get.toNamed(Routes.badgeDetail);
  }

  void toSyntheticBadgeDetail(int id) {
    selectedBadge.value = userBadgesList.firstWhere((item) => item.badge.id == id);
    Get.toNamed(Routes.syntheticBadge);
  }
}
