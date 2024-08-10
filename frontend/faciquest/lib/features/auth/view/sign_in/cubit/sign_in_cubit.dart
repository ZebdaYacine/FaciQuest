import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:equatable/equatable.dart';
import 'package:faciquest/core/core.dart';
import 'package:faciquest/features/auth/auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'sign_in_state.dart';

class SignInCubit extends Cubit<SignInState> {
  SignInCubit(this.authRepository) : super(const SignInState());

  final AuthRepository authRepository;

  onEmailChanged(String value) {
    emit(state.copyWith(
      email: value,
    ));
  }

  onPasswordChanged(String value) {
    emit(state.copyWith(
      password: value,
    ));
  }

  submit() async {
    if (!state.isValid) return;
    emit(state.copyWith(status: Status.showLoading));
    try {
      final user = await authRepository.signIn(
        state.email,
        state.password,
      );
      emit(state.copyWith(status: Status.hideLoading));
      emit(state.copyWith(
        status: Status.success,
        msg: 'welcome ${user.firstName}',
      ));
    } on ApiException catch (e) {
      emit(state.copyWith(status: Status.hideLoading));
      emit(state.copyWith(
        status: Status.failure,
        msg: e.message,
      ));
    }
  }
}
