import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:faciquest/core/core.dart';
import 'package:faciquest/features/features.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  FlutterError.onError = (details) {
    logError('${details.exceptionAsString()}, stackTrace:${details.stack}');
  };
  Bloc.observer = MyBlocObserver();
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  // AppAssets.svgPreCacheImage();
  await setupDependencies();
  final languageManager = LanguageManager.instance;
  runApp(
    EasyLocalization(
      path: languageManager.path,
      startLocale: languageManager.startLocale,
      supportedLocales: languageManager.supportedLocales,
      saveLocale: languageManager.saveLocale,
      useOnlyLangCode: languageManager.useOnlyLangCode,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => getIt<AppBloc>()..add(SetupApp()),
          ),
          BlocProvider(create: (_) => getIt<AuthBloc>()),
          BlocProvider(create: (_) => getIt<ThemeBloc>()),
        ],
        child: await builder(),
      ),
    ),
  );
}
