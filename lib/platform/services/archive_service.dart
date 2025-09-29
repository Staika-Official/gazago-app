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

  static Future<void> getArchiveList(int page,
      {required Function successCallback, Function? errorCallback}) async {
    Response res = await ArchiveApi.getArchiveList(userId!, page);
    if (res.statusCode == 200) {
      List<ArchiveListItemModel> archiveList = List.empty(growable: true);
      if (res.data.length > 0) {
        res.data.forEach((archive) {
          archiveList.add(ArchiveListItemModel.fromJson(archive));
        });
      }
      successCallback(archiveList);
    } else {
      if (errorCallback != null) errorCallback();
    }
  }

  static Future<void> getArchiveItem(int archiveId, String platform,
      {required Function successCallback, Function? errorCallback}) async {
    Response res =
        await ArchiveApi.getArchiveItem(userId!, archiveId, platform);
    if (res.statusCode == 200) {
      if (res.data is List) {
        if (res.data.isNotEmpty) {
          final archiveDetail = ArchiveDetailItemModel.fromJson(res.data[0]);
          successCallback(archiveDetail);
        }
      } else if (res.data is Map) {
        final archiveDetail = ArchiveDetailItemModel.fromJson(res.data);
        successCallback(archiveDetail);
      }
    } else {
      if (errorCallback != null) errorCallback();
    }
  }

  static Future<void> deleteArchiveItem(int archiveId,
      {required Function successCallback, Function? errorCallback}) async {
    Response res = await ArchiveApi.deleteArchiveItem(userId!, archiveId);
    if (res.statusCode == 204) {
      successCallback();
    } else {
      if (errorCallback != null) errorCallback();
    }
  }
}
