/*
Quiz Screen
Last Edit: 04/02/2026
Change: Tutorial.
*/

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//Notifications and background task logic
import 'package:cbamultiriskv2/services/risknotifications.dart';

//Cards (In this screen used on the disclaimer)
import 'package:cbamultiriskv2/widgets/cards.dart';
import 'package:cbamultiriskv2/widgets/avatar.dart';

//Theme controller
import 'package:cbamultiriskv2/theme/theme_controller.dart';

//Ingles y español
import 'package:cbamultiriskv2/l10n/locale_controller.dart';
import 'package:cbamultiriskv2/l10n/app_localizations.dart';

//Tutorial
import 'package:cbamultiriskv2/tutorial/tutorial_controller.dart';
import 'package:cbamultiriskv2/tutorial/tutorial_dialogs.dart';
import 'package:cbamultiriskv2/tutorial/tutorial_messages.dart';

class SettingScreen extends StatefulWidget {
  final bool isActive;
  const SettingScreen({super.key, required this.isActive});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  void didUpdateWidget (covariant SettingScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (!oldWidget.isActive && widget.isActive) {
      showTutorialIfNeeded();
    }
  }

  bool _tutorialShown = false;

  Future<void> showTutorialIfNeeded() async {
    if (_tutorialShown) return;

    final step = await TutorialController.getCurrentStep();

    if(!mounted) return;

    if (step == TutorialStep.settings) {
      _tutorialShown = true;
      await runTutorialSequence(settingsSequence, TutorialStep.settings);
      await lastStepTutorial();
    } else if (step == TutorialStep.last) {
      await lastStepTutorial();
    }
  }

  Future<void> lastStepTutorial() async {
    final step = await TutorialController.getCurrentStep();
    if (!mounted) return;

    if (step == TutorialStep.last && mounted) {
      await runTutorialSequence(lastSequence, TutorialStep.last);
    }
  }

  Future<void> runTutorialSequence(List<Map<String, dynamic>> sequence, TutorialStep step) async {
    for (int index = 0; index < sequence.length; index++) {
      if (!mounted) return;

      await showTutorialDialog(
        context: context,
        message: sequence[index]['message'](context),
        suquiPose: sequence[index]['pose'],
        onNext: () {
          Navigator.pop(context);
        },
      );
    }

    await TutorialController.setStepSeen(step);

    if (step == TutorialStep.last) {
      await TutorialController.setTutorialComplete();
    }

    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final themeController = context.watch<ThemeController>();

    const String keyFire = 'phone_firefighters';
    const String keyAmbulance = 'phone_ambulance';
    const String keyEmergency = 'phone_emergency';

    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.settingTitle),),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              
              //Language
              Text(AppLocalizations.of(context)!.language),
              DropdownButtonHideUnderline(
                child: DropdownButton<Locale>(
                  value: context.watch<LocaleController>().locale,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  onChanged: (Locale? locale) {
                    if (locale == null) return;
                    context.read<LocaleController>().setLocale(locale);
                  },
                  items: const [
                    DropdownMenuItem(
                      value: Locale('es'),
                      child: Text('Español'),
                    ),
                    DropdownMenuItem(
                      value: Locale('en'),
                      child: Text('English'),
                    ),
                  ],
                ),
              )
            ],
          ),

          const SizedBox(height: 24,),
          
          //Theme Mode
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(AppLocalizations.of(context)!.darkMode),
              Switch(
                value: themeController.isDark,
                onChanged: (value) {
                  themeController.toggleTheme(value);
                },
              ),
            ],
          ),

          const SizedBox(height: 24,),

          //Notifications and Background Task
          Consumer<BackgroundTaskProvider>(
            builder: (context, bgTask, _) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(AppLocalizations.of(context)!.notifications),
                  Switch(
                    value: bgTask.isBackgroundTaskEnabled,
                    onChanged: bgTask.toggleBackgroundTask,
                  )
                ],
              );
            }
          ),

          const SizedBox(height: 24,),

          //Disclaimer of the app
          ElevatedButton.icon(
            label: Text(AppLocalizations.of(context)!.disclaimer),
            icon: Icon(Icons.info_outline_rounded),
            onPressed: () {
              showDisclaimerDialog(context);
            },
          ),

          const SizedBox(height: 24),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              iconButton(Icons.fire_truck_outlined, () {handleEmergencyButton(context, keyFire, AppLocalizations.of(context)!.firefighters);}),
              iconButton(Icons.local_hospital_outlined, () {handleEmergencyButton(context, keyAmbulance, AppLocalizations.of(context)!.ambulance);}),
              iconButton(Icons.add_call, () {handleEmergencyButton(context, keyEmergency, AppLocalizations.of(context)!.emergency);})
            ],
          ),

          const SizedBox(height: 24,),

          ElevatedButton.icon(
            label: Text("Tutorial"),
            icon: Icon(Icons.abc),
            onPressed: () async {
              await TutorialController.resetTutorial();
            },
          ),

          const SizedBox(height: 24,),
          
          ElevatedButton.icon(
            label: Text(AppLocalizations.of(context)!.resetAll),
            icon: Icon(Icons.restore),
            onPressed: () {
              showResetDialog(context);
            },
          ),
        ],
      ),
    );
  }
}