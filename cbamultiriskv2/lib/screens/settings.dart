/*
Quiz Screen
Last Edit: 17/01/2026
Change: Comments were added
*/
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//Notifications and background task logic
import 'package:cbamultiriskv2/services/risknotifications.dart';

//Cards (In this screen used on the disclaimer)
import 'package:cbamultiriskv2/widgets/cards.dart';

//Theme controller
import 'package:cbamultiriskv2/theme/theme_controller.dart';

//Ingles y español
import 'package:cbamultiriskv2/l10n/locale_controller.dart';
import 'package:cbamultiriskv2/l10n/app_localizations.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});
  
  //Screen Time!
  @override
  Widget build(BuildContext context) {
    final themeController = context.watch<ThemeController>();
    
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
          )
        ],
      ),
    );
  }
}