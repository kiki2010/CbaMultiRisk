import 'package:flutter/material.dart';
import 'package:cbamultiriskv1/screens/nearme.dart';
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

  MyApp({super.key, required this.position});

  Future<Map<String, dynamic>> loadEverything() async {
    if (position == null) {
      throw Exception('No se pudo obtener la ubicación del usuario.');
    }

    final weatherService = WeatherStationService();
    final flood = FloodPrediction();

    await flood.loadFloodModel();

    final weatherData = await weatherService.getAllWeatherData(position!);
    final floodRisk = await flood.predictFlood(position!);

    return {
      'weather' : weatherData,
      'floodRisk' : floodRisk,
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
            final precioRate = actual['precipRate'];

            //Historical Data
            final historical = weather!['historical'];
            final dailyPrecipitations = historical['dailyPrecipitations'];
            final totalPrecipitations = historical['totalPrecipitations'];
            final average = historical['average'];
            final standarDeviation = historical['standarDeviation'];
            final spi = historical['spi'];

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 20,),
                  const Text('Station'),
                  Text('Id $stationid'),
                  Text('UTC: $updateTime'),
                  Text('Distance: $distance'),

                  const SizedBox(height: 20),
                  const Text('Current data'),
                  Text('Temp: $temp °C'),
                  Text('Wind: $windSpeed km/h'),
                  Text('Humidity: $humidity %'),
                  Text('Rain: $rain mm'),
                  Text('PrecipRate: $precioRate mm/h'),

                  const SizedBox(height: 20,),
                  const Text('Historical Data'),
                  Text('Daily Precipitations: $dailyPrecipitations'),
                  Text('Total Precipitations: $totalPrecipitations'),
                  Text('Average: $average'),
                  Text('Standar Deviation: $standarDeviation'),
                  Text('Spi: $spi'),

                  const SizedBox(height: 20,),
                  const Text('Flood Risk'),
                  Text('Risk: $floodRisk'),
                ],
              ),
            );
          }
        )
      ),
    );
  }
}