import 'package:dio/dio.dart';
import 'package:gaza_go/constants/base_urls.dart';
import 'package:gaza_go/platform/middleware/dio_middleware.dart';

class IapApi {
  static Future<Response> validateReceipt(data) async {
    return await Api.client(serviceUrl: ServiceUrl.goWalletService).post(
      '/iap/validate',
      data: data,
      queryParameters: {
        'clientId': 'GAZAGO',
      },
    );
  }

  static Future<Response> pay(data) async {
    return await Api.client(serviceUrl: ServiceUrl.goWalletService).post(
      '/iap/pay',
      data: data,
      queryParameters: {
        'clientId': 'GAZAGO',
      },
    );
  }
}
