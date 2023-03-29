import 'package:dio/dio.dart';
import 'package:gaza_go/constants/base_urls.dart';
import 'package:gaza_go/platform/middleware/dio_middleware.dart';

class BoardApi {
  // - 스펜딩 월렛 api

  static Future<Response> getPostListByType(String boardTypes, String platform) async {
    return await Api.client(serviceUrl: ServiceUrl.boardService).get('/$platform/posts/list', queryParameters: {'boardTypes': boardTypes, 'lang': 'ko'});
  }

  static Future<Response> getPostById(int id, String platform) async {
    return await Api.client(serviceUrl: ServiceUrl.boardService).get('/$platform/posts/$id');
  }

  static Future<Response> getNoticePopupList() async {
    return await Api.client(serviceUrl: ServiceUrl.boardService).get('/popups/clients/GAZAGO');
  }
}
