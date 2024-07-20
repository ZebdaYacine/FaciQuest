part of 'app_bloc.dart';

/// app events

sealed class AppEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

/// when the app is launched this event will be triggered
class SetupApp extends AppEvent {}

/// when the life cycle state changes this event will be triggered
/// [state] will change any time the user close or or open the app
class AppLifecycleStateChanged extends AppEvent {
  ///
  AppLifecycleStateChanged(this.state);

  ///
  final AppLifecycleState state;

  @override
  List<Object?> get props => [state];
}
