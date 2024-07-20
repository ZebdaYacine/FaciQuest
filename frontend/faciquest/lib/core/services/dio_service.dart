import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:faciquest/core/core.dart';

class DioService {
  DioService(this.dioClient) {
    // add the interceptors
    dioClient.interceptors.add(RequestLoggerInterceptor());
    dioClient.interceptors.add(AuthInterceptor());
  }

  final Dio dioClient;

  Future<T> handleRequest<T>(
    Future<T> Function() requestFunction,
  ) async {
    try {
      return await requestFunction();
    } on DioException catch (e) {
      if (e.error is SocketException) {
        throw NoInternetException(message: 'No internet connection');
      } else if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw TimeoutException('Request timeout');
      } else if (e.response?.statusCode == 400) {
        if (e.response != null) {
          final responseData = e.response!.data as Map<String, dynamic>?;
          if (responseData != null && responseData['errorMessageKey'] != null) {
            final errorMessageKey = responseData['errorMessageKey'];
            switch (errorMessageKey) {
              case 'MAX_FAILURE':
              case 'CONSECUTIVE_REQUEST':
                throw ConsecutiveRequestException(
                  message: responseData['errorMessage']?.toString() ??
                      'Consecutive Request Error',
                );
              case 'MAX_FAILURE_CHECK_PIN':
                throw MaxFailureCheckPinException(
                  message: responseData['errorMessage']?.toString() ??
                      'Max Failure Check Pin',
                );
              case 'MAX_NUMBER_FO_FAV_ADR':
                throw MaxFavAddressException(
                  message: responseData['errorMessage']?.toString() ??
                      'Reached maximum number of favorite addresses',
                );
              case 'CODE_PIN_NOT_VALID':
                throw CodePinNotValidException(
                  message: responseData['errorMessage']?.toString() ??
                      'Code Pin Not Valid',
                );

              // Add more cases for other error message keys if needed
              default:
                throw ApiException(message: 'Unhandled server error');
            }
          } else {
            throw BadRequestException(
              message: e.response?.data.toString() ?? 'Bad Request',
            );
          }
        }
        throw BadRequestException(
          message: e.response?.data.toString() ?? 'Bad Request',
        );
      } else if (e.response?.statusCode == 401) {
        throw UnauthorizedException(
          message: e.response?.data.toString() ?? 'Unauthorized',
        );
      } else if (e.response?.statusCode == 403) {
        throw ForbiddenException(
          message: e.response?.data.toString() ?? 'Forbidden',
        );
      } else if (e.response?.statusCode == 404) {
        throw NotFoundException(
          message: e.response?.data.toString() ?? 'Not Found',
        );
      } else if (e.response?.statusCode == 500) {
        throw InternalServerErrorException(
          message: e.response?.data.toString() ?? 'Internal Server Error',
        );
      } else {
        // logError('Dio error occurred: ${e.message}');
        throw ApiException(message: 'Dio error occurred.');
      }
    } catch (e) {
      rethrow;
    }
  }
}
