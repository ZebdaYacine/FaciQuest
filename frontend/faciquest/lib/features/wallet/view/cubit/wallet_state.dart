part of 'wallet_cubit.dart';

sealed class WalletState {}

final class WalletInitial extends WalletState {}

final class WalletLoaded extends WalletState {
  final double walletBalance;
  WalletLoaded(this.walletBalance);
}
