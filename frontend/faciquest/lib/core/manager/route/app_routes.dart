// ignore_for_file: unused_element

import 'package:faciquest/core/core.dart';
import 'package:faciquest/features/features.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

enum AppRoutes {
  splash('/splash', 'Splash', SplashPage()),
  auth('/auth', 'Auth', WelcomeView()),
  home('/home', 'Home', HomeView()),
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
}

mixin SupportPropsMixin {
  Widget fromMap({
    Map<String, String>? pathPrams,
    Object? extra,
  });
}
