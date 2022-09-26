import 'package:dio/dio.dart';
import 'package:gaza_go/constants/base_urls.dart';
import 'package:gaza_go/platform/apis/client.dart';

class ArchiveApi {
  static Future<Response> getArchiveList(String userId) async {
    return await Api.client(serviceUrl: ServiceUrl.exerciseService).get('/users/$userId/records');
  }
}
