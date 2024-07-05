import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
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
import 'package:get/get.dart' as getx;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';
import 'package:package_info_plus/package_info_plus.dart';

class Api {
  static final Logger _logger = Logger(printer: PrettyPrinter(colors: true, printEmojis: true));
  static int retryAttempt = 0;
  static bool needToRefreshToken = true;

  static final Dio _dio = Dio()
    ..interceptors.addAll([
      InterceptorsWrapper(
        onRequest: (RequestOptions options, RequestInterceptorHandler handler) => _requestInterceptor(options, handler),
        onResponse: (Response response, ResponseInterceptorHandler handler) => _responseInterceptor(response, handler),
      ),
      QueuedInterceptorsWrapper(
        onError: (DioException e, ErrorInterceptorHandler handler) => _onErrorInterceptor(e, handler),
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
  }) {
    _dio.options.baseUrl = '${F.baseUrl}$serviceUrl';
    // _dio.options.connectTimeout = 2000;
    _dio.options.sendTimeout = const Duration(milliseconds: 10000);
    _dio.options.receiveTimeout = const Duration(milliseconds: 10000);
    _dio.options.extra = {
      'allowCustomErrorHandler': allowCustomErrorHandler,
      'showLoading': showLoading,
    };
    _dio.options.headers['Content-Type'] = 'application/json; charset=utf-8';

    String headerLang = getx.Get.locale?.languageCode == 'ko' ? 'ko-KR' : 'en-US';
    _dio.options.headers['Accept-Language'] = headerLang;

    if (needsToken) {
      String? accessToken = HiveStore.loadString(key: HiveKey.accessToken.name);

      if (isPatch) {
        _dio.options.headers['Content-Type'] = 'application/merge-patch+json';
      }

      if (isFile) {
        _dio.options.headers['Content-Type'] = 'multipart/form-data';
      }

      if (!isPatch && !isFile) {
        _dio.options.headers['Content-Type'] = 'application/json; charset=utf-8';
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

  static _requestInterceptor(RequestOptions options, RequestInterceptorHandler handler) {
    // if (options.extra['showLoading'] && getx.Get.isDialogOpen != true) {
    //   getx.Get.dialog(
    //     Dialog(
    //       shadowColor: Colors.transparent,
    //       backgroundColor: Colors.transparent,
    //       child: Center(
    //         child: SizedBox(
    //           width: 20,
    //           height: 20,
    //           child: CircularProgressIndicator(),
    //         ),
    //       ),
    //     ),
    //   );
    // }

    if (appliedEndpoint != null && appliedEndpoint!['activateStageMode']) {
      if (!options.path.contains('/sign-in/social') && options.baseUrl.contains(BaseUrl.prod)) {
        options.baseUrl = options.baseUrl.replaceAll(BaseUrl.prod, BaseUrl.stage);
      }
    }

    if (HiveStore.load(key: HiveKey.isDebuggingMode.name)) {
      List requestLogs = HiveStore.load(key: HiveKey.requestLogs.name) ?? [];
      dynamic logForm;
      if (options.data != null && options.headers['Content-Type'] != null && options.headers['Content-Type'].contains('multipart')) {
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
      '\nHeader Content-Type: ${options.headers['Content-Type']}'
      '\nHeader Authorization: ${options.headers['Authorization']}'
      '\nPath: ${options.baseUrl + options.path}'
      '\nQueries: ${(options.queryParameters)}'
      '\nData: ${options.headers['Content-Type'] != null && options.headers['Content-Type'].contains('multipart') ? 'multipart data!' : jsonEncode(options.data)}',
    );

    handler.next(options);
  }

  static _responseInterceptor(Response response, ResponseInterceptorHandler handler) async {
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

  static _onErrorInterceptor(DioException e, ErrorInterceptorHandler handler) async {
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
      reason: 'api error : ${e.response?.statusCode}, $errorMessage, ${e.requestOptions.path}, ${getx.Get.currentRoute}',
    );

    if (HiveStore.load(key: HiveKey.isDebuggingMode.name)) {
      List responseErrorLogs = HiveStore.load(key: HiveKey.responseErrorLogs.name) ?? [];
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
      HiveStore.save(key: HiveKey.responseErrorLogs.name, value: responseErrorLogs);
    }

    if (e.response?.statusCode == ResponseStatus.unauthorized.code) {
      final String refreshToken = HiveStore.loadString(key: HiveKey.refreshToken.name) ?? '';

      if (refreshToken == '') {
        showToastPopup('토큰이 만료되었습니다.\n다시 로그인해주세요.');
        resetToLogin(e, handler);
        return;
      }

      await _getNewAccessToken(e, handler);
    } else {
      if (e.response?.data != null && e.response?.data != '') {
        ErrorResponseDataModel errorData = ErrorResponseDataModel.fromJson(e.response?.data);

        if (errorData.errorMessage != null && !e.requestOptions.extra['allowCustomErrorHandler']) {
          showToastPopup(errorData.errorMessage!);
        }
      } else if ([DioExceptionType.connectionTimeout, DioExceptionType.sendTimeout, DioExceptionType.receiveTimeout, DioExceptionType.unknown].any((element) => element == e.type)) {
        e.copyWith(
          response: Response(
            requestOptions: RequestOptions(
              path: e.requestOptions.path,
              data: 'unknown',
            ),
          ),
        );

        showToastPopup('통신이 원활하지 않습니다.\n잠시후 다시 시도해주세요');
      }
    }

    if (!handler.isCompleted) {
      if (e.requestOptions.extra['showLoading'] && getx.Get.isDialogOpen == true) {
        getx.Get.back();
      }
      e.response != null && e.response!.data != 'unknown' ? handler.resolve(e.response!) : handler.next(e);
    }
  }

  static Future<void> _retryFailedRequest(DioException e, ErrorInterceptorHandler handler) async {
    String? accessToken = HiveStore.loadString(key: HiveKey.accessToken.name);
    print('accessTokenaccessToken : $accessToken');
    if (accessToken == null) {
      resetToLogin(e, handler);
      return;
    }

    Dio dio = Dio();
    e.requestOptions.headers['Authorization'] = 'Bearer $accessToken';
    await dio
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

        if (e.requestOptions.extra['showLoading'] && getx.Get.isDialogOpen == true) {
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
        showToastPopup('연결이 불안정합니다. 잠시 후 재시도 해주세요');
        _logger.e(
          '------------->'
          '\nRETRY ERROR'
          '\n${e.requestOptions.baseUrl + e.requestOptions.path}'
          '\n${error.response}',
        );

        if (!handler.isCompleted) {
          if (e.requestOptions.extra['showLoading'] && getx.Get.isDialogOpen == true) {
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

  static Future<void> _getNewAccessToken(DioException e, ErrorInterceptorHandler handler) async {
    final String refreshToken = HiveStore.loadString(key: HiveKey.refreshToken.name) ?? '';
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
      "deviceModel": Platform.isAndroid ? androidDeviceInfo!.model : iosDeviceInfo!.utsname.machine,
      "osVersion": Platform.isAndroid ? androidDeviceInfo!.version.sdkInt.toString() : iosDeviceInfo!.systemVersion,
      "providerEnv": appliedEndpoint != null && appliedEndpoint!['activateStageMode'] ? 'STAGE' : null,
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

      HiveStore.save(key: HiveKey.accessToken.name, value: newToken.accessToken);
      HiveStore.save(key: HiveKey.refreshToken.name, value: newToken.refreshToken);
      needToRefreshToken = false;
      print('_retryFailedRequest');
      print('_retryFailedRequest : res.requestOptions.path ${res.requestOptions.path}');
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
      showToastPopup('토큰이 만료되었습니다.\n다시 로그인해주세요.');
      resetToLogin(e, handler);
    });
  }

  static void resetToLogin(DioException e, ErrorInterceptorHandler handler) async {
    if (e.requestOptions.extra['showLoading'] && getx.Get.isDialogOpen == true) {
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
      ActivityController activityController = getx.Get.find<ActivityController>();
      if (activityController.exerciseTimer != null) {
        activityController.exerciseTimer!.cancel();
        activityController.updateTimer!.cancel();
        activityController.exerciseTimer = null;
        activityController.updateTimer = null;
      }
    }

    if (getx.Get.currentRoute != Routes.login) getx.Get.offAllNamed(Routes.login);
  }
}
