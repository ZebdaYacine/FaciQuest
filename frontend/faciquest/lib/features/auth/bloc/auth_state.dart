part of 'auth_bloc.dart';

enum AuthStatus { initial, authenticated, unauthenticated }

class AuthState extends Equatable {
  final UserEntity? user;
  final AuthStatus authStatus;
  final bool refreshRoute;

  const AuthState({
    this.user,
    this.authStatus = AuthStatus.initial,
    this.refreshRoute = true,
  });

  @override
  List<Object?> get props => [user, authStatus];

  AuthState copyWith({
    UserEntity? user,
    AuthStatus? authStatus,
    bool? refreshRoute,
  }) {
    return AuthState(
      user: user ?? this.user,
      authStatus: authStatus ?? this.authStatus,
      refreshRoute: refreshRoute ?? this.refreshRoute,
    );
  }
}
