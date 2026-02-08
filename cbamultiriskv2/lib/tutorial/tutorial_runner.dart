import 'package:cbamultiriskv2/tutorial/tutorial_controller.dart';
import 'package:cbamultiriskv2/tutorial/tutorial_dialogs.dart';
import 'package:cbamultiriskv2/tutorial/tutorial_messages.dart';
import 'package:flutter/material.dart';

class TutorialRunner {
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