import 'package:dio/dio.dart';
import 'package:gaza_go/constants/base_urls.dart';
import 'package:logger/logger.dart';

class Api {
  static final Logger _logger = Logger(printer: PrettyPrinter(colors: true, printEmojis: true));
  static final Dio client = Dio(
    BaseOptions(baseUrl: BaseUrl.dev, headers: {
      'Authorization':
          'Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJhZG1pbiIsImF1dGgiOiJST0xFX0FETUlOLFJPTEVfU1VQRVJfQURNSU4sUk9MRV9VU0VSIiwiZXhwIjoxNjYzNjc0ODg2LCJ1c2VySWQiOiIzIn0.kW9259SdrZEcnyr2kVfiucIXse6_4CX5KoD_LgJYyllJM-n5ETDrJQ9kar7zPQ9l9g_arIU-_v4v_O82a9x2nw'
    }),
  )..interceptors.add(InterceptorsWrapper(
      onRequest: (RequestOptions options, RequestInterceptorHandler handler) => _requestInterceptor(options, handler),
      onResponse: (Response response, ResponseInterceptorHandler handler) => _responseInterceptor(response, handler),
      onError: (DioError e, ErrorInterceptorHandler handler) => _onErrorInterceptor(e, handler)));

  static _requestInterceptor(RequestOptions options, RequestInterceptorHandler handler) {
    _logger.d('------------->'
        '\nMethods: ${options.method}'
        '\nPath: ${options.path}'
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
