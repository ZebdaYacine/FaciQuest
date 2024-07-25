import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:faciquest/features/auth/auth.dart';
import 'package:faciquest/features/features.dart';

part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit() : super(const SignUpState());

  void onAgreeToTermsChanged(bool? value) {
    emit(state.copyWith(agreeToTerms: value));
  }

  void onFirstNameChanged(String value) {
    emit(
      state.copyWith(
        firstName: value,
      ),
    );
  }

  void onLastNameChanged(String value) {
    emit(
      state.copyWith(lastName: value),
    );
  }

  void onEmailChanged(String value) {
    emit(state.copyWith(email: value));
  }

  void onPhoneChanged(String value) {
    emit(state.copyWith(phone: value));
  }

  void onPasswordChanged(String value) {
    emit(state.copyWith(password: value));
  }

  void onCPasswordChanged(String value) {
    emit(state.copyWith(cPassword: value));
  }
}
