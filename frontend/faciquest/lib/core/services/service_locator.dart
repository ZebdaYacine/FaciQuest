import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:dio/dio.dart';
import 'package:faciquest/core/core.dart';
import 'package:faciquest/features/features.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;
Future<void> setupDependencies() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  AndroidOptions getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );
  final flutterSecureStorage = FlutterSecureStorage(
    aOptions: getAndroidOptions(),
  );
  final dio = Dio(
    BaseOptions(
      sendTimeout: 30.seconds,
      connectTimeout: 30.seconds,
      receiveTimeout: 30.seconds,
    ),
  );
  getIt
    ..registerLazySingleton(
      () => sharedPreferences,
    )
    ..registerLazySingleton(
      () => flutterSecureStorage,
    )
    ..registerLazySingleton(() => AppBloc())

    /// Theme
    ..registerSingleton(ThemeBloc())

    /// Route services
    ..registerSingleton<RouteService>(RouteService())
    ..registerLazySingleton(() => RouteManager())

    /// Dio
    ..registerSingleton<Dio>(dio)
    ..registerLazySingleton<DioService>(() => DioService(dio));

  registerAuth(getIt);
}
