import 'package:dio/dio.dart';
import 'package:gaza_go/constants/base_urls.dart';
import 'package:gaza_go/platform/middleware/dio_middleware.dart';

class NftApi {
  // - 스펜딩 월렛 api
  static Future<Response> transferNftToStaika({required String userId, required int nftId, required int userItemId, bool showLoading = false}) async {
    return await Api.client(serviceUrl: ServiceUrl.nftService, showLoading: showLoading, allowCustomErrorHandler: true).post('/users/$userId/$nftId/user-items/$userItemId/export', queryParameters: {
      'clientId': 'GAZAGO',
    });
  }
}
