import 'package:faciquest/features/features.dart';
import 'package:get_it/get_it.dart';

void registerWallet(GetIt getIt) {
  getIt
    ..registerLazySingleton<WalletDataSource>(
      () => WalletDataSourceImpl(dioClient: getIt()),
    )
    ..registerLazySingleton<WalletRepository>(
      () => WalletRepositoryImpl(
        walletDataSource: getIt<WalletDataSource>(),
      ),
    )..registerLazySingleton(
      () => WalletCubit(
        getIt<WalletRepository>(),
      ),
    );

}
