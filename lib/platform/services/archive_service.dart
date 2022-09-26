import 'package:dio/dio.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/platform/apis/archive.dart';
import 'package:gaza_go/platform/models/archive_item_model.dart';
import 'package:gaza_go/platform/stores/hive_store.dart';

class ArchiveService {
  static final String? userId = HiveStore.loadString(key: HiveKey.userId.name);

  static Future<List<ArchiveItemModel>> getArchiveList() async {
    Response res = await ArchiveApi.getArchiveList(userId!);
    List<ArchiveItemModel> archiveList = List.empty(growable: true);
    res.data.forEach((archive) {
      archiveList.add(ArchiveItemModel.fromJson(archive));
    });
    return archiveList;
  }
}
