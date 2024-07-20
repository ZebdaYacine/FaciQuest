import 'package:faciquest/core/core.dart';
import 'package:faciquest/features/features.dart';
import 'package:go_router/go_router.dart';

class RouteManager {
  final routeService = getIt<RouteService>();
  final authBloc = getIt<AuthBloc>();
  late GoRouter router = GoRouter(
    observers: [AppRouteObserver()],
    refreshListenable: routeService,
    debugLogDiagnostics: true,
    initialLocation: AppRoutes.splash.path,
    routes: [
      AppRoutes.splash.goRoute(),
      AppRoutes.auth.goRoute(),
      AppRoutes.home.goRoute(),
    ],
    redirect: (context, state) {
      logInfo('RouteManager: redirect ${state.fullPath}');
      // switch (authBloc.state.authStatus) {
      //   case AuthStatus.initial:
      //     return AppRoutes.splash.path;
      //   case AuthStatus.authenticated:
      //     if (state.matchedLocation.startsWith(AppRoutes.auth.path) ||
      //         state.matchedLocation.startsWith(AppRoutes.splash.path)) {
      //       return '/';
      //     }
      //     return null;
      //   case AuthStatus.unauthenticated:
      //     if (!state.matchedLocation.startsWith(AppRoutes.auth.path)) {
      //       return AppRoutes.auth.path;
      //     }
      //     return null;
      // }
      return null;
    },
  );
}
