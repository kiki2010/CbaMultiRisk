import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleController extends ChangeNotifier {
  static const _key = 'locale';

  Locale _locale = const Locale('es');
  Locale get locale => _locale;

  LocaleController() {
    _loadLocale();
  }

  void setLocale(Locale locale) {
    _locale = locale;
    _saveLocale();
    notifyListeners();
  }

  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_key) ?? 'es';
    _locale = Locale(code);
    notifyListeners();
  }

  Future<void> _saveLocale() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, _locale.languageCode);
  }
}
