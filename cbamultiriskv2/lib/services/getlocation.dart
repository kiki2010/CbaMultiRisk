/*
Location Services
last edit: 12/01/2026
Change: Comments were added
*/

import 'package:geolocator/geolocator.dart';

//Function that returns the user's location
//Step by step: 1. Check if the location service is enabled | If enabled, get and return the user's location.
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