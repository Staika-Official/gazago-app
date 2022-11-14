import 'package:dio/dio.dart';
import 'package:gaza_go/constants/base_urls.dart';
import 'package:gaza_go/platform/middleware/dio_middleware.dart';

class ArchiveApi {
  static Future<Response> getArchiveList(String userId, int page) async {
    return await Api.client(serviceUrl: ServiceUrl.exerciseService).get('/users/$userId/records', queryParameters: {'size': 20, 'page': page});
  }

  static Future<Response> getArchiveItem(String userId, int archiveId, String platform) async {
    return await Api.client(serviceUrl: ServiceUrl.exerciseService).get('/users/$userId/records/$archiveId', queryParameters: {'platform': platform});
  }

  static Future<Response> deleteArchiveItem(String userId, int archiveId) async {
    return await Api.client(serviceUrl: ServiceUrl.exerciseService).delete('/users/$userId/$archiveId');
  }
}
