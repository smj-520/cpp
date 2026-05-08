import 'package:flutter/material.dart';

class AppSettingsController extends ChangeNotifier {
  AppSettingsController._();
  static final AppSettingsController instance = AppSettingsController._();

  ThemeMode _themeMode = ThemeMode.light;
  Locale _locale = const Locale('en');

  ThemeMode get themeMode => _themeMode;
  Locale get locale => _locale;

  bool get isDark => _themeMode == ThemeMode.dark;
  bool get isArabic => _locale.languageCode == 'ar';

  void setThemeMode(ThemeMode mode) {
    if (_themeMode == mode) return;
    _themeMode = mode;
    notifyListeners();
  }

  void setLanguage(String languageCode) {
    final next = Locale(languageCode);
    if (_locale == next) return;
    _locale = next;
    notifyListeners();
  }
}
