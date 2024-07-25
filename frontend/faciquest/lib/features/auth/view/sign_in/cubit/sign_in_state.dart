part of 'sign_in_cubit.dart';

class SignInState extends Equatable {
  final String email;
  final String password;
  final Status status;
  final String? msg;

  const SignInState({
    this.email = '',
    this.password = '',
    this.status = Status.initial,
    this.msg,
  });

  @override
  List<Object?> get props => [email, password, status, msg];

  SignInState copyWith({
    String? email,
    String? password,
    Status? status,
    String? msg,
  }) {
    return SignInState(
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? Status.initial,
      msg: msg,
    );
  }

  bool get isValid => email.isNotEmpty && password.isNotEmpty && email.isEmail;
}
