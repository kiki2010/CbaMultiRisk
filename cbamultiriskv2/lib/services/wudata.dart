/*
WU data (API Data Handling)
last edit: 12/01/2026
Change: Comments were added
*/

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';
import 'package:intl/intl.dart';
import 'package:statistics/statistics.dart';

const List<String> apiKeys = [
  '026cda1f35b54cddacda1f35b53cdda3',
  'e1f10a1e78da46f5b10a1e78da96f525'
];

String getRandomApiKey() {
  final random = Random();
  return apiKeys[random.nextInt(apiKeys.length)];
} // Shhh... This is a secret

// This service is responsible for obtaining the nearest and most up-to-date weather station data, current readings, the weekly record, and the forecast for the next three days. 
// This data will be displayed on the risk screen and used to calculate the risk of fire and flooding.
class WeatherStationService {
  String? _selectedStationId;
  Map<String, dynamic>? _selectedStationData;
  Map<String, dynamic>? _stationSaved;
  
  // Based on the user Location we get the nearest and most up-to-date weather station 
  Future<Map<String, dynamic>> getNearestStation(Position position) async {
    if (_stationSaved != null) return _stationSaved!;

    final lat = position.latitude;
    final lon = position.longitude;

    final url = 'https://api.weather.com/v3/location/near?geocode=$lat,$lon&product=pws&format=json&apiKey=${getRandomApiKey()}';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode != 200) {
      throw Exception('Error getting API data');
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
        _selectedStationData = stations.first;
        _selectedStationId = stations.first['stationId'];
        print(stations.first);
      }
      else {
        throw Exception("No valid station");
      }
      // _stationSaved = data; //_stationSaved = stations.first; for the nearest station data
    }
    return _selectedStationData!;
  }

  // Obtain the actual weather conditions using the selected station. Then saving it on a map.
  Map<String, dynamic>? _actualDataSaved;
  Future<Map<String, dynamic>> getActualData(Position position) async {
    if (_actualDataSaved != null) return _actualDataSaved!;
    if (_selectedStationId == null) await getNearestStation(position);

    final stationId = _selectedStationId;
    final url = 'https://api.weather.com/v2/pws/observations/current?stationId=$stationId&format=json&units=m&apiKey=${getRandomApiKey()}';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final observation = data['observations'][0];
      final String neighborhood = observation['neighborhood'] ?? 'tu zona';
      final double humidity = observation['humidity']?.toDouble() ?? 0.0;
      final double temp = observation['metric']['temp']?.toDouble() ?? 0.0;
      final double windSpeed = observation['metric']['windSpeed']?.toDouble() ?? 0.0;
      final double precipTotal = observation['metric']['precipTotal']?.toDouble() ?? 0.0;
      final double precipRate = observation['metric']['precipRate']?.toDouble() ?? 0.0;

      return {
        'temperature': temp,
        'windSpeed': windSpeed,
        'humidity': humidity,
        'rain': precipTotal,
        'precipRate': precipRate,
        'neighborhood': neighborhood,
      };

    } else {
      throw Exception('error getting the actual weather data');
    }
  }

  // Obtain the last 7 days conditions using the selected station. Then saving it on a map.
  Map<String, dynamic>? _historicalDataSaved;
  Future<Map<String, dynamic>> getHistoricalData(Position position) async {
    if (_historicalDataSaved != null) return _historicalDataSaved!;
    if (_selectedStationId == null) await getNearestStation(position);

    final stationId = _selectedStationId;
    final url = 'https://api.weather.com/v2/pws/dailysummary/7day?stationId=$stationId&format=json&units=m&apiKey=${getRandomApiKey()}';
    
    final response = await http.get(Uri.parse(url));
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final summaries = data['summaries'];

      if (summaries == null || summaries is! List) {
        throw Exception('Empty summary data');
      }

      double totalPrecipitation = 0;
      int daysWithData = 0;
      List<double> precipitationValues = [];

      Map<DateTime, List<dynamic>> groupedByDay = {};
      
      for (var entry in summaries) {
        if(entry['obsTimeLocal'] != null) {
          String dateStr = entry['obsTimeLocal'].split('T')[0];
          DateTime date = DateFormat('yyyy-MM-dd').parse(dateStr);
          groupedByDay.putIfAbsent(date, () => []).add(entry);
        }
      }

      groupedByDay.forEach((date, entries) {
        List<double> precipTotal = entries
          .where((e) => e['metric']?['precipTotal'] != null)
          .map((e) => (e['metric']['precipTotal'] as num).toDouble())
          .toList();
        
        double dailyPrecipitation =
            precipTotal.isNotEmpty ? precipTotal.reduce((a, b) => a + b) : 0;
        
        totalPrecipitation += dailyPrecipitation;
        if (dailyPrecipitation > 0) daysWithData++;
        precipitationValues.add(dailyPrecipitation);
      });

      double avgPrecipitation = totalPrecipitation / 7;
      double stdDev = precipitationValues.standardDeviation;

      double spi = stdDev > 0
        ? (totalPrecipitation - avgPrecipitation) / stdDev
        : 0;

      _historicalDataSaved = {
        'dailyPrecipitations': precipitationValues,
        'totalPrecipitations': totalPrecipitation,
        'average': avgPrecipitation,
        'standarDeviation': stdDev,
        'spi': spi,
      };

      return _historicalDataSaved!;
    } else {
      throw Exception('error getting historical data');
    }
  }

  // Obtain the forecast using the user location, then saving it on a list -> map.
  List<Map<String, dynamic>> threeDayForecast = [];
  Future<List<Map<String, dynamic>>> getForecast(Position position, BuildContext context) async {
    final lat = position.latitude;
    final lon = position.longitude;

    final locale = Localizations.localeOf(context).languageCode;
    final lang = locale == 'es' ? 'es-ES' : 'en-US';

    final url = "https://api.weather.com/v3/wx/forecast/daily/5day?geocode=$lat,$lon&format=json&units=m&language=$lang&apiKey=${getRandomApiKey()}";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode != 200) {
      throw Exception('error al obtener datos api');
    } 
    else if (response.statusCode == 200) {  
      final data = json.decode(response.body);

      final precipChances = data['daypart'][0]['precipChance'];
      final precipTypes = data['daypart'][0]['precipType']; 
      final daysOfWeek = data['dayOfWeek']; 
      final forecast = data['daypart'][0]['wxPhraseLong'];
      final iconCode = data['daypart'][0]['iconCode'];

      for (int i = 0; i < 3; i++) {
        int icon;
        String resume;
        if (iconCode[i * 2] != null) {
          icon = iconCode[i * 2];
          resume = forecast[i * 2];
        } else if (iconCode[i * 2 + 1] != null) {
          icon = iconCode[i * 2 + 1];
          resume = forecast[i * 2 + 1];
        } else {
          icon = 0;
          resume = "null";
        }

        final dailyForecast = {
          'dayOfWeek': daysOfWeek[i],
          'precipChance': precipChances[i * 2],
          'precipType': precipTypes[i * 2] ?? 'N/A',
          'forecast': resume,
          'iconCode': icon,
        };
        threeDayForecast.add(dailyForecast);
      }
    }
    return threeDayForecast;
  }

  //A Function to return all the data
  Future<Map<String, dynamic>> getAllWeatherData(Position position, BuildContext context) async {
    final station = await getNearestStation(position);
    final actual = await getActualData(position);
    final historical = await getHistoricalData(position);
    final threedayForecast = await getForecast(position, context);
    return {
      'station': station,
      'actual': actual,
      'historical': historical,
      'forecast': threedayForecast,
    };
  }

  //get All weather data for background services
  Future<Map<String, dynamic>> getAllWeatherDataBackground(Position position) async {
    final station = await getNearestStation(position);
    final actual = await getActualData(position);
    final historical = await getHistoricalData(position);
    return {
      'station': station,
      'actual': actual,
      'historical': historical,
    };
  }
}