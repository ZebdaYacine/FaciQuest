part of 'theme_bloc.dart';

class ThemeState extends Equatable {
  ThemeState({
    this.themeMode = ThemeMode.system,
    ThemeData? lightTheme,
    ThemeData? darkTheme,
  })  : lightTheme = lightTheme ??
            ThemeData.from(
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.blue,
                brightness: Brightness.light,
              ),
            ),
        darkTheme = darkTheme ??
            ThemeData.from(
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.blue,
                brightness: Brightness.dark,
              ),
            );

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
