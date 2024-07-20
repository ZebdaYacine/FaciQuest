import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:faciquest/core/core.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(ThemeState()) {
    on<ThemeModeChanged>(_onThemeModeChanged);
  }

  FutureOr<void> _onThemeModeChanged(
    ThemeModeChanged event,
    Emitter<ThemeState> emit,
  ) {
    logInfo('ThemeBloc: _onThemeModeChanged');
    emit(
      state.copyWith(
        themeMode: event.themeMode,
      ),
    );
    StorageKeys.themeMode.setValue(event.themeMode.name);
  }
}
