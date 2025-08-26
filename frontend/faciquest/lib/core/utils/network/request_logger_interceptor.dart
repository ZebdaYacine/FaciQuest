import 'package:dio/dio.dart';
import 'package:faciquest/core/core.dart';

class RequestLoggerInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    logInfo('REQUEST[${options.method}] => PATH: ${options.path}');
    super.onRequest(options, handler);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    logSuccess(
      '''RESPONSE[${response.statusCode}] 🟢 => PATH: ${response.requestOptions.path}''',
    );
    super.onResponse(response, handler);
  }

  @override
  Future<dynamic> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    logError(
      '''ERROR[${err.response?.statusCode}] 🔴 => PATH: ${err.requestOptions.path}''',
    );
    logError(
      '''${err.response?.data}''',
    );
    super.onError(err, handler);
  }
}
