import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';
import 'package:intl/intl.dart';

const apiKey = 'this is the api key'; //This is a secret lol

class WeatherStationService {

  String? _selectedStationId;
  Map<String, dynamic>? _selectedStationData;
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
        _selectedStationData = stations.first;
      }
      else {
        throw Exception("No valid station");
      }
      _stationSaved = data; //_stationSaved = stations.first; for the nearest station data
    }
    return _stationSaved!;
  }


  Map<String, dynamic>? _actualDataSaved;

  Future<Map<String, dynamic>> getActualData(Position position) async {
    if (_actualDataSaved != null) return _actualDataSaved!;
    if (_selectedStationId == null) await getNearestStation(position);

    final stationId = _selectedStationId;
    final url = 'https://api.weather.com/v2/pws/observations/current?stationId=$stationId&format=json&units=m&apiKey=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final observation = data['observations'][0];
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
      };

    } else {
      throw Exception('error getting the actual weather data');
    }
  }

  Map<String, dynamic>? _historicalDataSaved;

  Future<Map<String, dynamic>> getHistoricalData(Position position) async {
    if (_historicalDataSaved != null) return _historicalDataSaved!;
    if (_selectedStationId == null) await getNearestStation(position);

    final stationId = _selectedStationId;
    final url = 'https://api.weather.com/v2/pws/dailysummary/7day?stationId=$stationId&format=json&units=m&apiKey=$apiKey';
    
    final response = await http.get(Uri.parse(url));
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final summaries = data['sumaries'];

      if (summaries == null || summaries is! List) {
        throw Exception('Empty summary data');
      }

      double totalPrecipitation = 0;
      List<double> precipitationValues = [];

      Map<DateTime, List<dynamic>> groupedByDay = {};
      
      for (var entry in summaries) {
        if(entry['obsTimeLocal'] != null) {
          String dateStr = entry['obsTimeLocal'].split('')[0];
          DateTime date = DateFormat('yyyy-MM-dd').parse(dateStr);
          groupedByDay.putIfAbsent(date, () => []).add(entry);
        }
      }

      groupedByDay.forEach((date, entries) {
        List<double> dailyValues = entries
          .where((e) => e['metric']?['precipTotal'] != null)
          .map((e) => (e['metric']['precipTotal'] as num).toDouble())
          .toList();
        
        double dailyPrecip = dailyValues.isNotEmpty
          ? dailyValues.reduce((a, b) => a + b)
          : 0.0;
        
        totalPrecipitation += dailyPrecip;
        precipitationValues.add(dailyPrecip);
      });

      int n = precipitationValues.length;
      double avg = n > 0 ? totalPrecipitation / n : 0.0;

      double variance  = 0.0;

      for (var value in precipitationValues) {
        variance += pow(value - avg, 2);
      }

      variance = n > 0 ? variance / n : 0.0;
      double stdDev = sqrt(variance);

      double spi = stdDev > 0 ? (totalPrecipitation - avg * n) / (stdDev * sqrt(n)) : 0.0;

      _historicalDataSaved = {
        'dailyPrecipitations': precipitationValues,
        'totalPrecipitations': totalPrecipitation,
        'average': avg,
        'standarDeviation': stdDev,
        'spi': spi,
      };

      return _historicalDataSaved!;
    } else {
      throw Exception('error getting historical data');
    }
  }
}

