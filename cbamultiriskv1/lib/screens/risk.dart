import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cbamultiriskv1/services/floodpredict.dart';
import 'package:cbamultiriskv1/services/getlocation.dart';
import 'package:cbamultiriskv1/services/wudata.dart';

class RiskScreen extends StatelessWidget {
  final flood = FloodPrediction();

  Future<String> initRisk() async {
    await flood.loadFloodModel();
    Position position = await getUserLocation();
    WeatherStationService().getAllWeatherData(position!);
    return await flood.predictFlood(position);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return FutureBuilder(
      future: initRisk(), 
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          appBar: AppBar(title: const Text('Data obtained')),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                const Text('Station'),

              ],
            ),
          ),
        );
      }
    );
  }
}