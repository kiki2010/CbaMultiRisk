import 'package:flutter/material.dart';
import 'package:cbamultiriskv1/screens/suqui.dart';
import 'package:cbamultiriskv1/screens/risk.dart';
import 'package:cbamultiriskv1/screens/settings.dart';
import 'package:cbamultiriskv1/services/firepredict.dart';
import 'package:cbamultiriskv1/services/floodpredict.dart';
import 'package:cbamultiriskv1/services/getlocation.dart';
import 'package:cbamultiriskv1/services/wudata.dart';
import 'package:geolocator/geolocator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Position position = await getUserLocation();

  runApp(MyApp(
    position: position
  ));
}

class MyApp extends StatelessWidget {
  final Position? position;
  final flood = FloodPrediction();
  final fire = FirePrediction();

  MyApp({super.key, required this.position});

  Future<Map<String, dynamic>> loadEverything() async {
    if (position == null) {
      throw Exception('No se pudo obtener la ubicación del usuario.');
    }

    final weatherService = WeatherStationService();
    final flood = FloodPrediction();
    final fire = FirePrediction();

    await flood.loadFloodModel();
    await fire.loadFireModel();

    final weatherData = await weatherService.getAllWeatherData(position!);
    final floodRisk = await flood.predictFlood(position!);
    final fireRisk = await fire.predictFire(position!);

    return {
      'weather' : weatherData,
      'floodRisk' : floodRisk,
      'fireRisk' : fireRisk,
    };
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'MultiRisk',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('MultiRisk'),
        ),

        body: FutureBuilder<Map<String, dynamic>> (
          
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

            //Historical Data
            final historical = weather!['historical'];
            final dailyPrecipitations = historical['dailyPrecipitations'];
            final totalPrecipitations = historical['totalPrecipitations'];
            final average = historical['average'];
            final standarDeviation = historical['standarDeviation'];
            final spi = historical['spi'];

            return Center(
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: 
                        Column(
                          children: [
                            Text("Fire Risk $fireRisk"),
                            SizedBox(height: 8,),
                            Text("Flood Risk $floodRisk"),
                          ],
                        )
                      ),

                      Expanded(
                        flex: 2,
                        child: Text("Esto es Suqui"),
                      ),
                    ],
                  ),

                  SizedBox(height: 16,),

                  Row(
                    children: [
                      Expanded(child:
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Weather Data:",),
                            Text("Temperature: $temp °C"),
                            Text("Wind Speed: $windSpeed km/h"),
                            Text("Humidity: $humidity %"),
                            Text("Rain: $rain mm"),
                            Text("Rain Rate: $precipRate mm/h"),
                            Text("Spi: $spi")
                          ],
                        ),
                      ),

                      SizedBox(width: 12,),

                      Expanded(child: Text("Forecast")),
                    ],
                  ),
                ],
              ),
            );
          }
        )
      ),
    );
  }
}