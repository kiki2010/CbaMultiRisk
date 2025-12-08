import 'package:flutter/foundation.dart';
import 'wudata.dart';

import 'package:geolocator/geolocator.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'dart:typed_data';

class FloodPrediction {
  Interpreter? _interpreter;
  String floodRiskLevel = "";

  Future<void> loadFloodModel() async {
    try {
      _interpreter = Interpreter.fromAddress('assets/flood_model.tflite' as int);
      print('model loaded correctly');
    } catch (e) {
      print('error $e');
    }
  }

  Future<void> predictFlood(Position position) async {
    final weatherService = WeatherStationService();

    final allData = await weatherService.getAllWeatherData(position);
    final actualData = allData['actual'];
    final historicalData = allData['historical'];

    //We create variables for all the data we will use for getting the risk
  }
}