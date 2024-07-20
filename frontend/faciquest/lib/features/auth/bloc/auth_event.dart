part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

class SignOutRequested extends AuthEvent {}

class AuthenticationStarted extends AuthEvent {}
