import 'package:dio/dio.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/platform/apis/badge.dart';
import 'package:gaza_go/platform/apis/collection.dart';
import 'package:gaza_go/platform/models/collection_model.dart';
import 'package:gaza_go/platform/models/error_response_data_model.dart';
import 'package:gaza_go/platform/models/inventory_badge_list_model.dart';
import 'package:gaza_go/platform/models/inventory_badge_model.dart';
import 'package:gaza_go/platform/stores/hive_store.dart';

class CollectionService {
  static String? get userId {
    return HiveStore.loadString(key: HiveKey.userId.name);
  }

  static Future<void> getCollectionsList({required Function successCallback, Function? errorCallback}) async {
    Response res = await CollectionApi.getCollectionsList(userId!);
    if (res.statusCode == 200) {
      List<CollectionModel> collections = [];
      if (res.data.length > 0) {
        res.data.forEach((item) => collections.add(CollectionModel.fromJson(item)));
      }
      successCallback(collections);
    } else {
      if (errorCallback != null) errorCallback(res.data != null ? ErrorResponseDataModel.fromJson(res.data) : ErrorResponseDataModel());
    }
  }

}
