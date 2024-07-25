import 'package:equatable/equatable.dart';
import 'package:faciquest/core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'verify_otp_state.dart';

class VerifyOtpCubit extends Cubit<VerifyOtpState> {
  VerifyOtpCubit() : super(VerifyOtpState());

  void setOtp(String otp) {
    emit(state.copyWith(otp: otp));
  }

  void submit() {}
}
