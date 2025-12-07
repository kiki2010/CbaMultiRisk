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
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MultiRisk',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('MultiRisk'),
        ),
        body: const Center(
          child: Text('Test'),
        ),
      ),
    );
  }
}

Future<Position> getUserLocation() async {
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    throw Exception('Is not posible to get location.');
  }

  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      throw Exception('Location permission denied.');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    throw Exception('Location permission denied forever.');
  }

  return await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.high,
  );
}