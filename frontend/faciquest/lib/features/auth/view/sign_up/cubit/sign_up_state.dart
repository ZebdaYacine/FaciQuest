part of 'sign_up_cubit.dart';

class SignUpState extends Equatable {
  final UserEntity user;
  final String cPassword;
  final bool agreeToTerms;
  final Status status;
  final String? msg;
  const SignUpState({
    this.user = UserEntity.empty,
    this.cPassword = '',
    this.agreeToTerms = false,
    this.status = Status.initial,
    this.msg,
  });
  @override
  List<Object> get props => [user, agreeToTerms, cPassword];

  bool get isValid =>
      user.email.isNotEmpty &&
      user.email.isEmail &&
      user.password.isNotEmpty &&
      user.phone.isNotEmpty &&
      user.password == cPassword &&
      agreeToTerms;
  SignUpState copyWith({
    String? email,
    String? password,
    String? cPassword,
    String? firstName,
    String? lastName,
    String? phone,
    bool? agreeToTerms,
    Status? status,
    String? msg,
  }) {
    return SignUpState(
      agreeToTerms: agreeToTerms ?? this.agreeToTerms,
      cPassword: cPassword ?? this.cPassword,
      user: user.copyWith(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
        phone: phone,
      ),
      status: status ?? Status.initial,
      msg: msg,
    );
  }
}
