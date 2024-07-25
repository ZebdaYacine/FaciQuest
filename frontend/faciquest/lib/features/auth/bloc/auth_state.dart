part of 'auth_bloc.dart';

enum AuthStatus { initial, authenticated, unauthenticated }

class AuthState extends Equatable {
  final UserEntity? user;
  final AuthStatus authStatus;

  const AuthState({
    this.user,
    this.authStatus = AuthStatus.initial,
  });

  @override
  List<Object?> get props => [user, authStatus];
}
