part of 'wallet_cubit.dart';

sealed class WalletState {}

final class WalletInitial extends WalletState {}

final class WalletLoading extends WalletState {}

final class WalletLoaded extends WalletState {
  WalletLoaded(this.wallet);

  final WalletEntity wallet;
}

final class WalletUpdating extends WalletState {
  WalletUpdating(this.currentWallet);

  final WalletEntity currentWallet;
}

final class WalletError extends WalletState {
  WalletError(this.message);

  final String message;
}
