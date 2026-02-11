/*
Main
last edit: 11/02/2026
Change: Changes for google PLay
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

//Tutorial
import 'package:cbamultiriskv2/tutorial/tutorial_controller.dart';
import 'package:cbamultiriskv2/tutorial/tutorial_runner.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); //Ensuring that Flutter is Initialized

  //Initialize background task and register a OneOffTask
  await Workmanager().initialize(riskCallbackDispatcher);
  await Workmanager().registerOneOffTask(
    'risk_debug_once',
    'calculate_risk',
  );

  //Run the app with multiple Providers (for management of theme, locale and background tasks)
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeController()),
        ChangeNotifierProvider(create: (_) => LocaleController()),
        ChangeNotifierProvider(create: (_) => BackgroundTaskProvider()),
      ],
      child: MyApp(),
    ),
  );
}

//Main Widget
class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
      home: MainScaffold(),
    );
  }
}

//Main Scaffold with a bottom navigation bar
class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _currentIndex = 0;
  Position? _position;

  void goToSuqui() {
    setState(() {
      _currentIndex = 1;
    });
  }

  @override
  void initState() {
    super.initState();

    //It runs after the first frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;

      //Get location:
      final shouldShow = await shouldShowLocationDisclosure();
      bool accepted = true;

      if (shouldShow) {
        accepted = await showLocationDisclosure(context);

        if (accepted) {
          await setLocationDisclosureAccepted();
        }
      }

      if (accepted) {
        final pos = await getUserLocation();
        if (!mounted) return;

        setState(() {
          _position = pos;
        });
      }

      //Show disclaimer
      final show = await shouldShowDisclaimer();
      if (show && mounted) {
        await showDisclaimerDialog(context);
        await setDisclaimerSeen();
      }

      //Show tutorial if there is a pending step
      final step = await TutorialController.getCurrentStep();

      if (!mounted || step == null) return;

      //If the current step is "welcome", the tutorial sequence begins.
      if (step  == TutorialStep.welcome) {
        await Future.delayed(const Duration(milliseconds: 200));
        await TutorialRunner.runIfNeeded(context);
      }

    });
  }
  
  //General app construction --> Bottom navigation bar
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          //Risk Screen
          RiskScreen(
            key: ValueKey(_position?.latitude.toString() ?? "no_location"),
            position: _position, 
            onSuquiTap: goToSuqui
          ),

          //Suqui Screen
          SuquiScreen(isActive: _currentIndex == 1),

          //Setting Screen
          SettingScreen(
            isActive: _currentIndex == 2,
            gotoRisk: () {
              setState(() => _currentIndex = 0);
            }
          ),
        ],
      ),

      //Bottom navigation bar
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