import 'package:awesome_extensions/awesome_extensions.dart';

import 'package:equatable/equatable.dart';
import 'package:faciquest/core/core.dart';
import 'package:faciquest/features/auth/auth.dart';
import 'package:faciquest/features/features.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit(this.authRepository) : super(const SignUpState());

  final AuthRepository authRepository;

  // Validation methods
  String? _validateEmail(String email) {
    if (email.isEmpty) {
      return null; // Don't show error for empty field initially
    }

    // More comprehensive email regex based on RFC 5322
    const pattern = r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
        r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
        r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
        r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
        r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
        r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
        r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
    final emailRegex = RegExp(pattern, caseSensitive: false);

    if (!emailRegex.hasMatch(email)) {
      return 'Please enter a valid email address';
    }

    return null;
  }

  String? _validatePhone(String phone) {
    if (phone.isEmpty) {
      return null; // Don't show error for empty field initially
    }

    // Remove any non-digit characters for validation
    final digitsOnly = phone.replaceAll(RegExp(r'[^\d]'), '');

    if (digitsOnly.length < 10) {
      return 'Phone number must be at least 10 digits';
    } else if (digitsOnly.length > 10) {
      return 'Phone number cannot exceed 10 digits';
    }

    // Check if it starts with a valid digit (not 0 or 1 for US numbers)
    if (digitsOnly.startsWith('0') || digitsOnly.startsWith('1')) {
      return 'Phone number cannot start with 0 or 1';
    }

    return null;
  }

  void submit() async {
    emit(state.copyWith(status: Status.showLoading));
    try {
      await authRepository.signUp(state.user);
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
    final emailError = _validateEmail(value);
    emit(state.copyWith(
      email: value,
      emailError: emailError,
    ));
  }

  void onPhoneChanged(String value) {
    final phoneError = _validatePhone(value);
    emit(state.copyWith(
      phone: value,
      phoneError: phoneError,
    ));
  }

  void onPasswordChanged(String value) {
    emit(state.copyWith(password: value));
  }

  void onCPasswordChanged(String value) {
    emit(state.copyWith(cPassword: value));
  }

  void onUsernameChanged(String value) {
    emit(state.copyWith(username: value));
  }
}
