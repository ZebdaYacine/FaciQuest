import 'package:equatable/equatable.dart';
import 'package:faciquest/core/core.dart';
import 'package:faciquest/features/features.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'personal_info_state.dart';

class PersonalInfoCubit extends Cubit<PersonalInfoState> {
  PersonalInfoCubit(this.authRepository) : super(const PersonalInfoState()) {
    _initializeUser();
  }

  final AuthRepository authRepository;

  void _initializeUser() {
    final currentUser = getIt<AuthBloc>().state.user;
    if (currentUser != null) {
      emit(state.copyWith(user: currentUser));
    }
  }

  // Validation methods (reused from SignUpCubit)
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

  void toggleEditMode() {
    emit(state.copyWith(isEditing: !state.isEditing));
  }

  void cancelEdit() {
    _initializeUser(); // Reset to original user data
    emit(state.copyWith(
      isEditing: false,
      hasUnsavedChanges: false,
      emailError: null,
      phoneError: null,
    ));
  }

  void onUsernameChanged(String value) {
    emit(state.copyWith(
      user: state.user.copyWith(username: value),
      hasUnsavedChanges: true,
    ));
  }

  void onFirstNameChanged(String value) {
    emit(state.copyWith(
      user: state.user.copyWith(firstName: value),
      hasUnsavedChanges: true,
    ));
  }

  void onLastNameChanged(String value) {
    emit(state.copyWith(
      user: state.user.copyWith(lastName: value),
      hasUnsavedChanges: true,
    ));
  }

  void onEmailChanged(String value) {
    final emailError = _validateEmail(value);
    emit(state.copyWith(
      user: state.user.copyWith(email: value),
      emailError: emailError,
      hasUnsavedChanges: true,
    ));
  }

  void onPhoneChanged(String value) {
    final phoneError = _validatePhone(value);
    emit(state.copyWith(
      user: state.user.copyWith(phone: value),
      phoneError: phoneError,
      hasUnsavedChanges: true,
    ));
  }

  void onBirthDateChanged(DateTime date) {
    emit(state.copyWith(
      user: state.user.copyWith(birthDate: date),
      hasUnsavedChanges: true,
    ));
  }

  void onBirthPlaceChanged(String value) {
    emit(state.copyWith(
      user: state.user.copyWith(birthPlace: value),
      hasUnsavedChanges: true,
    ));
  }

  void onCountryChanged(String value) {
    emit(state.copyWith(
      user: state.user.copyWith(country: value),
      hasUnsavedChanges: true,
    ));
  }

  void onMunicipalChanged(String value) {
    emit(state.copyWith(
      user: state.user.copyWith(municipal: value),
      hasUnsavedChanges: true,
    ));
  }

  void onEducationChanged(String value) {
    emit(state.copyWith(
      user: state.user.copyWith(education: value),
      hasUnsavedChanges: true,
    ));
  }

  void onWorkerAtChanged(String value) {
    emit(state.copyWith(
      user: state.user.copyWith(workerAt: value),
      hasUnsavedChanges: true,
    ));
  }

  void onInstitutionChanged(String value) {
    emit(state.copyWith(
      user: state.user.copyWith(institution: value),
      hasUnsavedChanges: true,
    ));
  }

  void onSocialStatusChanged(String value) {
    emit(state.copyWith(
      user: state.user.copyWith(socialStatus: value),
      hasUnsavedChanges: true,
    ));
  }

  Future<void> saveChanges() async {
    if (!state.isValid) {
      emit(state.copyWith(
        status: Status.failure,
        message: 'Please fix validation errors before saving',
      ));
      return;
    }

    emit(state.copyWith(status: Status.showLoading));

    try {
      // Update user via repository - this will automatically update the AuthBloc stream
      await authRepository.updateUser(state.user);

      emit(state.copyWith(
        status: Status.success,
        message: 'Profile updated successfully',
        isEditing: false,
        hasUnsavedChanges: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: Status.failure,
        message: 'Failed to update profile: ${e.toString()}',
      ));
    }
  }
}
