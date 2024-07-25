import 'package:awesome_extensions/awesome_extensions.dart';

import 'package:equatable/equatable.dart';
import 'package:faciquest/core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  ForgotPasswordCubit() : super(const ForgotPasswordState());

  void onEmailChanged(String value) {
    emit(ForgotPasswordState(email: value));
  }

  Future<void> resetPassword() async {
    if (state.isValid) {
      await Future.delayed(const Duration(seconds: 2));
      emit(const ForgotPasswordState(status: Status.success));
    }
  }
}
