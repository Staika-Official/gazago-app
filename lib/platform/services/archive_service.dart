import 'package:dio/dio.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/platform/apis/archive.dart';
import 'package:gaza_go/platform/models/archive_detail_item_model.dart';
import 'package:gaza_go/platform/models/archive_list_item_model.dart';
import 'package:gaza_go/platform/stores/hive_store.dart';

class ArchiveService {
  static String? get userId {
    return HiveStore.loadString(key: HiveKey.userId.name);
  }

  static Future<void> getArchiveList(int page, {required Function successCallback, Function? errorCallback}) async {
    Response res = await ArchiveApi.getArchiveList(userId!, page);
    if (res.statusCode == 200) {
      List<ArchiveListItemModel> archiveList = List.empty(growable: true);
      res.data.forEach((archive) {
        archiveList.add(ArchiveListItemModel.fromJson(archive));
      });
      successCallback(archiveList);
    } else {
      if (errorCallback != null) errorCallback();
    }
  }

  static Future<void> getArchiveItem(int archiveId, String platform, {required Function successCallback, Function? errorCallback}) async {
    Response res = await ArchiveApi.getArchiveItem(userId!, archiveId, platform);
    if (res.statusCode == 200) {
      successCallback(ArchiveDetailItemModel.fromJson(res.data));
    } else {
      if (errorCallback != null) errorCallback();
    }
  }

  static Future<void> deleteArchiveItem(int archiveId, {required Function successCallback, Function? errorCallback}) async {
    Response res = await ArchiveApi.deleteArchiveItem(userId!, archiveId);
    if (res.statusCode == 204) {
      successCallback();
    } else {
      if (errorCallback != null) errorCallback();
    }
  }
}
