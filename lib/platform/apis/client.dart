import 'package:dio/dio.dart';
import 'package:gaza_go/flavors.dart';
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
    _logger.d('------------->'
        '\nMethods: ${options.method}'
        '\nPath: ${options.baseUrl + options.path}'
        '\nData: ${options.data}');
    return handler.next(options);
  }

  static _responseInterceptor(Response response, ResponseInterceptorHandler handler) {
    _logger.d('------------->'
        '\nResponse: ${response.data}');
    return handler.next(response);
  }

  static _onErrorInterceptor(DioError e, ErrorInterceptorHandler handler) {
    _logger.e('------------->'
        '\nError: ${e.response}');
    return handler.next(e);
  }

  // Future<List<PostModel>> getPosts(String postTypes) async {
  //   Map<String, dynamic> queryString = {'boardTypes': postTypes};
  //
  //   List<PostModel> postList = [];
  //
  //   Response postListData = await client.get('/services/board/api/posts/list', queryParameters: queryString);
  //
  //   postListData.data.forEach((post) {
  //     postList.add(PostModel.fromJson(post));
  //   });
  //
  //   return postList;
  // }
}
