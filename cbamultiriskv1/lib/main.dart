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
          
          future: WeatherStationService().getNearestStation(position!), 
          
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('error: ${snapshot.error}'));
            } else if (!snapshot.hasData) {
              return const Center(child: Text('No se encontraron datos'));
            }

            final data = snapshot.data!;
            final stationName = data;

            return Center(
              child: Text('data: $data'),
            );
          }
        )
      ),
    );
  }
}