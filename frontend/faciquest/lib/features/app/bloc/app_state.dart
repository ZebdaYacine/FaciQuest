part of 'app_bloc.dart';

enum AppStatus { initial, complete }

class AppState extends Equatable {
  const AppState({
    this.state = AppLifecycleState.resumed,
    this.appStatus = AppStatus.initial,
    this.status = Status.initial,
    this.msg,
  });
  final AppLifecycleState state;
  final AppStatus appStatus;
  final Status status;
  final String? msg;

  @override
  List<Object?> get props => [appStatus, state, status, msg];

  AppState copyWith({
    AppStatus? appStatus,
    Status? status,
    String? msg,
  }) {
    return AppState(
      appStatus: appStatus ?? this.appStatus,
      status: status ?? Status.initial,
      msg: msg,
    );
  }

  bool get isResumed => state == AppLifecycleState.resumed;
}
