import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:cbamultiriskv2/services/risknotifications.dart';

import 'package:cbamultiriskv2/theme/theme_controller.dart';
import 'package:cbamultiriskv2/l10n/locale_controller.dart';

import 'package:cbamultiriskv2/l10n/app_localizations.dart';

class SettingScreen extends StatelessWidget {

  const SettingScreen({super.key});

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

          ElevatedButton(
            onPressed: () async {
              await calculateRiskAndNotify();
            },
            child: const Text('Test notificación'),
          )
        ],
      ),
    );
  }
}