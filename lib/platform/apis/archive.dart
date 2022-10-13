import 'package:dio/dio.dart';
import 'package:gaza_go/constants/base_urls.dart';
import 'package:gaza_go/platform/middleware/dio_middleware.dart';

class ArchiveApi {
  static Future<Response> getArchiveList(String userId) async {
    return await Api.client(serviceUrl: ServiceUrl.exerciseService).get('/users/$userId/records');
  }

  static Future<Response> getArchiveItem(String userId, int archiveId) async {
    return await Api.client(serviceUrl: ServiceUrl.exerciseService).get('/users/$userId/records/$archiveId');
  }

  static Future<Response> deleteArchiveItem(String userId, int archiveId) async {
    return await Api.client(serviceUrl: ServiceUrl.exerciseService).delete('/users/$userId/$archiveId');
  }
}
