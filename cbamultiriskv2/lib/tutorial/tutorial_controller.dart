/*
Tutorial Controller
Last Edit: 08/02/2026
Change: Comments were added.
*/

//Import shared Preferences ..> needed for saving if we already saw the tutorial.
import 'package:shared_preferences/shared_preferences.dart';

//All the steps
enum TutorialStep {
  welcome,
  suqui,
  settings,
  last
}

//Tutorial Controller
class TutorialController {
  static const String _tutorialSeenKey = 'tutorial_seen';
  static const String _tutorialProgressKey = 'tutorial_progress';

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

  //Get Current Step
  static Future<TutorialStep?> getCurrentStep() async {
    final prefs = await SharedPreferences.getInstance();

    //If tutorial finished
    final completed = prefs.getBool(_tutorialSeenKey) ?? false;
    if (completed) return null;

    //If it never started "welcome".
    final lastStep = await getLastStep();
    if (lastStep == null) return TutorialStep.welcome;

    //Logical sequence
    switch (lastStep) {
      case TutorialStep.welcome:
        return TutorialStep.suqui;

      case TutorialStep.suqui:
        return TutorialStep.settings;

      case TutorialStep.settings:
        return TutorialStep.last;

      case TutorialStep.last:
        await setTutorialComplete();
        return null;
      
      default:
        return null;
    }

  }

  //Manual Reset --> called by the setting screen to restart tutorial.
  static Future<void> resetTutorial() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tutorialSeenKey);
    await prefs.remove(_tutorialProgressKey);
  }
}