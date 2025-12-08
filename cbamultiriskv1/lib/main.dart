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

  const MyApp({super.key, required this.position});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'MultiRisk',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('MultiRisk'),
        ),

        body: FutureBuilder<Map<String, dynamic>> (
          
          future: WeatherStationService().getAllWeatherDta(position!), 
          
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('error: ${snapshot.error}'));
            } else if (!snapshot.hasData) {
              return const Center(child: Text('No se encontraron datos'));
            }

            final station = snapshot.data!['station'];
            final actual = snapshot.data!['actual'];
            final historical = snapshot.data!['historical'];

            final stationid = station['stationId'];
            final updateTime = station['updateTime'];
            final distance = station['distance'];

            final temp = actual['temperature'];
            final humidity = actual['humidity'];
            final wind = actual['windSpeed'];
            final rain = actual['rain'];
            final precipRate = actual['precipRate'];

            final totalRain = historical['totalPrecipitations'];
            final avgRain = historical['average'];
            final stdDev = historical['standarDeviation'];
            final spi = historical['spi'];

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  const Text('Station'),
                  Text('Id $stationid'),
                  Text('Humedad: $humidity'),
                  
                  const SizedBox(height: 20,),
                  const Text('Clima Actual'),
                  Text('Temperatura $temp'),
                  Text('Humedad: $humidity'),
                  
                  const SizedBox(height: 20,),
                  const Text('Clima Actual'),
                  Text('Temperatura $temp'),
                  Text('Humedad: $humidity'),
                  
                ],
              ),
            );
          }
        )
      ),
    );
  }
}