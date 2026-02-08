/*
Tutorial Runner
Last Edit: 08/02/2026
Change: Comments were added.
*/

//We import material
import 'package:flutter/material.dart';

//All the tutorial files needed
import 'package:cbamultiriskv2/tutorial/tutorial_controller.dart';
import 'package:cbamultiriskv2/tutorial/tutorial_dialogs.dart';
import 'package:cbamultiriskv2/tutorial/tutorial_messages.dart';

//The idea behind Tutorial Runner is to simplify how we call the tutorial on all screens.
//To do this, we'll use elements created in the other tutorial files and create logic to avoid repeating the tutorial on each screen.
//This way, if we add more screens, we can add the tutorial as well!
class TutorialRunner {
  //Method to verify which sequence to display based on the step we obtain as current Step
  static Future<void> runIfNeeded(BuildContext context) async {
    final step = await TutorialController.getCurrentStep();
    if (step == null) return;

    switch (step) {
      case TutorialStep.welcome:
        await _runSequence(context, welcomeSequence, TutorialStep.welcome);
        break;

      case TutorialStep.suqui:
        await _runSequence(context, suquiSequence, TutorialStep.suqui);
        break;
      
      case TutorialStep.settings:
        await _runSequence(context, settingsSequence, TutorialStep.settings);
        break;

      case TutorialStep.last:
        await _runSequence(context, lastSequence, TutorialStep.last);
        break;
    }
  }

  //Execute the complete tutorial sequence, going through each message of the Step.
  static Future<void> _runSequence(
    BuildContext context,
    List<Map<String, dynamic>> sequence,
    TutorialStep step,
  ) async {
    for (final item in sequence) {
      await showTutorialDialog(
        context: context,
        message: item['message'](context),
        suquiPose: item['pose'],
        onNext: () => Navigator.pop(context),
      );
    }

    await TutorialController.setStepSeen(step);

    if (step == TutorialStep.settings) {
      await _runSequence(context, lastSequence, TutorialStep.last);
    }

    if (step == TutorialStep.last) {
      await TutorialController.setTutorialComplete();
    }
  }
}