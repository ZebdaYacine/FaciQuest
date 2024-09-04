import 'dart:async';

import 'package:dio/dio.dart';
import 'package:faciquest/core/core.dart';
import 'package:faciquest/features/features.dart';

class AuthDataSourceImpl implements AuthDataSource {
  final DioService dioService;
  late final dioClient = dioService.dioClient;
  final StreamController<UserEntity?> _controller;

  AuthDataSourceImpl({required this.dioService})
      : _controller = StreamController<UserEntity?>.broadcast() {
    logInfo('AuthDataSourceImpl:init');
    getUserFromLocal().then(
      (value) {
        _controller.sink.add(value);
      },
    );
  }
  @override
  Future<void> forgotPassword(String email) {
    logInfo('AuthDataSourceImpl:forgotPassword');

    return dioService.handleRequest(
      () async {
        final response = await dioClient.post(
          AppUrls.authForgotPasswordUrl,
          data: {'email': email},
          options: Options(contentType: Headers.formUrlEncodedContentType),
        );
        if (response.statusCode == 200) {
          logSuccess('Forgot Password Successful');
          saveUserToLocal(null, response.data['date']['token']);
          return;
        }
      },
    );
  }

  @override
  Future<UserEntity> signIn(String email, String password) {
    logInfo('AuthDataSourceImpl:signIn');

    return dioService.handleRequest(
      () async {
        final response = await dioClient.post(
          AppUrls.authLoginUrl,
          data: {'email': email, 'password': password},
        );
        if (response.statusCode == 200) {
          logSuccess('Sign In Successful');
          final user = UserEntity.fromMap(response.data['date']['userdata']);

          saveUserToLocal(user, response.data['date']['token']);
          return user;
        } else {
          throw Exception('Failed to login');
        }
      },
    );
  }

  @override
  Future<void> signOut() {
    logInfo('AuthDataSourceImpl:signOut');

    return dioService.handleRequest(
      () async {
        final response = await dioClient.post(
          AppUrls.authLogoutUrl,
        );
        if (response.statusCode == 200) {
          logSuccess('Sign Out Successful');
          saveUserToLocal(null, null);
          return;
        } else {
          throw Exception('Failed to signOut');
        }
      },
    );
  }

  @override
  Future<void> signUp(UserEntity user) {
    logInfo('AuthDataSourceImpl:signUp');

    return dioService.handleRequest(
      () async {
        final response = await dioClient.post(
          AppUrls.authSignUpUrl,
          data: user.toMap(),
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

  Future<UserEntity?> getUserFromLocal() async {
    logInfo('AuthDataSourceImpl:getUserFromLocal');

    try {
      final result =
          (await SecuredStorageKeys.user.getStoredValue()) as String?;
      if (result == null) {
        return null;
      }
      return UserEntity.fromJson(result);
    } catch (_) {
      return null;
    }
  }

  Future<void> saveUserToLocal(UserEntity? user, String? token) async {
    logInfo('AuthDataSourceImpl:saveUserToLocal');

    if (user == null) {
      await SecuredStorageKeys.user.delete();
      _controller.sink.add(null);
    } else {
      await SecuredStorageKeys.user.setValue(user.toJson());
      _controller.sink.add(user);
    }
    if (token == null) {
      await SecuredStorageKeys.token.delete();
    } else {
      await SecuredStorageKeys.token.setValue(token);
    }
  }

  @override
  Future<void> setNewPassword(String password) {
    logInfo('AuthDataSourceImpl:setNewPassword');

    return dioService.handleRequest(
      () async {
        final response = await dioClient.post(
          AppUrls.authSetNewPasswordUrl,
          data: {'newpassword': password},
        );
        if (response.statusCode == 200) {
          logSuccess('Set New Password Successful');
          final user = UserEntity.fromMap(response.data['date']['userdata']);
          saveUserToLocal(user, response.data['date']['token']);
          return;
        }
      },
    );
  }

  @override
  Future<void> verifyOtp(String otp,
      {ConfirmAccountReasons reason = ConfirmAccountReasons.singUp}) {
    logInfo('AuthDataSourceImpl:verifyOtp');

    return dioService.handleRequest(
      () async {
        final response = await dioClient.post(
          AppUrls.authVerifyOtpUrl,
          data: {
            'code': otp,
            'reason': reason.value,
            // 'sendingAt': DateTime.now(),
          },
        );
        if (response.statusCode == 200) {
          saveUserToLocal(
            response.data['date']['userdata'] == null
                ? null
                : UserEntity.fromMap(response.data['date']['userdata']),
            response.data['date']['token'],
          );
        }
      },
    );
  }

  @override
  Future<UserEntity?> signInWithCredentials(String token) {
    // TODO: implement signInWithCredentials
    throw UnimplementedError();
  }
}

enum ConfirmAccountReasons {
  singUp,
  resetPwd,
  ;

  String get value {
    switch (this) {
      case ConfirmAccountReasons.singUp:
        return 'sing-up';
      case ConfirmAccountReasons.resetPwd:
        return 'reset-pwd';
    }
  }
}
