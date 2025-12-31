import 'package:flutter/material.dart';

class LocaleController extends ChangeNotifier {
  Locale _locale = const Locale('en');

  Locale get locale => _locale;

  void setLocale(Locale locale) {
    _locale = locale;
    notifyListeners();
  }

  bool get isEnglish => _locale.languageCode == 'en';
}