import 'package:faciquest/features/features.dart';

abstract class WalletRepository {
  Future<WalletEntity> getWallet();
  Future<WalletEntity> updateWallet(UpdateWalletRequest request);
  Future<void> cashOutRequest(CashOutRequest request);
}
