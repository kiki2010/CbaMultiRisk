import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cbamultiriskv1/services/firepredict.dart';
import 'package:cbamultiriskv1/services/floodpredict.dart';
import 'package:cbamultiriskv1/services/wudata.dart';
import 'dart:math';
import 'dart:async';
import 'package:cbamultiriskv1/widgets/cards.dart';

class RiskScreen extends StatelessWidget {
  final Position? position;
  final flood = FloodPrediction();
  final fire = FirePrediction();

  RiskScreen({super.key, required this.position});

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
      appBar: AppBar(title: const Text('Risk Screen'),),

      body: FutureBuilder<Map<String, dynamic>>(
        future: loadEverything(), 
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No se encontraron datos'));
          }
          
          final weather = snapshot.data!['weather'];
          final floodRisk = snapshot.data!['floodRisk'];
          final fireRisk = snapshot.data!['fireRisk'];

          //station Id data
          final station = weather!['station'];
          final stationid = station['stationId'];
          final updateTime = station['updateTime'];
          final distance = station['distance'];

          //Actual data
          final actual = weather!['actual'];
          final temp = actual['temperature'];
          final windSpeed = actual['windSpeed'];
          final humidity = actual['humidity'];
          final rain = actual['rain'];
          final precipRate = actual['precipRate'];
          final city = actual['neighborhood'];

          final suquiText = 'Hola soy Suqui! \n Datos de $city';

          //Historical Data
          final historical = weather!['historical'];
          final dailyPrecipitations = historical['dailyPrecipitations'];
          final totalPrecipitations = historical['totalPrecipitations'];
          final average = historical['average'];
          final standarDeviation = historical['standarDeviation'];
          final spi = historical['spi'];

          //Forecast Data
          final forecast = weather!['forecast'];
          final List<Map<String, dynamic>> threeDayForecast = List<Map<String, dynamic>>.from(forecast);

          Random random = Random();
          int min = 1;
          int max = 3;

          final suquiRandom = random.nextInt(max - min + 1) + min;
          final file = 'assets/gif/$suquiRandom.gif';

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
                            title: 'Fire Risk', 
                            value: fireRisk,
                          ),

                          const SizedBox(height: 15),

                          riskCard(
                            context: context,
                            icon: Icons.flood, 
                            title: 'Flood Risk', 
                            value: floodRisk,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 15,),

                    Expanded(
                      child: Stack(
                        alignment: Alignment.topCenter,
                        clipBehavior: Clip.none,
                        children: [
                          Positioned(
                            top: -40,
                            child: speechBubble(title: suquiText, fontSize: 13),
                          ),

                          Padding(
                            padding: const EdgeInsets.only(top: 50),
                            child: Image.asset(
                              file,
                              scale: 1.9,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ],
                      ),
                    ),
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
                  forecast: forecast,
                )
              ],
            ),
          );
        }
      ),
    );
  }
}