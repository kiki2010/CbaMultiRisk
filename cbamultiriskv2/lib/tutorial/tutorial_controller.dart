import 'package:shared_preferences/shared_preferences.dart';

enum TutorialStep {
  welcome,
  suqui,
  settings,
  last
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
  static Future<void> setStepSeen(TutorialStep step) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tutorialProgressKey, step.name);
  }

  //Get last step
  static Future<TutorialStep?> getLastStep() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(_tutorialProgressKey);
    if (value == null) return null;
    return TutorialStep.values.byName(value);
  }

  //Manual Reset
  static Future<void> resetTutorial() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tutorialSeenKey);
    await prefs.remove(_tutorialProgressKey);
  }

  //Check if tutorial should finish
  static Future<bool> shouldShowFinish() async {
    final prefs = await SharedPreferences.getInstance();

    final seen = prefs.getBool(_tutorialSeenKey) ?? false;
    if (seen) return false;

    final last = await getLastStep();
    return last == TutorialStep.settings;
  }
}
