import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';

const apiKey = 'Nya'; //This is a secret lol

class WeatherStationService {

  String? _selectedStationId;
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
    else if (response.statusCode == 200) {  
      final data = json.decode(response.body);

      final stationsIds = data['location']['stationId'];
      final updateTimes = data['location']['updateTimeUtc'];
      final distances = data['location']['distanceKm'];

      final List<Map<String, dynamic>> stations = [];

      //Select the avaiable statations
      for (int i = 0; i < stationsIds.length; i++) {
        if (updateTimes[i] != null) {
          stations.add({
            'stationId': stationsIds[i],
            'updateTime': updateTimes[i],
            'distance': distances[i],
          });
        }
      }

      stations.sort((a, b) {
        int updateComparison = b['updateTime'].compareTo(a['updateTime']);
        if (updateComparison != 0) return updateComparison;
        return a['distance'].compareTo(b['distance']);
      });

      //Save the first station || selected station
      if (stations.isNotEmpty) {
        _selectedStationId = stations.first['stationId'];
      }
      else {
        throw Exception("No valid station");
      }
      _stationSaved = data;
    }
    return _stationSaved!;
  }
}