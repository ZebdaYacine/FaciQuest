part of 'theme_bloc.dart';

class ThemeState extends Equatable {
  ThemeState({
    this.themeMode = ThemeMode.system,
    ThemeData? lightTheme,
    ThemeData? darkTheme,
  })  : lightTheme = lightTheme ?? AppTheme.light,
        darkTheme = darkTheme ?? AppTheme.dark;

  ///
  final ThemeMode themeMode;
  final ThemeData? lightTheme;
  final ThemeData? darkTheme;
  @override
  List<Object?> get props => [themeMode, lightTheme, darkTheme];

  ThemeState copyWith({
    ThemeMode? themeMode,
    ThemeData? lightTheme,
    ThemeData? darkTheme,
  }) {
    return ThemeState(
      themeMode: themeMode ?? this.themeMode,
      lightTheme: lightTheme ?? this.lightTheme,
      darkTheme: darkTheme ?? this.darkTheme,
    );
  }
}
