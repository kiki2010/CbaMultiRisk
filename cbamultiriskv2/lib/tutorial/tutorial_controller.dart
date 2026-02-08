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

    //Si nunca empezo welcome
    final lastStep = await getLastStep();
    if (lastStep == null) return TutorialStep.welcome;

    //Secuencia logica
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

  //Manual Reset
  static Future<void> resetTutorial() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tutorialSeenKey);
    await prefs.remove(_tutorialProgressKey);
  }
}