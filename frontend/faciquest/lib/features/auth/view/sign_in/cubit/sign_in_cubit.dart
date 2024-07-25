import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:equatable/equatable.dart';
import 'package:faciquest/core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'sign_in_state.dart';

class SignInCubit extends Cubit<SignInState> {
  SignInCubit() : super(const SignInState());

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

  onSignIn() {}
}
