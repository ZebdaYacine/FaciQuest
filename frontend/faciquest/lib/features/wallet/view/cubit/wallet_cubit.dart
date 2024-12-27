import 'package:faciquest/features/features.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'wallet_state.dart';

class WalletCubit extends Cubit<WalletState> {
  final WalletRepository walletRepository;
  WalletCubit(this.walletRepository) : super(WalletInitial());

  Future<void> getWallet() async {
    final wallet = await walletRepository.getWallet() ?? 0;
    emit(WalletLoaded(wallet));
  }

  Future<void> cashOut(double amount, String email) async {
    await walletRepository.cashOut(amount);
    await getWallet();
  }
}
