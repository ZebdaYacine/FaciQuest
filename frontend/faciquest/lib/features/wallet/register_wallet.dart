import 'package:faciquest/core/core.dart';
import 'package:faciquest/features/features.dart';
import 'package:get_it/get_it.dart';

void registerWallet(GetIt getIt) {
  getIt
    ..registerLazySingleton<WalletDataSource>(
      () => WalletDataSourceImpl(
        dioClient: getIt(),
        dioService: getIt<DioService>(),
      ),
    )
    ..registerLazySingleton<WalletRepository>(
      () => WalletRepositoryImpl(
        walletDataSource: getIt<WalletDataSource>(),
      ),
    )
    ..registerLazySingleton(
      () => WalletCubit(
        getIt<WalletRepository>(),
      ),
    );
}
