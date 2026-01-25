/*
Flood Predict
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
class FloodPrediction {
  Interpreter? _interpreter;
  String floodRiskLevel = "";
  
  //Load the flood model (tfLite)
  Future<void> loadFloodModel() async {
    try {
      _interpreter = await Interpreter.fromAsset('assets/flood_model.tflite');
      print('model loaded correctly');
    } catch (e) {
      print('error $e');
    }
  }
  
  //We use the meteorological data obtained from wudata, process the risk level, and determine whether it is high, medium, or low.
  Future<String> predictFlood(Position position, BuildContext context) async {
    final weatherService = WeatherStationService();

    final allData = await weatherService.getAllWeatherData(position, context);
    final actualData = allData['actual'];
    final historicalData = allData['historical'];

    //We create variables for all the data we will use for getting the risk
    double spi = historicalData['spi'] ?? 0.0;
    double precipTotal = actualData['rain'] ?? 0.0;
    double precipRate = actualData['precipRate'] ?? 0.0;
    double humidity = (actualData['humidity'] ?? 0.0) / 100;

    List<double> floodInputData = [spi, precipTotal, precipRate, humidity];

    final floodInput = [Float32List.fromList(floodInputData)];
    final floodOutput = List.generate(1, (_) => List.filled(3, 0.0));

    _interpreter?.run(floodInput, floodOutput);

    final prediction = floodOutput[0];
    final maxValue = prediction.reduce((a, b) => a > b ? a : b);
    final FloodPredictedClass = prediction.indexOf(maxValue);

    switch (FloodPredictedClass) {
      case 0:
        return "LOW";
      case 1:
        return 'MEDIUM';
      case 2:
        return 'HIGH';
      default:
        return 'Unknown';
    } 
  }
}