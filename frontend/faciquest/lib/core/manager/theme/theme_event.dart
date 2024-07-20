// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'theme_bloc.dart';

sealed class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object?> get props => [];
}

class ThemeModeChanged extends ThemeEvent {
  final ThemeMode themeMode;
  const ThemeModeChanged({
    required this.themeMode,
  });

  @override
  List<Object?> get props => [themeMode];
}
