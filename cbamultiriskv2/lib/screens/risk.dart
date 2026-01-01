import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'package:cbamultiriskv2/services/wudata.dart';
import 'package:cbamultiriskv2/l10n/app_localizations.dart';

class RiskScreen extends StatelessWidget {
  final Position? position;
  
  RiskScreen({super.key, required this.position});

  Future<Map<String, dynamic>> loadEverything() async {
    if (position == null) {
      throw Exception('Unable to get location');
    }

    final weatherService = WeatherStationService();

    return {
      'weather': await weatherService.getAllWeatherData(position!),
    };
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.risk),
      ),

      body: FutureBuilder(future: loadEverything(), builder: (context, snapshot) {
        return Padding(padding: const EdgeInsets.all(16),);
      }),
    );
  }
}