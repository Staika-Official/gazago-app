import 'package:dio/dio.dart';
import 'package:gaza_go/constants/base_urls.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/flavors.dart';
import 'package:gaza_go/platform/models/token_model.dart';
import 'package:gaza_go/platform/stores/hive_store.dart';
import 'package:logger/logger.dart';

class Api {
  static final Logger _logger = Logger(printer: PrettyPrinter(colors: true, printEmojis: true));
  static final Dio _dio = Dio()
    ..interceptors.add(
      InterceptorsWrapper(
        onRequest: (RequestOptions options, RequestInterceptorHandler handler) => _requestInterceptor(options, handler),
        onResponse: (Response response, ResponseInterceptorHandler handler) => _responseInterceptor(response, handler),
        onError: (DioError e, ErrorInterceptorHandler handler) => _onErrorInterceptor(e, handler),
      ),
    );

  static Dio client({required String serviceUrl, bool needsToken = true}) {
    _dio.options.baseUrl = '${F.baseUrl}$serviceUrl';

    if (needsToken) {
      String? accessToken = HiveStore.loadString(key: 'accessToken');

      _dio.options.headers = {'Authorization': 'Bearer ${accessToken!}'};
    }
    return _dio;
  }

  static _requestInterceptor(RequestOptions options, RequestInterceptorHandler handler) {
    _logger.d(
      '------------->'
      '\nMethods: ${options.method}'
      '\nHeader Authorization: ${options.headers['Authorization']}'
      '\nPath: ${options.baseUrl + options.path}'
      '\nData: ${options.data}',
    );
    return handler.next(options);
  }

  static _responseInterceptor(Response response, ResponseInterceptorHandler handler) {
    _logger.d(
      '------------->'
      '\nResponse: ${response.data}',
    );
    return handler.next(response);
  }

  static _onErrorInterceptor(DioError e, ErrorInterceptorHandler handler) {
    // TODO. 액세스토큰 만료시 리프레시 토큰으로 재요청하는 로직 필요. 만약 다른 디바이스에서 로그인 했다면 로그인 페이지로 이동.
    _logger.e(
      '------------->'
      '\nError Response: ${e.response}',
    );

    if (e.response!.statusCode == ResponseStatus.unauthorized.code) {
      final String? refreshToken = HiveStore.loadString(key: HiveKey.refreshToken.name);
      Api.client(serviceUrl: ServiceUrl.uaaService, needsToken: false)
        ..options.headers['Authorization'] = 'Bearer $refreshToken'
        ..post('/sign-in/token', data: {'clientId': 'GAZAGO'}).then((Response res) {
          TokenModel newToken = TokenModel.fromJson(res.data);
          HiveStore.save(key: HiveKey.accessToken.name, value: newToken.accessToken);
          HiveStore.save(key: HiveKey.refreshToken.name, value: newToken.refreshToken);
        });
    }
    return handler.next(e);
  }
}
