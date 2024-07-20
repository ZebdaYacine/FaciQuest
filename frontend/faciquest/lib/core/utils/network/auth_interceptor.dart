import 'package:dio/dio.dart';
import 'package:faciquest/core/core.dart';
import 'package:faciquest/features/features.dart';


class AuthInterceptor extends Interceptor {
  AuthInterceptor();

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await SecuredStorageKeys.token.getStoredValue() as String?;
    options.headers.addAll({
      'Authorization': 'Bearer $token',
    });
    return handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    super.onError(err, handler);

    final token = await SecuredStorageKeys.token.getStoredValue() as String?;
    if (err.response?.statusCode == 401 && token != null) {
      // perform Sign-out
      getIt<AuthBloc>().add(SignOutRequested());
    }
  }
}
