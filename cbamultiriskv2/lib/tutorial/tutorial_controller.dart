import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum TutorialStep {
  welcome,
  tips,
  settings,
  finish
}

class TutorialController {
  static const String _tutorialSeenKey = 'tutorial_seen';
  static const String _tutorialProgressKey = 'tutorial_progress';

  //if the tutorial has already been viewed
  static Future<bool> shouldShowTutorial() async {
    final prefs = await SharedPreferences.getInstance();
    return !(prefs.getBool(_tutorialSeenKey) ?? false);
  }

  //mark the tutorial as complete
  static Future<void> setTutorialComplete() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_tutorialSeenKey, true);
    await prefs.remove(_tutorialProgressKey);
  }

  //Save last step
  static Future<void> setStepSeen(String step) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tutorialProgressKey, step);
  }

  //Get last step
  static Future<String?> getLastStep() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tutorialProgressKey);
  }

  //Manual Reset
  static Future<void> resetTutorial() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tutorialSeenKey);
    await prefs.remove(_tutorialProgressKey);
  }
}
