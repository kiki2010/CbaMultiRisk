/*
Setting Screen
Last Edit: 26/02/2026
Change: changed button to redirect to the rate screen.
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
import 'package:cbamultiriskv2/tutorial/tutorial_runner.dart';

//Feedback form
import 'package:url_launcher/url_launcher.dart';

class SettingScreen extends StatefulWidget {
  //Key details to restart the tutorial and check if the screen is active to display it
  final bool isActive;
  final VoidCallback gotoRisk; //Go to the risk screen

  const SettingScreen({super.key, required this.isActive, required this.gotoRisk});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  //If the screen is active, check if you need to watch the tutorial.
  @override
  void didUpdateWidget (covariant SettingScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (!oldWidget.isActive && widget.isActive) {
      TutorialRunner.runIfNeeded(context);
    }
  }

  //Funtion for going to the playstore to rate the app
  Future<void> _openFeedbackForm() async {
    final Uri url = Uri.parse(
      'https://docs.google.com/forms/d/e/1FAIpQLSeVlY2xzZJxM4hxnsynW5zXfk2BqpP4iJdPdTuW_Izwkt1MSw/viewform?usp=sharing&ouid=104097908284202419826'
    );

    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('We cannot open the form');
    }
  }

  //Screen time!
  @override
  Widget build(BuildContext context) {
    final themeController = context.watch<ThemeController>();

    //Preferences for saving emergency contact numbers
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

          const SizedBox(height: 24),

          //Call buttons!
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              iconButton(Icons.fire_truck_outlined, () {handleEmergencyButton(context, keyFire, AppLocalizations.of(context)!.firefighters);}),
              iconButton(Icons.local_hospital_outlined, () {handleEmergencyButton(context, keyAmbulance, AppLocalizations.of(context)!.ambulance);}),
              iconButton(Icons.add_call, () {handleEmergencyButton(context, keyEmergency, AppLocalizations.of(context)!.emergency);})
            ],
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

          const SizedBox(height: 24,),

          //Reset tutorial
          ElevatedButton.icon(
            label: Text("Tutorial"),
            icon: Icon(Icons.abc),
            //If pressed call reset Tutorial and go back to the main screen --> Previously we had a problem here where we had to exit the app to see the tutorial again.
            onPressed: () async {
              await TutorialController.resetTutorial();
              
              widget.gotoRisk();
              await Future.delayed(const Duration(milliseconds: 200));

              if (mounted) {
                TutorialRunner.runIfNeeded(context);
              }
            },
          ),

          const SizedBox(height: 24,),
          
          //Button to reset shared preferences.
          ElevatedButton.icon(
            label: Text(AppLocalizations.of(context)!.resetAll),
            icon: Icon(Icons.restore),
            onPressed: () {
              showResetDialog(context);
            },
          ),

          const SizedBox(height: 24,),

          ElevatedButton.icon(
            label: Text(AppLocalizations.of(context)!.feedback),
            icon: const Icon(Icons.feedback_outlined),
            onPressed: _openFeedbackForm,
          )
        ],
      ),
    );
  }
}