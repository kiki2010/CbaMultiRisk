import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'screens/risk.dart';
import 'screens/suqui.dart';
import 'screens/settings.dart';

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
      RiskScreen(position: widget.position),
      SuquiScreen(position: widget.position),
      SettingScreen(position: widget.position),
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

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.warning_amber_outlined),
            label: 'Risk',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info_outline),
            label: 'Suqui',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            label: 'Setting',
          ),
        ],
      ),
    );
  }
}