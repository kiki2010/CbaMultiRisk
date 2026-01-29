import 'package:cbamultiriskv1/main_scaffold.dart';
import 'package:cbamultiriskv1/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cbamultiriskv1/services/getlocation.dart';
import 'package:geolocator/geolocator.dart';

import 'package:cbamultiriskv1/theme/theme_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Position position = await getUserLocation();

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeController(),
      child: MyApp(position: position)
    )
  );
}

class MyApp extends StatelessWidget {
  final Position? position;
  const MyApp({super.key, required this.position});

  @override
  Widget build(BuildContext context) {
    final themeController = context.watch<ThemeController>();

    return MaterialApp(
      title: 'MultiRisk',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeController.themeMode,
      home: MainScaffold(position: position!),
    );
  }
}