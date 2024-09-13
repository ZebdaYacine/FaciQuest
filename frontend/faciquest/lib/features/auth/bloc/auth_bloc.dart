import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:faciquest/core/core.dart';
import 'package:faciquest/features/features.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(this.authRepository) : super(const AuthState()) {
    logInfo('AuthBloc: init');
    on<AuthenticationStarted>(_onAuthenticationStarted);
    on<SignOutRequested>(_onSignOutRequested);
    on<UserStateChanged>(_onUserStateChanged);
    on<RefreshRoute>((event, emit) {
      logInfo('AuthBloc: _onRefreshRoute');
      emit(state.copyWith(refreshRoute: event.refreshRoute));
    });
  }

  final AuthRepository authRepository;
  StreamSubscription<UserEntity?>? userSubscription;

  FutureOr<void> _onAuthenticationStarted(
    AuthenticationStarted event,
    Emitter<AuthState> emit,
  ) {
    logInfo('AuthBloc: _onAuthenticationStarted');
    userSubscription?.cancel();
    userSubscription = authRepository.user.listen((user) {
      add(UserStateChanged(user));
    });
  }

  FutureOr<void> _onSignOutRequested(
    SignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    logInfo('AuthBloc: _onSignOutRequested');
    await authRepository.signOut();
  }

  FutureOr<void> _onUserStateChanged(
    UserStateChanged event,
    Emitter<AuthState> emit,
  ) {
    logInfo('AuthBloc: _onUserStateChanged user:${event.user}');
    emit(
      state.copyWith(
        user: event.user,
        authStatus: event.user == null
            ? AuthStatus.unauthenticated
            : AuthStatus.authenticated,
      ),
    );
    if (state.refreshRoute) {
      getIt<RouteService>().refresh();
    }
  }
}
