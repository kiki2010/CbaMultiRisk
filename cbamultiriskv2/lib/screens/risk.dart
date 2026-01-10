/*
Risk Screen
last edit: 06/01/2026
Change: Comments were added
*/

import 'package:flutter/material.dart';
//geolocation, math and async
import 'package:geolocator/geolocator.dart';
import 'dart:math';
import 'dart:async';

//Services
import 'package:cbamultiriskv2/services/wudata.dart';
import 'package:cbamultiriskv2/services/firepredict.dart';
import 'package:cbamultiriskv2/services/floodpredict.dart';

//Custom widgets
import 'package:cbamultiriskv2/widgets/avatar.dart';
import 'package:cbamultiriskv2/widgets/cards.dart';
import 'package:cbamultiriskv2/widgets/speechBubble.dart';

//Spanish and English
import 'package:cbamultiriskv2/l10n/app_localizations.dart';

class RiskScreen extends StatelessWidget {
  final Position? position;
  final VoidCallback? onSuquiTap;
  final flood = FloodPrediction();
  final fire = FirePrediction();
  
  RiskScreen({super.key, required this.position, required this.onSuquiTap});

  //We initialize services, load AI models, and wait for your response.
  Future<Map<String, dynamic>> loadEverything() async {
    if (position == null) {
      throw Exception('LOCATION_ERROR');
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

      //We wait for everything to load and react according to the result.
      body: FutureBuilder(
        future: loadEverything(), 
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            final error = snapshot.error.toString();

            if (error.contains('LOCATION_ERROR')) {
              return SuquiError(
                message: AppLocalizations.of(context)!.locationError,
              );
            }

            return SuquiError(
              message: AppLocalizations.of(context)!.error(error),
            );
          } else if (!snapshot.hasData) {
            return SuquiError(
              message: AppLocalizations.of(context)!.noData,
            );
          }

          //We extract
          //General data
          final weather = snapshot.data!['weather'];
          final floodRisk = snapshot.data!['floodRisk'];
          final fireRisk = snapshot.data!['fireRisk'];

          //Station Id data (Not needed for the final User Interface)
          // final station = weather!['station'];

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
          final fixedSpi = spi.toStringAsFixed(2);

          //Forecast data
          final forecast = weather!['forecast'];
          final List<Map<String, dynamic>> threeDayForecast = List<Map<String, dynamic>>.from(forecast);

          //Suqui Avatar (random selector)
          Random random = Random();
          int min = 1;
          int max = 3;
          final suquiRandom = random.nextInt(max - min + 1) + min;
          
          //User Interface
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          //Risk Levels
                          riskCard(
                            context: context,
                            icon: Icons.local_fire_department,
                            title: AppLocalizations.of(context)!.fireRisk,
                            value: fireRisk,
                            onTap: () {
                              showInfoDialog(
                                context,
                                AppLocalizations.of(context)!.fireTitleExplanation,
                                AppLocalizations.of(context)!.fireExplanation,
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.local_fire_department, size: 60, color: Colors.green),
                                    Icon(Icons.local_fire_department, size: 60, color: Colors.amber),
                                    Icon(Icons.local_fire_department, size: 60, color: Colors.red),
                                  ],
                                ),
                              );
                            }
                          ),

                          const SizedBox(height: 15),

                          riskCard(
                            context: context,
                            icon: Icons.flood, 
                            title: AppLocalizations.of(context)!.floodRisk, 
                            value: floodRisk,
                            onTap: () {
                              showInfoDialog(
                                context,
                                AppLocalizations.of(context)!.floodTitleExplanation,
                                AppLocalizations.of(context)!.floodExplanation,
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.flood, size: 60, color: Colors.green),
                                    Icon(Icons.flood, size: 60, color: Colors.amber),
                                    Icon(Icons.flood, size: 60, color: Colors.red),
                                  ],
                                )
                              );
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 15),

                    //Suqui
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius.circular(18)),
                          border: Border.all(
                            color: Color(0xFF2B70C9),
                            width: 2,
                          )
                        ),
                        child: Stack(
                          alignment: Alignment.topCenter,
                          clipBehavior: Clip.none,
                          children: [
                            Positioned(
                              top: -40,
                              child: speechBubble(
                                title: AppLocalizations.of(context)!.suquiHi(city),
                                fontSize: 13
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: SuquiAvatar(
                                posIndex: suquiRandom,
                                height: MediaQuery.of(context).size.height * 0.25,
                                onTap: onSuquiTap ?? () {},
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),

                const SizedBox(height: 15),

                //Weather data
                weatherCard(
                  context,
                  temp: temp,
                  wind: windSpeed,
                  hum: humidity,
                  rain: rain,
                  rainRate: precipRate,
                  spi: fixedSpi,
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