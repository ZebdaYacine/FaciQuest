import 'package:faciquest/features/features.dart';

class WalletRepositoryImpl implements WalletRepository {
  const WalletRepositoryImpl({
    required this.walletDataSource,
  });

  final WalletDataSource walletDataSource;

  @override
  Future<WalletEntity> getWallet() async {
    return walletDataSource.getWallet();
  }

  @override
  Future<WalletEntity> updateWallet(UpdateWalletRequest request) async {
    return walletDataSource.updateWallet(request);
  }

  @override
  Future<void> cashOutRequest(CashOutRequest request) {
    return walletDataSource.cashOutRequest(request);
  }
}
