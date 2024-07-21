import 'dart:async';

import 'package:faciquest/core/core.dart';
import 'package:faciquest/features/features.dart';

class AuthDataSourceImpl implements AuthDataSource {
  final DioService dioService;
  late final dioClient = dioService.dioClient;
  final StreamController<UserEntity?> _controller;

  AuthDataSourceImpl({required this.dioService})
      : _controller = StreamController<UserEntity?>.broadcast() {
    final user = getUserFromLocal();
    _controller.sink.add(user);
  }
  @override
  Future<void> forgotPassword(String email) {
    return dioService.handleRequest(
      () async {
        final response = await dioClient.post(
          AppUrls.authForgotPasswordUrl,
          data: {'email': email},
        );
        if (response.statusCode == 200) {
          logSuccess('Forgot Password Successful');
        }
      },
    );
  }

  @override
  Future<UserEntity> signIn(String email, String password) {
    return dioService.handleRequest(
      () async {
        final response = await dioClient.post(
          AppUrls.authLoginUrl,
          data: {'email': email},
        );
        if (response.statusCode == 200) {
          logSuccess('Sign In Successful');
          final user=  UserEntity.fromJson(response.data);
          _controller.sink.add(user);
          return user;
        } else {
          throw Exception('Failed to login');
        }
      },
    );
  }

  @override
  Future<void> signOut() {
    return dioService.handleRequest(
      () async {
        final response = await dioClient.post(
          AppUrls.authLogoutUrl,
        );
        if (response.statusCode == 200) {
          logSuccess('Sign Out Successful');
          _controller.sink.add(null);
          return;
        } else {
          throw Exception('Failed to signOut');
        }
      },
    );
  }

  @override
  Future<void> signUp(String email, String password) {
    return dioService.handleRequest(
      () async {
        final response = await dioClient.post(
          AppUrls.authSignUpUrl,
          data: {
            'email': email,
            'password': password,
          },
        );
        if (response.statusCode == 200) {
          logSuccess('Sign Up Successful');
          return;
        } else {
          throw Exception('Failed to SignUp');
        }
      },
    );
  }

  @override
  Stream<UserEntity?> get user => _controller.stream;

  UserEntity? getUserFromLocal() {
    return null;
  }
}
