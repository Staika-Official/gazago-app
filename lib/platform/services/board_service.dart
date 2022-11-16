import 'package:dio/dio.dart';
import 'package:gaza_go/platform/apis/board.dart';
import 'package:gaza_go/platform/models/term_item_model.dart';

class BoardService {
  static Future<void> getPostListByType(String boardTypes, {required Function successCallback, Function? errorCallback}) async {
    Response res = await BoardApi.getPostListByType(boardTypes);
    if (res.statusCode == 200) {
      List<TermItemModel> termsList = List.empty(growable: true);
      res.data.forEach((term) {
        TermItemModel termItem = TermItemModel.fromJson(term);
        termItem.isRequired = termItem.meta != 'selection';
        termsList.add(termItem);
      });
      successCallback(termsList);
    } else {
      if (errorCallback != null) errorCallback();
    }
  }

  static Future<void> getFirstPostByType(String boardTypes, {required Function successCallback, Function? errorCallback}) async {
    Response res = await BoardApi.getFirstPostByType(boardTypes);
    if (res.statusCode == 200) {
      List<TermItemModel> termsList = List.empty(growable: true);
      if (res.data.length > 0) {
        res.data.forEach((term) {
          TermItemModel termItem = TermItemModel.fromJson(term);
          termItem.isRequired = termItem.meta != 'selection';
          termsList.add(termItem);
        });
      }
      successCallback(termsList);
    } else {
      if (errorCallback != null) errorCallback();
    }
  }

  static Future<void> getPostById(int id, {required Function successCallback, Function? errorCallback}) async {
    Response res = await BoardApi.getPostById(id);
    if (res.statusCode == 200) {
      successCallback(TermItemModel.fromJson(res.data));
    } else {
      if (errorCallback != null) errorCallback();
    }
  }
}
