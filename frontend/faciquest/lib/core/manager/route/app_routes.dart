// ignore_for_file: unused_element

import 'package:faciquest/core/core.dart';
import 'package:faciquest/features/features.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

enum AppRoutes {
  splash('/splash', 'Splash', SplashPage()),
  auth('/auth', 'Auth', WelcomeView()),
  forgotPassword('forgot-password', 'Forgot Password', ForgotPasswordView()),
  setNewPassword('set-new-password', 'Set New Password', SetNewPasswordView()),
  signIn('sign-in', 'Sign In', SignInView()),
  signUp('sign-up', 'Sign Up', SignUpView()),
  verifyOtp('verify-otp/:from', 'Verify OTP', VerifyOtpView()),

  home('/', 'Home', HomeView()),
  ;

  const AppRoutes(
    this.path,
    this.name,
    this.view, {
    this.supportProps = false,
  });

  ///
  final String path;

  ///
  final String name;
  final bool supportProps;

  ///
  final Widget view;

  /// generate goRoute
  GoRoute goRoute([
    List<RouteBase>? routes,
    Page<dynamic> Function(
      BuildContext context,
      GoRouterState goRouterState,
    )? pageBuilder,
  ]) {
    return GoRoute(
      path: path,
      name: name,
      routes: routes ?? [],
      pageBuilder: pageBuilder ??
          (context, state) {
            return MaterialPage(
              child: (view is SupportPropsMixin && supportProps)
                  ? (view as SupportPropsMixin).fromMap(
                      pathPrams: state.pathParameters,
                      extra: state.extra,
                    )
                  : view,
              key: state.pageKey,
            );
          },
    );
  }

  Future<T?> push<T>(
    BuildContext context, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, dynamic> queryParameters = const <String, dynamic>{},
    Object? extra,
  }) async {
    return context.pushNamed<T>(
      name,
      pathParameters: pathParameters,
      queryParameters: queryParameters,
      extra: extra,
    );
  }

  Future<void> pushReplacement(
    BuildContext context, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, dynamic> queryParameters = const <String, dynamic>{},
    Object? extra,
  }) async {
    return context.pushReplacementNamed(
      name,
      pathParameters: pathParameters,
      queryParameters: queryParameters,
      extra: extra,
    );
  }
}

mixin SupportPropsMixin {
  Widget fromMap({
    Map<String, String>? pathPrams,
    Object? extra,
  });
}
