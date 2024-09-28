import 'package:faciquest/core/core.dart';
import 'package:faciquest/features/features.dart';
import 'package:flutter/material.dart';
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
      AppRoutes.setNewPassword.goRoute(),
      GoRoute(
        path: '/auth',
        redirect: (context, goState) => '/auth/${AppRoutes.signIn.path}',
      ),
      AppRoutes.auth.goRoute([
        AppRoutes.forgotPassword.goRoute(),
        AppRoutes.signIn.goRoute(),
        AppRoutes.signUp.goRoute(),
        AppRoutes.verifyOtp.goRoute(
          [],
          (context, goRouterState) {
            return MaterialPage(
              child: VerifyOtpView(
                from:
                    VerifyOtpFrom.fromMap(goRouterState.pathParameters['from']),
              ),
            );
          },
        ),
      ]),
      AppRoutes.home.goRoute([
        AppRoutes.profile.goRoute(),
        AppRoutes.personalInfo.goRoute(),
        AppRoutes.wallet.goRoute(),
        AppRoutes.howItWorks.goRoute(),
        AppRoutes.newSurvey.goRoute([], (context, goRouterState) {
          final surveyAction =
              goRouterState.extra as SurveyAction? ?? SurveyAction.newSurvey;

          return MaterialPage(
            child: NewSurveyView(
              surveyAction: surveyAction,
              surveyId: goRouterState.pathParameters['id'] ?? '-1',
            ),
          );
        }),
        AppRoutes.survey.goRoute(
          [],
          (context, goRouterState) {
            return MaterialPage(
              child: SurveyView(
                surveyId: goRouterState.pathParameters['id'] ?? '',
              ),
            );
          },
        ),
        AppRoutes.manageMySurveys.goRoute(),
      ]),
    ],
    redirect: (context, state) {
      logInfo('RouteManager: redirect ${state.fullPath}');
      switch (authBloc.state.authStatus) {
        case AuthStatus.initial:
          return AppRoutes.splash.path;
        case AuthStatus.authenticated:
          if (state.matchedLocation.startsWith(AppRoutes.auth.path) ||
              state.matchedLocation.startsWith(AppRoutes.splash.path)) {
            return '/';
          }
          return null;
        case AuthStatus.unauthenticated:
          if (!state.matchedLocation.startsWith(AppRoutes.auth.path)) {
            return AppRoutes.auth.path;
          }
          return null;
      }
    },
  );
}
