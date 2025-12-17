import 'package:flutter/foundation.dart';
import 'wudata.dart';

import 'package:geolocator/geolocator.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'dart:typed_data';

class FirePrediction {
  Interpreter? _interpreter;
  String fireRiskLevel = "";

  Future<void> loadFireModel() async {
    try {
      _interpreter = await Interpreter.fromAsset('assets/fire_model.tflite');
      print('fire model loaded correctly');
    } catch (e) {
      print('error $e');
    }
  }

  Future<String> predictFire(Position position) async {
    final weatherService = WeatherStationService();

    final allData = await weatherService.getAllWeatherData(position);
    final actualData = allData['actual'];
    
    double temperature = actualData['temperature'];
    double humidity = actualData['humidity'];
    double wind = actualData['windSpeed'];

    List<double> fireInputData = [temperature, humidity, wind];

    var fireInput = [Float32List.fromList(fireInputData)];
    var fireOutput = List.filled(3, 0.0).reshape([1, 3]);

    _interpreter?.run(fireInput, fireOutput);

    int firePredictedClass = fireOutput[0].indexWhere((element) {
      double maxValue = (fireOutput[0] as List<dynamic>).reduce(
        (a, b) => (a as double) > (b as double) ? a : b,
      );
      return element == maxValue;
    });

    switch (firePredictedClass) {
      case 0:
        return 'LOW';
      case 1:
        return 'MEDIUM';
      case 2:
        return 'HIGH';
      default:
        return 'Unknown';
    }
  }
}