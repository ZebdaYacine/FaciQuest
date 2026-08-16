import 'package:faciquest/core/core.dart';
import 'package:faciquest/features/features.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'wallet_state.dart';

class WalletCubit extends Cubit<WalletState> {
  WalletCubit(this.walletRepository) : super(WalletInitial());

  final WalletRepository walletRepository;

  Future<void> getWallet() async {
    try {
      emit(WalletLoading());
      final wallet = await walletRepository.getWallet();
      emit(WalletLoaded(wallet));
    } on ApiException catch (e) {
      emit(WalletError(e.message));
    } catch (e) {
      emit(WalletError('Failed to load wallet: ${e.toString()}'));
    }
  }

  Future<void> updateWallet(UpdateWalletRequest request) async {
    try {
      if (state is WalletLoaded) {
        emit(WalletUpdating((state as WalletLoaded).wallet));
      } else {
        emit(WalletLoading());
      }

      final wallet = await walletRepository.updateWallet(request);
      emit(WalletLoaded(wallet));
    } on ApiException catch (e) {
      emit(WalletError(e.message));
    } catch (e) {
      emit(WalletError('Failed to update wallet: ${e.toString()}'));
    }
  }

  Future<void> cashOutRequest(CashOutRequest request) async {
    try {
      if (state is WalletLoaded) {
        final currentWallet = (state as WalletLoaded).wallet;

        // Validate amount
        if (request.amount > currentWallet.amount) {
          emit(WalletError('Amount exceeds wallet balance'));
          return;
        }

        if (!currentWallet.isCashable) {
          emit(WalletError('Wallet is not cashable at the moment'));
          return;
        }
      }

      await walletRepository.cashOutRequest(request);

      // Refresh wallet to get updated balance
      await getWallet();
    } on ApiException catch (e) {
      emit(WalletError(e.message));
    } catch (e) {
      emit(WalletError('Failed to submit cash out request: ${e.toString()}'));
    }
  }
}
