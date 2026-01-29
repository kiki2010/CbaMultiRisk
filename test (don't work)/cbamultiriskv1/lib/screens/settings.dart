import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cbamultiriskv1/theme/theme_controller.dart';

class SettingScreen extends StatelessWidget {

  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = context.watch<ThemeController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Setting'),),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Dark Mode"),
              Switch(
                value: themeController.isDark,
                onChanged: (value) {
                  themeController.toggleTheme(value);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}