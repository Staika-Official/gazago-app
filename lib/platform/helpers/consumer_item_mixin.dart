import 'dart:async';

import 'package:gaza_go/platform/helpers/alert_helper.dart';
import 'package:gaza_go/platform/helpers/base_helper.dart';
import 'package:gaza_go/platform/models/error_response_data_model.dart';
import 'package:gaza_go/platform/models/inventory_item_model.dart';
import 'package:gaza_go/platform/models/recovery_stamina_model.dart';
import 'package:gaza_go/platform/models/repair_shoes_model.dart';
import 'package:gaza_go/platform/models/repair_use_item_model.dart';
import 'package:gaza_go/platform/services/item_service.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

mixin ConsumerItemMixin {
  // InventoryController inventoryController = Get.isRegistered<InventoryController>() ? Get.find<InventoryController>() : Get.put(InventoryController());
  // final RxDouble equippedShoesDurability = RxDouble(0.0);
  RxInt targetShoeId = RxInt(0);
  RxString selectedType = RxString('');
  RxDouble currentStat = RxDouble(0.0);
  RxList consumerItemList = RxList.empty(growable: true);
  RxBool isDisableButton = RxBool(false);
  RxList<RepairUseItemModel> selectedConsumerItemList = RxList.empty(growable: true);

  RxDouble get resultStat {
    return RxDouble(currentStat.value + totalStat);
  }

  int get totalStat {
    int totalRepair = 0;
    if (selectedConsumerItemList.isNotEmpty) {
      for (int i = 0; i < selectedConsumerItemList.length; i++) {
        int itemId = selectedConsumerItemList[i].userItemId!;
        int amount = selectedConsumerItemList[i].spendItemAmount!;

        // 해당 itemId로 recoveryList에서 회복량 찾기
        for (int j = 0; j < consumerItemList.length; j++) {
          if (consumerItemList[j].id == itemId) {
            int repair = selectedType.value == 'STAMINA' ? consumerItemList[j].itemStat.recoveryStamina!.toInt() : consumerItemList[j].itemStat.repairDurability!.toInt();
            totalRepair += repair * amount;
          }
        }
      }

      return totalRepair;
    }
    return 0;
  }

  void initStat() {
    targetShoeId.value = 0;
    selectedType.value = '';
    currentStat.value = 0.0;
    resultStat.value = 0.0;
    Future.delayed(const Duration(milliseconds: 500));
    consumerItemList.value = RxList.empty();
    selectedConsumerItemList.value = RxList.empty();
    // selectedConsumerItemList.refresh();
  }

  RepairUseItemModel getRepairUseItem(int itemId) {
    if (selectedConsumerItemList.isNotEmpty && itemId != 0) {
      return selectedConsumerItemList.firstWhere((item) => item.userItemId == itemId, orElse: () => RepairUseItemModel());
    }
    return RepairUseItemModel();
  }

  void updateSpendCount(RepairUseItemModel item, int updatedCount) {
    item.spendItemAmount = updatedCount;
    selectedConsumerItemList.refresh();
  }

  Future<void> fetchRecoveryStamina() async {
    String uuid = const Uuid().v4();
    await ItemService.fetchRecoveryStamina(
      RecoveryStaminaModel(
        recoveryUuid: uuid,
        recoveryItems: selectedConsumerItemList,
      ),
      successCallback: (repairModel) async {
        showToastPopup('+${formatDecimalPlaces(totalStat.toDouble(), 0)} 체력 회복이 되었습니다.');
      },
      errorCallback: (ErrorResponseDataModel data) {
        showToastPopup(data.errorMessage!);
      },
    );
  }

  Future<void> fetchRecoveryUseOneItem(InventoryItemModel useItem) async {
    String uuid = const Uuid().v4();
    await ItemService.fetchRecoveryStamina(
      RecoveryStaminaModel(
        recoveryUuid: uuid,
        recoveryItems: [
          RepairUseItemModel(
            userItemId: useItem.id,
            spendItemAmount: 1,
          ),
        ],
      ),
      successCallback: (repairModel) async {
        showToastPopup('+${formatDecimalPlaces(useItem.itemStat!.recoveryStamina!, 0)} 체력 회복이 되었습니다.');
      },
      errorCallback: (ErrorResponseDataModel data) {
        showToastPopup(data.errorMessage!);
      },
    );
  }

  Future<void> fetchRepairShoes() async {
    String uuid = const Uuid().v4();
    List<RepairUseItemModel> filteredList = selectedConsumerItemList.where((item) => item.spendItemAmount != 0).toList();

    await ItemService.fetchRepairItemShoes(
      targetShoeId.value,
      RepairShoesModel(
        repairUuid: uuid,
        repairItems: filteredList,
      ),
      successCallback: (repairModel) async {
        showToastPopup('+${formatDecimalPlaces(totalStat.toDouble(), 0)} 내구도 수리가 되었습니다.');
      },
      errorCallback: (ErrorResponseDataModel data) {
        showToastPopup(data.errorMessage!);
      },
    );
  }

  Future<void> fetchRepairShoesUseOneItem(InventoryItemModel useItem, int shoesId) async {
    String uuid = const Uuid().v4();
    await ItemService.fetchRepairItemShoes(
      shoesId,
      RepairShoesModel(
        repairUuid: uuid,
        repairItems: [
          RepairUseItemModel(
            userItemId: useItem.id,
            spendItemAmount: 1,
          ),
        ],
      ),
      successCallback: (repairModel) async {
        showToastPopup('+${formatDecimalPlaces(useItem.itemStat!.repairDurability!, 0)} 내구도 수리가 되었습니다.');
      },
      errorCallback: (ErrorResponseDataModel data) {
        showToastPopup(data.errorMessage!);
      },
    );
  }

  void initRepairInfo() {
    // remainDurability.value = 0;
    // recoveryStamina.value = 0;
  }

  Future<void> getMyConsumerItemsByType(String itemType, {required Function isNotEmptyCallback, required Function isEmptyCallback}) async {
    await ItemService.getUserConsumerItemByType(itemType, successCallback: (data) {
      consumerItemList.value = data;

      print(consumerItemList.isNotEmpty);
      if (consumerItemList.isNotEmpty) {
        for (var item in consumerItemList) {
          RepairUseItemModel counterObj = RepairUseItemModel();
          counterObj.userItemId = item.id;
          counterObj.spendItemAmount = 0;
          selectedConsumerItemList.add(counterObj);
        }
        isNotEmptyCallback();
      } else {
        isEmptyCallback();
      }
    });
  }

  void closeRepairOrRecoveryPopup() {
    initRepairInfo();
    Get.back();
  }
}
