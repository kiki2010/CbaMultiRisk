import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:math';
import 'dart:async';

import 'package:cbamultiriskv2/services/wudata.dart';
import 'package:cbamultiriskv2/services/firepredict.dart';
import 'package:cbamultiriskv2/services/floodpredict.dart';

import 'package:cbamultiriskv2/widgets/avatar.dart';
import 'package:cbamultiriskv2/widgets/cards.dart';
import 'package:cbamultiriskv2/widgets/speechBubble.dart';

import 'package:cbamultiriskv2/l10n/app_localizations.dart';

import 'suqui.dart';

class RiskScreen extends StatelessWidget {
  final Position? position;
  final VoidCallback? onSuquiTap;
  final flood = FloodPrediction();
  final fire = FirePrediction();
  
  RiskScreen({super.key, required this.position, required this.onSuquiTap});

  Future<Map<String, dynamic>> loadEverything() async {
    if (position == null) {
      throw Exception('Unable to get location');
    }

    final weatherService = WeatherStationService();

    await flood.loadFloodModel();
    await fire.loadFireModel();

    return  {
      'weather' : await weatherService.getAllWeatherData(position!),
      'floodRisk' : await flood.predictFlood(position!),
      'fireRisk' : await fire.predictFire(position!),
    };
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.risk),
      ),

      body: FutureBuilder(
        future: loadEverything(), 
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text(AppLocalizations.of(context)!.noData));
          }

          //General data
          final weather = snapshot.data!['weather'];
          final floodRisk = snapshot.data!['floodRisk'];
          final fireRisk = snapshot.data!['fireRisk'];

          //Station Id data
          final station = weather!['station'];

          //Actual data
          final actual = weather!['actual'];
          final temp = actual!['temperature'];
          final windSpeed = actual['windSpeed'];
          final humidity = actual['humidity'];
          final rain = actual['rain'];
          final precipRate = actual['precipRate'];
          final city = actual['neighborhood'];

          //Historical data
          final historical = weather!['historical'];
          final spi = historical['spi'];

          //Forecast data
          final forecast = weather!['forecast'];
          final List<Map<String, dynamic>> threeDayForecast = List<Map<String, dynamic>>.from(forecast);

          //Suqui Avatar (random selector)
          Random random = Random();
          int min = 1;
          int max = 3;

          final suquiRandom = random.nextInt(max - min + 1) + min;

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          riskCard(
                            context: context,
                            icon: Icons.local_fire_department,
                            title: AppLocalizations.of(context)!.fireRisk,
                            value: fireRisk
                          ),

                          const SizedBox(height: 15),

                          riskCard(
                            context: context,
                            icon: Icons.flood, 
                            title: AppLocalizations.of(context)!.floodRisk, 
                            value: floodRisk,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 15),

                    Expanded(
                      child: Stack(
                        alignment: Alignment.topCenter,
                        clipBehavior: Clip.none,
                        children: [
                          Positioned(
                            top: -40,
                            child: speechBubble(title: AppLocalizations.of(context)!.suquiHi(city), fontSize: 13),
                          ),

                          Padding(
                            padding: const EdgeInsets.only(top: 50),
                            child: suquiAvatar(
                              posIndex: suquiRandom, 
                              height: MediaQuery.of(context).size.height * 0.25, 
                              onTap: onSuquiTap ?? () {},
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),

                const SizedBox(height: 15),

                weatherCard(
                  context,
                  temp: temp,
                  wind: windSpeed,
                  hum: humidity,
                  rain: rain,
                  rainRate: precipRate,
                  spi: spi,
                  forecast: threeDayForecast,
                ),
              ],
            ),
          );
        }
      ),
    );
  }
}