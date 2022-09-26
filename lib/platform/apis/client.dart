import 'package:dio/dio.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/constants/routes.dart';
import 'package:gaza_go/flavors.dart';
import 'package:gaza_go/platform/models/token_model.dart';
import 'package:gaza_go/platform/stores/hive_store.dart';
import 'package:get/get.dart' as getx;
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

  static Dio client({required String serviceUrl, bool needsToken = true, Map<String, dynamic>? queryParams}) {
    _dio.options.baseUrl = '${F.baseUrl}$serviceUrl';

    if (needsToken) {
      String? accessToken = HiveStore.loadString(key: 'accessToken');

      _dio.options.headers = {'Authorization': 'Bearer ${accessToken!}'};
    } else {
      _dio.options.headers = {'Authorization': ''};
    }
    if (queryParams != null) {
      _dio.options.queryParameters = queryParams;
    }
    return _dio;
  }

  static _requestInterceptor(RequestOptions options, RequestInterceptorHandler handler) {
    _logger.i(
      '------------->'
      '\nREQUEST'
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
      '\nRESPONSE'
      '\nResponse: ${response.data}',
    );
    return handler.next(response);
  }

  static _onErrorInterceptor(DioError e, ErrorInterceptorHandler handler) {
    // TODO. 액세스토큰 만료시 리프레시 토큰으로 재요청하는 로직 필요. 만약 다른 디바이스에서 로그인 했다면 로그인 페이지로 이동.
    _logger.e(
      '------------->'
      '\nERROR'
      '\nError Response: ${e.response}',
    );

    if (e.response!.statusCode == ResponseStatus.unauthorized.code) {
      final String? refreshToken = HiveStore.loadString(key: HiveKey.refreshToken.name);
      Dio refreshDio = Dio();
      refreshDio
        ..options.headers['Authorization'] = 'Bearer $refreshToken'
        ..post('${F.baseUrl}/services/uaa/api/sign-in/token', data: {'clientId': 'GAZAGO'}).then((Response res) {
          TokenModel newToken = TokenModel.fromJson(res.data);
          HiveStore.save(key: HiveKey.accessToken.name, value: newToken.accessToken);
          HiveStore.save(key: HiveKey.refreshToken.name, value: newToken.refreshToken);

          _retryFailedRequest(e, handler, newToken.accessToken);
        }).catchError((e) {
          HiveStore.deleteMultipleKeys(keys: [
            HiveKey.accessToken.name,
            HiveKey.refreshToken.name,
          ]);
          getx.Get.offAllNamed(Routes.login);
        });
    } else {
      return handler.next(e);
    }
  }

  static _retryFailedRequest(DioError e, ErrorInterceptorHandler handler, String newAccessToken) {
    Dio dio = Dio();
    e.requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';
    dio
        .request(
      e.requestOptions.baseUrl + e.requestOptions.path,
      options: Options(
        method: e.requestOptions.method,
        headers: e.requestOptions.headers,
      ),
      data: e.requestOptions.data,
      queryParameters: e.requestOptions.queryParameters,
    )
        .then(
      (response) => handler.resolve(
        response,
      ),
      onError: (e) {
        if (e is DioError) {
          final Response? res = e.response;
          _logger.e(
            '------------->'
            '\nRETRY ERROR'
            '\n${e.response}',
          );
          handler.next(e);
        }
      },
    );
  }
}
