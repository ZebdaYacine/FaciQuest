import 'package:faciquest/features/features.dart';

class WalletRepositoryImpl implements WalletRepository {
  final WalletDataSource walletDataSource;

  WalletRepositoryImpl({
    required this.walletDataSource,
  });

  @override
  Future<double?> getWallet() async {
    return walletDataSource.getWallet();
  }

  @override
  Future<void> cashOut(double amount) {
    return walletDataSource.cashOut(amount);
  }
}
