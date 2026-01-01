import 'package:http/http.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:convert';
import 'dart:math';
import 'package:intl/intl.dart';

const apiKey = '026cda1f35b54cddacda1f35b53cdda3';

class WeatherStationService {
  String? _selectedStationId;
  Map<String, dynamic>? _selectedStationData;
  Map<String, dynamic>? _stationSaved;
}