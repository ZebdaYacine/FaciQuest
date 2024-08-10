import 'dart:async';

import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:faciquest/core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc() : super(const AppState()) {
    logInfo('AppBloc: init');
    on<SetupApp>(_onSetupApp);
    on<AppLifecycleStateChanged>(_onAppLifecycleStateChanged);
    add(SetupApp());
  }

  FutureOr<void> _onSetupApp(
    SetupApp event,
    Emitter<AppState> emit,
  ) async {
    logInfo('AppBloc: _onSetupApp');
    //? INFO: Load old settings here
    final storedTheme = (await StorageKeys.themeMode.storedValue) as String?;
    final theme = ThemeMode.values
        .firstWhereOrNull((element) => element.name == storedTheme);
    if (theme != null) {
      getIt<ThemeBloc>().add(ThemeModeChanged(themeMode: theme));
    }
    emit(state.copyWith(appStatus: AppStatus.complete));
  }

  FutureOr<void> _onAppLifecycleStateChanged(
    AppLifecycleStateChanged event,
    Emitter<AppState> emit,
  ) async {
    logInfo('AppBloc: _onAppLifecycleStateChanged ${event.state}');
    switch (event.state) {
      case AppLifecycleState.detached:
        // when the user close the app
        //  Handle AppLifecycleState.detached
        emit(const AppState(state: AppLifecycleState.detached));
      case AppLifecycleState.resumed:
        //when the user come back to the app
        // here we can show if the user active or not
        // FirebaseMethods.updateLiveStatus(uid);
        //  Handle AppLifecycleState.resumed.

        emit(const AppState());
      case AppLifecycleState.inactive:
        //
        // Handle AppLifecycleState.inactive

        emit(const AppState(state: AppLifecycleState.inactive));
      case AppLifecycleState.hidden:
        // when the app is minimized
        // Handle AppLifecycleState.hidden

        emit(const AppState(state: AppLifecycleState.hidden));
      case AppLifecycleState.paused:
        // the app is not visible to the user
        // Handle AppLifecycleState.paused

        emit(const AppState(state: AppLifecycleState.paused));
    }
  }
}
