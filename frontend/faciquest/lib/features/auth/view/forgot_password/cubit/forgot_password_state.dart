part of 'forgot_password_cubit.dart';

class ForgotPasswordState extends Equatable {
  final String email;
  final Status status;
  final String? msg;

  const ForgotPasswordState({
    this.email = '',
    this.status = Status.initial,
    this.msg,
  });

  @override
  List<Object?> get props => [email, status, msg];

  ForgotPasswordState copyWith({
    String? email,
    Status? status,
    String? msg,
  }) {
    return ForgotPasswordState(
      email: email ?? this.email,
      status: status ?? Status.initial,
      msg: msg,
    );
  }

  bool get isValid => email.isEmail && email.isNotEmpty;
}
