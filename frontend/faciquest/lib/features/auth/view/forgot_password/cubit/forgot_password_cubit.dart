import 'package:awesome_extensions/awesome_extensions.dart';

import 'package:equatable/equatable.dart';
import 'package:faciquest/core/core.dart';
import 'package:faciquest/features/auth/auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  ForgotPasswordCubit(this.authRepository) : super(const ForgotPasswordState());
  final AuthRepository authRepository;

  void onEmailChanged(String value) {
    emit(ForgotPasswordState(email: value));
  }

  Future<void> submit() async {
    emit(state.copyWith(status: Status.showLoading));
    try {
      getIt<AuthBloc>().add(RefreshRoute(false));
      await authRepository.forgotPassword(state.email);

      emit(state.copyWith(status: Status.hideLoading));
      emit(state.copyWith(status: Status.success));
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
