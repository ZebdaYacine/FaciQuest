part of 'personal_info_cubit.dart';

class PersonalInfoState extends Equatable {
  final UserEntity user;
  final bool isEditing;
  final Status status;
  final String? message;
  final String? emailError;
  final String? phoneError;
  final bool hasUnsavedChanges;
  final bool isRefreshing;

  const PersonalInfoState({
    this.user = UserEntity.empty,
    this.isEditing = false,
    this.status = Status.initial,
    this.message,
    this.emailError,
    this.phoneError,
    this.hasUnsavedChanges = false,
    this.isRefreshing = false,
  });

  @override
  List<Object?> get props => [
        user,
        isEditing,
        status,
        message,
        emailError,
        phoneError,
        hasUnsavedChanges,
        isRefreshing,
      ];

  bool get isValid =>
      user.username.isNotEmpty &&
      user.email.isNotEmpty &&
      emailError == null &&
      user.firstName.isNotEmpty &&
      user.lastName.isNotEmpty &&
      user.phone.isNotEmpty &&
      phoneError == null;

  PersonalInfoState copyWith({
    UserEntity? user,
    bool? isEditing,
    Status? status,
    String? message,
    String? emailError,
    String? phoneError,
    bool? hasUnsavedChanges,
    bool? isRefreshing,
  }) {
    return PersonalInfoState(
      user: user ?? this.user,
      isEditing: isEditing ?? this.isEditing,
      status: status ?? this.status,
      message: message ?? this.message,
      emailError: emailError ?? this.emailError,
      phoneError: phoneError ?? this.phoneError,
      hasUnsavedChanges: hasUnsavedChanges ?? this.hasUnsavedChanges,
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }
}
