import 'package:faciquest/core/core.dart';
import 'package:flutter/material.dart';

///
class LanguageManager {
  LanguageManager._init();
  static final _instance = LanguageManager._init();

  /// singleton => to get only one instance of language manager
  static LanguageManager get instance => _instance;

  /// default language of the app will be arabic
  late Locale defaultLanguage = en;
  late Locale currentLocale = defaultLanguage;

  ///
  late Locale startLocale = en;

  ///
  final bool saveLocale = true;

  ///
  final bool useOnlyLangCode = true;

  ///
  final en = const Locale('en');

  ///
  final fr = const Locale('fr');

  ///
  final ar = const Locale('ar');

  ///
  final path = AppAssets.translations;

  /// supported locals ar,fr,en
  List<Locale> get supportedLocales => [ar, en, fr];

  ///
  static String localeTitle(Locale locale) {
    if (locale.languageCode == 'ar') return 'العربية';
    if (locale.languageCode == 'fr') return 'Français';
    if (locale.languageCode == 'en') return 'English';
    return '';
  }

  static String localeAssets(Locale locale) {
    if (locale.languageCode == 'ar') return 'assets/images/ar.png';
    if (locale.languageCode == 'fr') return 'assets/images/fr.png';
    if (locale.languageCode == 'en') return 'assets/images/en.png';
    return '';
  }
}
