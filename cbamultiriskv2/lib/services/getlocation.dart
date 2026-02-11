/*
Location Services
last edit: 11/02/2026
Change: Location is Saved
*/

import 'package:geolocator/geolocator.dart';

import 'package:shared_preferences/shared_preferences.dart';

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

//Save if location is saved
const _locationDisclosureKey = 'location_disclosure_seen';

Future<void> setLocationDisclosureAccepted() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool(_locationDisclosureKey, true);
}
