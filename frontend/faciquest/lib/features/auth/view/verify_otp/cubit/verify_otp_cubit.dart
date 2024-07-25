import 'package:equatable/equatable.dart';
import 'package:faciquest/core/core.dart';
import 'package:faciquest/features/auth/auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'verify_otp_state.dart';

class VerifyOtpCubit extends Cubit<VerifyOtpState> {
  VerifyOtpCubit(this.authRepository) : super(VerifyOtpState());
  final AuthRepository authRepository;

  void setOtp(String otp) {
    emit(state.copyWith(otp: otp));
  }

  Future<void> submit() async {
    emit(state.copyWith(status: Status.showLoading));
    try {
      await authRepository.verifyOtp(state.otp);
      emit(state.copyWith(status: Status.success));
    } catch (e) {
      emit(
        state.copyWith(
          status: Status.failure,
          msg: e.toString(),
        ),
      );
    }
  }
}
