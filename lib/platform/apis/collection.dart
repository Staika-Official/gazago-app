import 'package:dio/dio.dart';
import 'package:gaza_go/platform/middleware/dio_middleware.dart';

class CollectionApi {
  static Future<Response> getCollectionsList(String userId) async {
    return await Api.client(
      serviceUrl: '/services/gazago/api',
      showLoading: false,
    ).get('/gatherings/users/$userId');
  }


}
