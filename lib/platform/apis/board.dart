import 'package:dio/dio.dart';
import 'package:gaza_go/constants/base_urls.dart';
import 'package:gaza_go/platform/middleware/dio_middleware.dart';

class BoardApi {
  // - 스펜딩 월렛 api

  static Future<Response> getPostListByType(String boardTypes) async {
    return await Api.client(serviceUrl: ServiceUrl.boardService).get('/gazago/posts/list', queryParameters: {'boardTypes': boardTypes, 'lang': 'ko'});
  }

  static Future<Response> getPostById(int id) async {
    return await Api.client(serviceUrl: ServiceUrl.boardService).get('/gazago/posts/$id');
  }
}
