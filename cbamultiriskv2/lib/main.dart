import 'package:flutter/material.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';
import 'l10n/locale_controller.dart';

import 'package:geolocator/geolocator.dart'; 
import 'package:provider/provider.dart';

import 'screens/risk.dart';
import 'screens/suqui.dart';
import 'screens/settings.dart';

import 'package:cbamultiriskv2/services/getlocation.dart';

import 'package:cbamultiriskv2/theme/theme_controller.dart';
import 'theme/app_theme.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Position position = await getUserLocation();

  runApp(
  MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => ThemeController()),
      ChangeNotifierProvider(create: (_) => LocaleController()),
    ],
    child: MyApp(position: position),
  ),
);
}
class MyApp extends StatelessWidget {
  final Position? position;
  const MyApp({super.key, required this.position});

  @override
  Widget build(BuildContext context) {
    final themeController = context.watch<ThemeController>();
    final localeController = context.watch<LocaleController>();

    return MaterialApp(
      title: 'Material App',

      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      
      locale: localeController.locale,

      supportedLocales: [
        Locale('en'), // English
        Locale('es'), // Spanish
      ],

      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeController.themeMode,

      home: MainScaffold(position: position!),
    );
  }
}

class MainScaffold extends StatefulWidget {
  final Position position;

  const MainScaffold({super.key, required this.position});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _currentIndex = 0;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      RiskScreen(),
      SuquiScreen(),
      SettingScreen(),
    ];
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
        },

        type: BottomNavigationBarType.fixed,

        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.warning_amber_outlined),
            label: AppLocalizations.of(context)!.risk,
          ),
          
          BottomNavigationBarItem(
            icon: Icon(Icons.info_outline),
            label: AppLocalizations.of(context)!.tips,
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            label: AppLocalizations.of(context)!.settings,
          )
        ],
      ),
    );
  }
}