part of 'set_new_password_cubit.dart';

class SetNewPasswordState with EquatableMixin {
  final String? password;
  final String? cPassword;
  final Status? status;
  final String? msg;

  SetNewPasswordState({
    this.password,
    this.cPassword,
    this.status,
    this.msg,
  });

  bool get isValid =>
      password != null && cPassword != null && password == cPassword;

  SetNewPasswordState copyWith({
    String? password,
    String? cPassword,
    Status? status,
    String? msg,
  }) {
    return SetNewPasswordState(
      password: password ?? this.password,
      cPassword: cPassword ?? this.cPassword,
      status: status ?? Status.initial,
      msg: msg,
    );
  }

  @override
  List<Object?> get props => [password, cPassword, status, msg];
}
