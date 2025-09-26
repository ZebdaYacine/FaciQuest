part of 'sign_up_cubit.dart';

class SignUpState extends Equatable {
  final UserEntity user;
  final String cPassword;
  final bool agreeToTerms;
  final Status status;
  final String? msg;
  final String? emailError;
  final String? phoneError;
  const SignUpState({
    this.user = UserEntity.empty,
    this.cPassword = '',
    this.agreeToTerms = false,
    this.status = Status.initial,
    this.msg,
    this.emailError,
    this.phoneError,
  });
  @override
  List<Object?> get props => [user, agreeToTerms, cPassword, status, msg, emailError, phoneError];

  bool get isValid =>
      user.username.isNotEmpty &&
      user.email.isNotEmpty &&
      user.email.isEmail &&
      emailError == null &&
      user.password.isNotEmpty &&
      user.phone.isNotEmpty &&
      phoneError == null &&
      user.password == cPassword &&
      agreeToTerms;
  SignUpState copyWith({
    String? username,
    String? email,
    String? password,
    String? cPassword,
    String? firstName,
    String? lastName,
    String? phone,
    bool? agreeToTerms,
    Status? status,
    String? msg,
    String? emailError,
    String? phoneError,
  }) {
    return SignUpState(
      agreeToTerms: agreeToTerms ?? this.agreeToTerms,
      cPassword: cPassword ?? this.cPassword,
      user: user.copyWith(
        username: username,
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
        phone: phone,
      ),
      status: status ?? Status.initial,
      msg: msg,
      emailError: emailError,
      phoneError: phoneError,
    );
  }
}
