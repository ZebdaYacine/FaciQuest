part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SignOutRequested extends AuthEvent {}

class AuthenticationStarted extends AuthEvent {}

class UserStateChanged extends AuthEvent {
  final UserEntity? user;

  UserStateChanged(this.user);

  @override
  List<Object?> get props => [user];
}
