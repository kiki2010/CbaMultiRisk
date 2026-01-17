/*
Main
last edit: 17/01/2026
Change: comments were added
*/
import 'package:flutter/material.dart';

import 'package:provider/provider.dart'; //State management

//Language!
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';
import 'l10n/locale_controller.dart';

//Screens (main Screens)
import 'screens/risk.dart';
import 'screens/suqui.dart';
import 'screens/settings.dart';

//Location
import 'package:geolocator/geolocator.dart'; //For getting location
import 'package:cbamultiriskv2/services/getlocation.dart';

//Notifications
import 'package:workmanager/workmanager.dart'; //Background task
import 'package:cbamultiriskv2/services/risknotifications.dart';

//Cards widgets
import 'package:cbamultiriskv2/widgets/cards.dart';

//Theme of the app
import 'package:cbamultiriskv2/theme/theme_controller.dart';
import 'theme/app_theme.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized(); //Ensuring that Flutter is Initialized

  //Initialize background task and register a OneOffTask
  await Workmanager().initialize(riskCallbackDispatcher);
  await Workmanager().registerOneOffTask(
    'risk_debug_once',
    'calculate_risk',
  );

  //Get user position
  Position position = await getUserLocation();

  //Run the app with multiple Providers (for management of theme, locale and background tasks)
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeController()),
        ChangeNotifierProvider(create: (_) => LocaleController()),
        ChangeNotifierProvider(create: (_) => BackgroundTaskProvider()),
      ],
      child: MyApp(position: position),
    ),
  );
}

//Main Widget
class MyApp extends StatelessWidget {
  final Position? position;
  const MyApp({super.key, required this.position});

  @override
  Widget build(BuildContext context) {
    //Lenguaje and theme changes
    final themeController = context.watch<ThemeController>();
    final localeController = context.watch<LocaleController>();

    return MaterialApp(
      title: 'MultiRisk',

      //Locale setup
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

      //Theme setup
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeController.themeMode,

      //Main Scaffold
      home: MainScaffold(position: position!),
    );
  }
}

//Main Scaffold with a bottom navigation bar
class MainScaffold extends StatefulWidget {
  final Position position;

  const MainScaffold({super.key, required this.position});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _currentIndex = 0;

  late final List<Widget> _screens;

  void goToSuqui() {
    setState(() {
      _currentIndex = 1;
    });
  }

  @override
  void initState() {
    super.initState();
    _screens = [
      RiskScreen(position: widget.position, onSuquiTap: goToSuqui),
      SuquiScreen(),
      SettingScreen(),
    ];

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final show = await shouldShowDisclaimer();
      if (show && mounted) {
        showDisclaimerDialog(context);
        await setDisclaimerSeen();
      }
    });
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

        //BottomNavigationBar Items for each screen:
        items: [
          //Risk Screen
          BottomNavigationBarItem(
            icon: Icon(Icons.warning_amber_outlined),
            label: AppLocalizations.of(context)!.risk,
          ),

          //Tips Screen
          BottomNavigationBarItem(
            icon: Icon(Icons.info_outline),
            label: AppLocalizations.of(context)!.tips,
          ),

          //Setting Screen
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            label: AppLocalizations.of(context)!.settings,
          )
        ],
      ),
    );
  }
}