import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:cbamultiriskv2/services/risknotifications.dart';

import 'package:cbamultiriskv2/theme/theme_controller.dart';
import 'package:cbamultiriskv2/l10n/locale_controller.dart';

import 'package:cbamultiriskv2/l10n/app_localizations.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool _notificationsEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadNotificationSetting();
  }

  Future<void> _loadNotificationSetting() async {
    final enabled = await NotificationSettings.isEnabled();
    setState(() => _notificationsEnabled = enabled);
  }

  Future<void> _toggleNotifications(bool value) async {
    setState(() => _notificationsEnabled = value);
    await NotificationSettings.setEnabled(value);

    if (value) {
      await RiskTaskManager.enabled();
    } else {
      await RiskTaskManager.disable();
    }
  }

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

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(AppLocalizations.of(context)!.notifications),
              Switch(
                value: _notificationsEnabled,
                onChanged: _toggleNotifications,
              ),
            ],
          ),
        ],
      ),
    );
  }
}