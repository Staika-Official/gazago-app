import 'package:dio/dio.dart';
import 'package:gaza_go/platform/apis/board.dart';
import 'package:gaza_go/platform/models/challenge_notification_group_model.dart';
import 'package:gaza_go/platform/models/notice_popup_model.dart';
import 'package:gaza_go/platform/models/term_item_model.dart';

class BoardService {
  static Future<void> getPostListByType(String boardTypes, {String platform = 'gazago', required Function successCallback, Function? errorCallback}) async {
    Response res = await BoardApi.getPostListByType(boardTypes, platform);
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

  static Future<void> getPostById(int id, {String platform = 'gazago', required Function successCallback, Function? errorCallback}) async {
    Response res = await BoardApi.getPostById(id, platform);
    if (res.statusCode == 200) {
      successCallback(TermItemModel.fromJson(res.data));
    } else {
      if (errorCallback != null) errorCallback();
    }
  }

  static Future<void> getMainNoticePopupList({required Function successCallback, Function? errorCallback}) async {
    Response res = await BoardApi.getMainNoticePopupList();
    if (res.statusCode == 200) {
      List<NoticePopupModel> noticePopupList = List.empty(growable: true);
      res.data.forEach((term) {
        NoticePopupModel noticePopupItem = NoticePopupModel.fromJson(term);
        noticePopupList.add(noticePopupItem);
      });
      successCallback(noticePopupList);
    } else {
      if (errorCallback != null) errorCallback();
    }
  }

  static Future<void> getNoticePopupList({required Function successCallback, Function? errorCallback}) async {
    Response res = await BoardApi.getNoticePopupList();
    if (res.statusCode == 200) {
      List<NoticePopupModel> noticePopupList = List.empty(growable: true);
      res.data.forEach((term) {
        NoticePopupModel noticePopupItem = NoticePopupModel.fromJson(term);
        noticePopupList.add(noticePopupItem);
      });
      successCallback(noticePopupList);
    } else {
      if (errorCallback != null) errorCallback();
    }
  }

  static Future<void> getChallengeNotifications(int challengeId, {required Function successCallback, Function? errorCallback}) async {
    Response res = await BoardApi.getChallengeNotifications(challengeId);
    if (res.statusCode == 200) {
      ChallengeNotificationGroupModel? challengeNotificationGroupModel = res.data != null ? ChallengeNotificationGroupModel.fromJson(res.data) : null;

      challengeNotificationGroupModel?.challengeNotifications.sort((a, b) => a.listOrder.compareTo(b.listOrder));
      successCallback(challengeNotificationGroupModel);
    } else {
      if (errorCallback != null) errorCallback();
    }
  }
}
