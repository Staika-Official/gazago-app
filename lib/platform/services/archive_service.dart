import 'package:dio/dio.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/platform/apis/archive.dart';
import 'package:gaza_go/platform/models/archive_detail_item_model.dart';
import 'package:gaza_go/platform/models/archive_list_item_model.dart';
import 'package:gaza_go/platform/stores/hive_store.dart';

class ArchiveService {
  static final String? userId = HiveStore.loadString(key: HiveKey.userId.name);

  static Future<List<ArchiveListItemModel>> getArchiveList() async {
    Response res = await ArchiveApi.getArchiveList(userId!);
    List<ArchiveListItemModel> archiveList = List.empty(growable: true);
    res.data.forEach((archive) {
      archiveList.add(ArchiveListItemModel.fromJson(archive));
    });
    return archiveList;
  }

  static Future<ArchiveDetailItemModel> getArchiveItem(int archiveId) async {
    Response res = await ArchiveApi.getArchiveItem(userId!, archiveId);
    return ArchiveDetailItemModel.fromJson(res.data);
    ;
  }
}
