import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';

const apiKey = '026cda1f35b54cddacda1f35b53cdda3'; //This is a secret lol

class WeatherStationService {
  Map<String, dynamic>? _stationSaved;

  Future<Map<String, dynamic>> getNearestStation(Position position) async {
    if (_stationSaved != null) return _stationSaved!;

    final lat = position.latitude;
    final lon = position.longitude;

    final url = 'https://api.weather.com/v3/location/near?geocode=$lat,$lon&product=pws&format=json&apiKey=$apiKey';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode != 200) {
      throw Exception('error al obtener datos api');
    }
    
    final data = json.decode(response.body) as Map<String, dynamic>;
    _stationSaved = data;
    return data;
  }
}