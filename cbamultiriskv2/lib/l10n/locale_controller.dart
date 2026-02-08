/*
Locale Controller
last edit: 08/02/2026
Change: Now the app first checks the language of the mobile phone. 
*/

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

//Class that controls the application's language and notifies of changes
class LocaleController extends ChangeNotifier {
  static const _key = 'locale';

  //Default language: Spanish
  Locale _locale = Locale('es');
  Locale get locale => _locale;

  LocaleController() {
    _loadLocale();
  }

  //Method to change the language
  void setLocale(Locale locale) {
    _locale = locale;
    _saveLocale();
    notifyListeners();
  }

  //Load the user preferences
  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_key);

    if (saved != null) {
      _locale = Locale(saved);
      notifyListeners();
      return;
    }

    final deviceLocale = WidgetsBinding.instance.platformDispatcher.locale;

    if (deviceLocale.languageCode == 'es') {
      _locale = const Locale('es');
    } else {
      _locale = const Locale('en');
    }

    notifyListeners();
  }

  //Save the user preferences
  Future<void> _saveLocale() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, _locale.languageCode);
  }
}