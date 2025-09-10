import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:gaza_go/constants/base_urls.dart';
import 'package:gaza_go/constants/config.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/constants/routes.dart';
import 'package:gaza_go/flavors.dart';
import 'package:gaza_go/platform/controllers/activity_controller.dart';
import 'package:gaza_go/platform/helpers/alert_helper.dart';
import 'package:gaza_go/platform/models/access_token_model.dart';
import 'package:gaza_go/platform/models/error_response_data_model.dart';
import 'package:gaza_go/platform/stores/hive_store.dart';
import 'package:get/get.dart' as getx hide Trans;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:package_info_plus/package_info_plus.dart';

class Api {
  static final Logger _logger =
      Logger(printer: PrettyPrinter(colors: true, printEmojis: true));
  static int retryAttempt = 0;
  static bool needToRefreshToken = true;

  static final Dio _dio = Dio()
    ..interceptors.addAll([
      InterceptorsWrapper(
        onRequest:
            (RequestOptions options, RequestInterceptorHandler handler) =>
                _requestInterceptor(options, handler),
        onResponse: (Response response, ResponseInterceptorHandler handler) =>
            _responseInterceptor(response, handler),
      ),
      QueuedInterceptorsWrapper(
        onError: (DioException e, ErrorInterceptorHandler handler) =>
            _onErrorInterceptor(e, handler),
      ),
      // LogInterceptor(
      //   error: true,
      //   request: true,
      //   requestBody: true,
      //   requestHeader: true,
      //   responseBody: true,
      //   responseHeader: true,
      // )
    ]);

  static Dio client({
    required String serviceUrl,
    bool needsToken = true,
    Map<String, dynamic>? queryParams,
    bool isPatch = false,
    bool isFile = false,
    bool allowCustomErrorHandler = false,
    bool showLoading = true,
    bool showToastOnError = true,
  }) {
    _dio.options.baseUrl = '${F.baseUrl}$serviceUrl';
    // _dio.options.connectTimeout = 2000;
    _dio.options.sendTimeout = const Duration(milliseconds: 10000);
    _dio.options.receiveTimeout = const Duration(milliseconds: 10000);
    _dio.options.extra = {
      'allowCustomErrorHandler': allowCustomErrorHandler,
      'showLoading': showLoading,
      'showToastOnError': showToastOnError,
    };
    _dio.options.headers['Content-Type'] = 'application/json; charset=utf-8';

    _dio.options.headers['Accept-Language'] =
        PlatformDispatcher.instance.locale.languageCode;

    if (needsToken) {
      String? accessToken = HiveStore.loadString(key: HiveKey.accessToken.name);

      if (isPatch) {
        _dio.options.headers['Content-Type'] = 'application/merge-patch+json';
      }

      if (isFile) {
        _dio.options.headers['Content-Type'] = 'multipart/form-data';
      }

      if (!isPatch && !isFile) {
        _dio.options.headers['Content-Type'] =
            'application/json; charset=utf-8';
      }

      if (accessToken != null) {
        _dio.options.headers['Authorization'] = 'Bearer $accessToken';
      } else {
        _dio.options.headers.remove('Authorization');
      }
    } else {
      _dio.options.headers.remove('Authorization');
    }

    if (queryParams != null) {
      _dio.options.queryParameters = queryParams;
    } else {
      _dio.options.queryParameters = {};
    }
    return _dio;
  }

  static _requestInterceptor(
      RequestOptions options, RequestInterceptorHandler handler) {
    // if (options.extra['showLoading'] && getx.Get.isDialogOpen != true) {
    //   getx.Get.dialog(
    //     Dialog(
    //       shadowColor: Colors.transparent,
    //       backgroundColor: Colors.transparent,
    //       child: Center(
    //         child: SizedBox(
    //           width: 20,
    //           height: 20,
    //           child: CircularProgressIndicator(color:skyBlueColor),
    //         ),
    //       ),
    //     ),
    //   );
    // }

    if (appliedEndpoint != null && appliedEndpoint!['activateStageMode']) {
      if (!options.path.contains('/sign-in/social') &&
          options.baseUrl.contains(BaseUrl.prod)) {
        options.baseUrl =
            options.baseUrl.replaceAll(BaseUrl.prod, BaseUrl.stage);
      }
    }

    final curl = _buildCurl(options);

    _logger.i(
      '------------->'
      '\nREQUEST'
      '\nMethods: ${options.method}'
      '\nHeader Content-Type: ${options.headers['Content-Type']}'
      '\nHeader Accept-Language: ${options.headers['Accept-Language']}'
      '\nHeader Authorization: ${options.headers['Authorization']}'
      '\nPath: ${options.uri}'
      '\nQueries: ${options.queryParameters}'
      '\nData: ${options.headers['Content-Type'] != null && options.headers['Content-Type'].contains('multipart') ? 'multipart data!' : jsonEncode(options.data)}'
      '\nCURL: $curl',
    );

    handler.next(options);
  }

  static _responseInterceptor(
      Response response, ResponseInterceptorHandler handler) async {
    _logger.d(
      '------------->'
      '\nRESPONSE'
      '\nPath: ${response.requestOptions.baseUrl + response.requestOptions.path}'
      '\nQueries: ${response.requestOptions.queryParameters}'
      '\nResponseCode: ${response.statusCode}'
      '\nResponse: ${response.data}',
    );

    // if (response.requestOptions.extra['showLoading'] && getx.Get.isDialogOpen == true) {
    //   getx.Get.back();
    // }

    Timer(Duration.zero, () {
      if (!needToRefreshToken) {
        needToRefreshToken = true;
      }
      handler.next(response);
    });
  }

  static _onErrorInterceptor(
      DioException e, ErrorInterceptorHandler handler) async {
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

    String errorMessage = e.response?.statusMessage ?? 'error';

    FirebaseCrashlytics.instance.recordError(
      e,
      e.stackTrace,
      reason:
          'api error : ${e.response?.statusCode}, $errorMessage, ${e.requestOptions.path}, ${getx.Get.currentRoute}',
    );

    if (HiveStore.load(key: HiveKey.isDebuggingMode.name)) {
      List responseErrorLogs =
          HiveStore.load(key: HiveKey.responseErrorLogs.name) ?? [];
      dynamic errorLogForm;
      errorLogForm = {
        'logInfo': '==================================================='
            '\nERROR'
            '\nErrorPath: ${e.response?.requestOptions.baseUrl}${e.response?.requestOptions.path}'
            '\nErrorQuery: ${e.response?.requestOptions.queryParameters}'
            '\nError ResponseCode: ${e.response?.statusCode}'
            '\nError ResponseMessage: ${e.response?.statusMessage}'
            '\nError ResponseData: ${e.response?.data}',
      };

      responseErrorLogs.add(errorLogForm);
      HiveStore.save(
          key: HiveKey.responseErrorLogs.name, value: responseErrorLogs);
    }

    if (e.response?.statusCode == ResponseStatus.unauthorized.code) {
      final String refreshToken =
          HiveStore.loadString(key: HiveKey.refreshToken.name) ?? '';

      if (refreshToken == '') {
        showToastPopup('token_expired'.tr());
        resetToLogin(e, handler);
        return;
      }

      await _getNewAccessToken(e, handler);
    } else {
      if (e.response?.data != null && e.response?.data != '') {
        ErrorResponseDataModel errorData =
            ErrorResponseDataModel.fromJson(e.response?.data);

        if (errorData.errorMessage != null &&
            !e.requestOptions.extra['allowCustomErrorHandler']) {
          if (e.requestOptions.extra['showToastOnError'] == true) {
            showToastPopup(errorData.errorMessage!);
          }
        }
      } else if ([
        DioExceptionType.connectionTimeout,
        DioExceptionType.sendTimeout,
        DioExceptionType.receiveTimeout,
        DioExceptionType.unknown
      ].any((element) => element == e.type)) {
        e.copyWith(
          response: Response(
            requestOptions: RequestOptions(
              path: e.requestOptions.path,
              data: 'unknown',
            ),
          ),
        );

        showToastPopup('poor_connection'.tr());
      }
    }

    if (!handler.isCompleted) {
      if (e.requestOptions.extra['showLoading'] &&
          getx.Get.isDialogOpen == true) {
        getx.Get.back();
      }
      e.response != null && e.response!.data != 'unknown'
          ? handler.resolve(e.response!)
          : handler.next(e);
    }
  }

  static Future<void> _retryFailedRequest(
      DioException e, ErrorInterceptorHandler handler) async {
    String? accessToken = HiveStore.loadString(key: HiveKey.accessToken.name);

    if (accessToken == null) {
      resetToLogin(e, handler);
      return;
    }

    // Dio dio = Dio();
    e.requestOptions.headers['Authorization'] = 'Bearer $accessToken';
    await _dio
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
        _logger.d(
          '------------->'
          '\nRESPONSE'
          '\nPath: ${response.requestOptions.baseUrl + response.requestOptions.path}'
          '\nQueries: ${response.requestOptions.queryParameters}'
          '\nResponseCode: ${response.statusCode}'
          '\nResponse: ${response.data}',
        );

        if (e.requestOptions.extra['showLoading'] &&
            getx.Get.isDialogOpen == true) {
          getx.Get.back();
        }
        retryAttempt = 0;
        handler.resolve(
          response,
        );
      },
    ).onError((DioException error, stackTrace) async {
      _logger.e(
        '------------->'
        '\nRETRY FAILED REQUEST ERROR'
        '\nError: ${error.error}'
        '\nErrorPath: ${error.response?.requestOptions.baseUrl}${error.response?.requestOptions.path}'
        '\nErrorQuery: ${error.response?.requestOptions.queryParameters}'
        '\nError ResponseCode: ${error.response?.statusCode}'
        '\nError ResponseMessage: ${error.response?.statusMessage}'
        '\nError ResponseData: ${error.response?.data}',
      );

      retryAttempt++;
      if (retryAttempt > 5) {
        showToastPopup('unstable_connection'.tr());
        _logger.e(
          '------------->'
          '\nRETRY ERROR'
          '\n${e.requestOptions.baseUrl + e.requestOptions.path}'
          '\n${error.response}',
        );

        if (!handler.isCompleted) {
          if (e.requestOptions.extra['showLoading'] &&
              getx.Get.isDialogOpen == true) {
            getx.Get.back();
          }
          if (e.response != null) {
            handler.resolve(e.response!);
          } else {
            handler.next(e);
          }
        }
        return;
      }

      await _retryFailedRequest(e, handler);
    });
  }

  static Future<void> _getNewAccessToken(
      DioException e, ErrorInterceptorHandler handler) async {
    final String refreshToken =
        HiveStore.loadString(key: HiveKey.refreshToken.name) ?? '';
    String fcmToken = HiveStore.loadString(key: HiveKey.fcmToken.name)!;
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String deviceId = HiveStore.loadString(key: HiveKey.uuid.name)!;
    AndroidDeviceInfo? androidDeviceInfo;
    IosDeviceInfo? iosDeviceInfo;

    Future<void> getDeviceInfo() async {
      final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

      if (Platform.isAndroid) {
        androidDeviceInfo = await deviceInfo.androidInfo;
      } else {
        iosDeviceInfo = await deviceInfo.iosInfo;
      }
    }

    await getDeviceInfo();

    Dio refreshDio = Dio();
    refreshDio.options.headers['Authorization'] = 'Bearer $refreshToken';
    await refreshDio.post('${F.baseUrl}/services/uaa/api/sign-in/token', data: {
      'clientId': 'GAZAGO',
      'appVersion': packageInfo.version,
      'deviceId': deviceId,
      'fcmToken': fcmToken,
      'platform': Platform.isAndroid ? 'Android' : 'iOS',
      "deviceModel": Platform.isAndroid
          ? androidDeviceInfo!.model
          : iosDeviceInfo!.utsname.machine,
      "osVersion": Platform.isAndroid
          ? androidDeviceInfo!.version.sdkInt.toString()
          : iosDeviceInfo!.systemVersion,
      "providerEnv":
          appliedEndpoint != null && appliedEndpoint!['activateStageMode']
              ? 'STAGE'
              : null,
    }).then((Response res) async {
      _logger.d(
        '------------->'
        '\nRESPONSE'
        '\nPath: ${res.requestOptions.baseUrl + res.requestOptions.path}'
        '\nQueries: ${res.requestOptions.queryParameters}'
        '\nResponseCode: ${res.statusCode}'
        '\nResponse: ${res.data}',
      );

      AccessTokenModel newToken = AccessTokenModel.fromJson(res.data);

      HiveStore.save(
          key: HiveKey.accessToken.name, value: newToken.accessToken);
      HiveStore.save(
          key: HiveKey.refreshToken.name, value: newToken.refreshToken);
      _dio.options.headers['Authorization'] = 'Bearer ${newToken.accessToken}';
      // e.requestOptions.headers['Authorization'] = 'Bearer ${newToken.accessToken}';
      needToRefreshToken = false;
      print('_retryFailedRequest');
      print(
          '_retryFailedRequest : res.requestOptions.path ${res.requestOptions.path}');
      await _retryFailedRequest(e, handler);
    }).onError((DioException error, stacktrace) {
      _logger.e(
        '------------->'
        '\nERROR'
        '\nError: ${error.error}'
        '\nErrorPath: ${error.response?.requestOptions.baseUrl}${error.response?.requestOptions.path}'
        '\nErrorQuery: ${error.response?.requestOptions.queryParameters}'
        '\nError ResponseCode: ${error.response?.statusCode}'
        '\nError ResponseMessage: ${error.response?.statusMessage}'
        '\nError ResponseData: ${error.response?.data}',
      );
      showToastPopup('token_expired'.tr());
      resetToLogin(e, handler);
    });
  }

  static void resetToLogin(
      DioException e, ErrorInterceptorHandler handler) async {
    if (e.requestOptions.extra['showLoading'] &&
        getx.Get.isDialogOpen == true) {
      getx.Get.back();
    }

    if (!handler.isCompleted) {
      e.response != null ? handler.resolve(e.response!) : handler.next(e);
    }

    retryAttempt = 0;

    HiveStore.deleteMultipleKeys(keys: [
      HiveKey.accessToken.name,
      HiveKey.refreshToken.name,
    ]);

    if (await GoogleSignIn().isSignedIn()) {
      GoogleSignIn().signOut();
    }

    if (getx.Get.isRegistered<ActivityController>()) {
      ActivityController activityController =
          getx.Get.find<ActivityController>();
      if (activityController.exerciseTimer != null) {
        activityController.exerciseTimer!.cancel();
        activityController.updateTimer!.cancel();
        activityController.exerciseTimer = null;
        activityController.updateTimer = null;
      }
      activityController.locationSubscription?.cancel();
      activityController.locationSubscription = null;
    }

    if (getx.Get.currentRoute != Routes.login)
      getx.Get.offAllNamed(Routes.login);
  }

  static String _buildCurl(RequestOptions options) {
    final method = options.method;
    final url = options.uri.toString();

    // Headers
    final headers = options.headers.entries
        .map((e) => "-H '${e.key}: ${e.value}'")
        .join(' ');

    // Data
    String data = '';
    if (options.data != null) {
      if (options.data is Map || options.data is List) {
        data = "-d '${jsonEncode(options.data)}'";
      } else {
        data = "-d '${options.data.toString()}'";
      }
    }

    return "curl -X $method $headers $data '$url'";
  }
}
