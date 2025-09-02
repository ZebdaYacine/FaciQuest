import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:faciquest/core/core.dart';
import 'package:faciquest/features/features.dart' hide State;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppView extends StatefulWidget {
  const AppView({super.key});

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    getIt<AppBloc>().add(AppLifecycleStateChanged(state));
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      buildWhen: (previous, current) => previous.themeMode != current.themeMode,
      builder: (context, themeState) {
        return MaterialApp.router(
          title: 'onemobe',
          // localization
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          // theme
          themeAnimationStyle: AnimationStyle(
            curve: Curves.fastOutSlowIn,
            duration: 400.milliseconds,
          ),
          themeMode: themeState.themeMode,
          theme: themeState.lightTheme,
          darkTheme: themeState.darkTheme,
          // route
          routerConfig: getIt<RouteManager>().router,
          builder: (context, child) {
            return Unfocus(
              child: child!,
            );
          },
        );
      },
    );
  }
}

/// A widget that un focus everything when tapped.
///
/// This implements the "Unfocus when tapping in empty space" behavior for the
/// entire application.
class Unfocus extends StatelessWidget {
  const Unfocus({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: child,
    );
  }
}
