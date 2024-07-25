part of 'verify_otp_cubit.dart';

class VerifyOtpState with EquatableMixin {
  final String otp;
  final Status status;
  final String? msg;

  VerifyOtpState({
    this.otp = '',
    this.status = Status.initial,
    this.msg,
  });

  VerifyOtpState copyWith({
    String? email,
    String? otp,
    Status? status,
    String? msg,
  }) {
    return VerifyOtpState(
      otp: otp ?? this.otp,
      status: status ?? Status.initial,
      msg: msg,
    );
  }

  @override
  List<Object?> get props => [otp, status, msg];

  bool get isValid => otp.length == 6;
}
