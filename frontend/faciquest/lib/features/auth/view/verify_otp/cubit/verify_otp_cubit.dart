import 'package:equatable/equatable.dart';
import 'package:faciquest/core/core.dart';
import 'package:faciquest/features/auth/auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'verify_otp_state.dart';

class VerifyOtpCubit extends Cubit<VerifyOtpState> {
  VerifyOtpCubit(this.authRepository, {required this.reason})
      : super(VerifyOtpState());
  final AuthRepository authRepository;

  final ConfirmAccountReasons reason;

  void setOtp(String otp) {
    emit(state.copyWith(otp: otp));
  }

  Future<void> submit() async {
    emit(state.copyWith(status: Status.showLoading));
    try {
      if (reason == ConfirmAccountReasons.resetPwd) {
        getIt<AuthBloc>().add(RefreshRoute(false));
      }
      await authRepository.verifyOtp(
        state.otp,
        reason: reason,
      );
      emit(state.copyWith(status: Status.hideLoading));
      emit(state.copyWith(
        status: Status.success,
        msg: 'OTP Verified',
      ));
    } catch (e) {
      emit(state.copyWith(status: Status.hideLoading));
      emit(
        state.copyWith(
          status: Status.failure,
          msg: e.toString(),
        ),
      );
    }
  }
}
