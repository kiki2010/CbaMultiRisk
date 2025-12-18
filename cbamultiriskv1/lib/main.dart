import 'package:cbamultiriskv1/main_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:cbamultiriskv1/services/getlocation.dart';
import 'package:geolocator/geolocator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Position position = await getUserLocation();

  runApp(MyApp(position: position));
}

class MyApp extends StatelessWidget {
  final Position? position;
  const MyApp({super.key, required this.position});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MultiRisk',
      debugShowCheckedModeBanner: false,
      home: MainScaffold(position: position!),
    );
  }
}