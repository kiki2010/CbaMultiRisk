/*
Fire Predict
last edit: 12/01/2026
Change: Comments were added
*/
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'wudata.dart';

import 'package:geolocator/geolocator.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'dart:typed_data';

//Class responsible for loading the AI ​​model, processing it, and determining whether the risk is high, medium, or low based on the data obtained in wudata.dart
class FirePrediction {
  Interpreter? _interpreter;
  String fireRiskLevel = "";
  
  //We load the fire model (tflite)
  Future<void> loadFireModel() async {
    try {
      _interpreter = await Interpreter.fromAsset('assets/fire_model.tflite');
      print('fire model loaded correctly');
    } catch (e) {
      print('error $e');
    }
  }

  //We use the meteorological data obtained from wudata, process the risk level, and determine whether it is high, medium, or low.
  String _runPrediction(Map<String, dynamic> actualData) {
    double temperature = actualData['temperature'] / 50;
    double humidity = actualData['humidity'];
    double wind = actualData['windSpeed'] / 100;

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
  
  //We get the risk calculated.
  Future<String> predictFire(Map<String, dynamic> allData) async {
    final actual = allData['actual'] as Map<String, dynamic>?;

    if (actual == null) {
      throw Exception('actual=$actual');
    }

    return _runPrediction(actual);
  }
}