import 'package:faciquest/features/features.dart';
import 'package:get_it/get_it.dart';

registerAuth(GetIt getIt) {
  getIt
    ..registerLazySingleton<AuthDataSource>(
      () => AuthDataSourceImpl(dioService: getIt()),
    )
    ..registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(authDataSource: getIt<AuthDataSource>()),
    )
    ..registerLazySingleton(
      () => AuthBloc(getIt<AuthRepository>())..add(AuthenticationStarted()),
    );
}
