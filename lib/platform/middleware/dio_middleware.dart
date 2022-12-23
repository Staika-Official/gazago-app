import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/constants/routes.dart';
import 'package:gaza_go/flavors.dart';
import 'package:gaza_go/platform/helpers/alert_helper.dart';
import 'package:gaza_go/platform/models/access_token_model.dart';
import 'package:gaza_go/platform/models/error_response_data_model.dart';
import 'package:gaza_go/platform/stores/hive_store.dart';
import 'package:get/get.dart' as getx;
import 'package:logger/logger.dart';

class Api {
  static final Logger _logger = Logger(printer: PrettyPrinter(colors: true, printEmojis: true));

  static final Dio _dio = Dio()
    ..interceptors.addAll([
      InterceptorsWrapper(
        onRequest: (RequestOptions options, RequestInterceptorHandler handler) => _requestInterceptor(options, handler),
        onResponse: (Response response, ResponseInterceptorHandler handler) => _responseInterceptor(response, handler),
      ),
      QueuedInterceptorsWrapper(
        onError: (DioError e, ErrorInterceptorHandler handler) => _onErrorInterceptor(e, handler),
      )
    ]);

  static Dio client({required String serviceUrl, bool needsToken = true, Map<String, dynamic>? queryParams, bool? isPatch = false, bool? isFile = false}) {
    _dio.options.baseUrl = '${F.baseUrl}$serviceUrl';
    _dio.options.connectTimeout = 10000;
    _dio.options.receiveTimeout = 10000;
    _dio.options.sendTimeout = 10000;

    if (needsToken) {
      String? accessToken = HiveStore.loadString(key: HiveKey.accessToken.name);

      if (accessToken != null) {
        _dio.options.headers = {'Authorization': 'Bearer $accessToken'};
      }
      if (isPatch!) {
        _dio.options.headers = {'Authorization': 'Bearer ${accessToken!}', 'Content-type': 'application/merge-patch+json'};
      }
      if (isFile!) {
        _dio.options.headers = {'Authorization': 'Bearer ${accessToken!}'};
      }
    } else {
      _dio.options.headers = {'Authorization': ''};
    }

    if (queryParams != null) {
      _dio.options.queryParameters = queryParams;
    } else {
      _dio.options.queryParameters = {};
    }
    return _dio;
  }

  static _requestInterceptor(RequestOptions options, RequestInterceptorHandler handler) {
    if (HiveStore.load(key: HiveKey.isDebuggingMode.name)) {
      List requestLogs = HiveStore.load(key: HiveKey.requestLogs.name) ?? [];
      dynamic logForm;
      if (options.data != null) {
        final Map optData = json.decode(json.encode(options.data));
        if (optData["locations"] != null) {
          optData["locations"] = null;
        }
        logForm = {
          'logInfo': '==================================================='
              '\nREQUEST'
              '\nTime: ${DateTime.now()}'
              '\nMethods: ${options.method}'
              '\nPath: ${options.baseUrl + options.path}'
              '\nQueries: ${(options.queryParameters)}'
              '\nData: ${jsonEncode(optData)}',
          'path': options.baseUrl + options.path,
        };
      } else {
        logForm = {
          'logInfo': '==================================================='
              '\nREQUEST'
              '\nTime: ${DateTime.now()}'
              '\nMethods: ${options.method}'
              '\nPath: ${options.baseUrl + options.path}'
              '\nQueries: ${(options.queryParameters)}',
          'path': options.baseUrl + options.path,
        };
      }

      requestLogs.add(logForm);
      HiveStore.save(key: HiveKey.requestLogs.name, value: requestLogs);
    }

    _logger.i(
      '------------->'
      '\nREQUEST'
      '\nMethods: ${options.method}'
      '\nHeader Authorization: ${options.headers['Authorization']}'
      '\nPath: ${options.baseUrl + options.path}'
      '\nQueries: ${(options.queryParameters)}'
      '\nData: ${jsonEncode(options.data)}',
    );
    return handler.next(options);
  }

  static _responseInterceptor(Response response, ResponseInterceptorHandler handler) {
    _logger.d(
      '------------->'
      '\nRESPONSE'
      '\nPath: ${response.requestOptions.baseUrl + response.requestOptions.path}'
      '\nQueries: ${response.requestOptions.queryParameters}'
      '\nResponseCode: ${response.statusCode}'
      '\nResponse: ${response.data}',
    );
    return handler.next(response);
  }

  static _onErrorInterceptor(DioError e, ErrorInterceptorHandler handler) async {
    _logger.e(
      '------------->'
      '\nERROR'
      '\nError: ${e.error}'
      '\nErrorPath: ${e.response?.requestOptions.baseUrl}${e.response?.requestOptions.path}'
      '\nErrorQuery: ${e.response?.requestOptions.queryParameters}'
      '\nError ResponseCode: ${e.response?.statusCode}'
      '\nError ResponseMessage: ${e.response?.statusMessage}'
      '\nError ResponseData: ${e.response?.data}',
    );

    if (e.response?.statusCode == ResponseStatus.unauthorized.code) {
      final String refreshToken = HiveStore.loadString(key: HiveKey.refreshToken.name) ?? '';

      if (refreshToken == '') {
        if (getx.Get.currentRoute != Routes.login) getx.Get.offAllNamed(Routes.login);
        handler.reject(e);
      }

      await _retryFailedRequest(e, handler);
    } else {
      if (e.response?.data != null && e.response?.data != '') {
        ErrorResponseDataModel errorData = ErrorResponseDataModel.fromJson(e.response?.data);
        if (e.response!.requestOptions.path.contains('user-identities')) {
          handler.resolve(e.response!);
        } else {
          if (errorData.errorMessage != null) {
            showToastPopup(errorData.errorMessage!);
          }
        }
      }

      if ([DioErrorType.connectTimeout, DioErrorType.sendTimeout, DioErrorType.receiveTimeout, DioErrorType.other].any((element) => element == e.type)) {
        handler.resolve(
          Response(
            requestOptions: RequestOptions(
              path: e.requestOptions.path,
              data: 'unknown',
            ),
          ),
        );
        showToastPopup('통신이 원활하지 않습니다. 잠시후 다시 시도해주세요');
      } else {
        handler.resolve(e.response!);
      }
    }
  }

  static Future<void> _retryFailedRequest(DioError e, ErrorInterceptorHandler handler) async {
    print(e.requestOptions.baseUrl + e.requestOptions.path);
    String accessToken = HiveStore.loadString(key: HiveKey.accessToken.name)!;
    Dio dio = Dio();
    e.requestOptions.headers['Authorization'] = 'Bearer $accessToken';
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
      (response) {
        handler.resolve(
          response,
        );
      },
    ).onError((error, stackTrace) async {
      if (error is DioError) {
        _logger.e(
          '------------->'
          '\nRETRY ERROR'
          '\n${error.response}',
        );
        await _getNewAccessToken(e, handler);
      }
    });
  }

  static Future<void> _getNewAccessToken(DioError e, ErrorInterceptorHandler handler) async {
    final String refreshToken = HiveStore.loadString(key: HiveKey.refreshToken.name) ?? '';

    print('refreshToken $refreshToken');

    Dio refreshDio = Dio();
    refreshDio
      ..options.headers['Authorization'] = 'Bearer $refreshToken'
      ..post('${F.baseUrl}/services/uaa/api/sign-in/token', data: {'clientId': 'GAZAGO'}).then((Response res) async {
        AccessTokenModel newToken = AccessTokenModel.fromJson(res.data);

        HiveStore.save(key: HiveKey.accessToken.name, value: newToken.accessToken);
        HiveStore.save(key: HiveKey.refreshToken.name, value: newToken.refreshToken);

        print('new refreshToken ${newToken.refreshToken}');

        await _retryFailedRequest(e, handler);
      }).onError((error, stacktrace) {
        HiveStore.deleteMultipleKeys(keys: [
          HiveKey.accessToken.name,
          HiveKey.refreshToken.name,
        ]);
        if (getx.Get.currentRoute != Routes.login) getx.Get.offAllNamed(Routes.login);
      });
  }
}
