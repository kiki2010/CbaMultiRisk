import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ThemeController extends ChangeNotifier {
  static const _key = 'isDarkMode';

  bool _isDark = false;
  bool get isDark => _isDark;

  ThemeMode get themeMode =>
    _isDark ? ThemeMode.dark : ThemeMode.light;

  ThemeController() {
    _loadTheme();
  }

  void toggleTheme(bool value) {
    _isDark = value;
    _saveTheme();
    notifyListeners();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    _isDark = prefs.getBool(_key) ?? false;
    notifyListeners();
  }

  Future<void> _saveTheme() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, _isDark);
  }
}