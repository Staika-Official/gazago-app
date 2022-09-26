import 'package:dio/dio.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/platform/apis/item.dart';
import 'package:gaza_go/platform/models/repair_shoes_model.dart';
import 'package:gaza_go/platform/stores/hive_store.dart';

class ItemService {
  static final String? userId = HiveStore.loadString(key: HiveKey.userId.name);

  static Future<RepairShoesModel> fetchRepairItemShoes(RepairShoesModel repairInfo) async {
    Response res = await ItemApi.fetchRepairItemShoes(userId!, repairInfo);
    RepairShoesModel repairItemInfo = RepairShoesModel.fromJson(res.data);
    return repairItemInfo;
  }
}
