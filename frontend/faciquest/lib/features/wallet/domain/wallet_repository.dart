abstract class WalletRepository {
  Future<double?> getWallet();
  Future<void> cashOut(double amount);
}
