import 'package:cbamultiriskv1/services/firepredict.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cbamultiriskv1/services/floodpredict.dart';
import 'package:cbamultiriskv1/services/wudata.dart';

class RiskScreen extends StatelessWidget {
  final Position? position;
  final flood = FloodPrediction();
  final fire = FirePrediction();

  RiskScreen({super.key, required this.position});

  Future<Map<String, dynamic>> loadEverything() async {
    if (position == null) {
      throw Exception('Unable to get location');
    }

    final weatherService = WeatherStationService();

    await flood.loadFloodModel();
    await fire.loadFireModel();

    return  {
      'weather' : await weatherService.getAllWeatherData(position!),
      'floodRisk' : await flood.predictFlood(position!),
      'fireRisk' : await fire.predictFire(position!),
    };
  }

  Color riskColor(String level) {
    switch (level.toUpperCase()) {
      case 'LOW':
        return Colors.green;
      case 'MEDIUM':
        return Colors.amber;
      case 'HIGH':
        return Colors.redAccent;
      default:
        return Colors.grey;
    }
  }

  Widget riskCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    final color = riskColor(value);

    return SizedBox(
      height: 160,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 4),
            )
          ]
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 60),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Risk Screen'),),

      body: FutureBuilder<Map<String, dynamic>>(
        future: loadEverything(), 
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No se encontraron datos'));
          }
          
          final weather = snapshot.data!['weather'];
          final floodRisk = snapshot.data!['floodRisk'];
          final fireRisk = snapshot.data!['fireRisk'];

          //station Id data
          final station = weather!['station'];
          final stationid = station['stationId'];
          final updateTime = station['updateTime'];
          final distance = station['distance'];

          //Actual data
          final actual = weather!['actual'];
          final temp = actual['temperature'];
          final windSpeed = actual['windSpeed'];
          final humidity = actual['humidity'];
          final rain = actual['rain'];
          final precipRate = actual['precipRate'];

          //Historical Data
          final historical = weather!['historical'];
          final dailyPrecipitations = historical['dailyPrecipitations'];
          final totalPrecipitations = historical['totalPrecipitations'];
          final average = historical['average'];
          final standarDeviation = historical['standarDeviation'];
          final spi = historical['spi'];

          //Forecast Data
          final forecast = weather!['forecast'];
          final List<Map<String, dynamic>> threeDayForecast = List<Map<String, dynamic>>.from(forecast);

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          riskCard(
                            icon: Icons.local_fire_department, 
                            title: 'Fire Risk', 
                            value: fireRisk,
                          ),

                          const SizedBox(height: 15),

                          riskCard(
                            icon: Icons.flood, 
                            title: 'Flood Risk', 
                            value: floodRisk,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 15,),

                    Expanded(
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/gif/2.gif',
                            fit: BoxFit.fill,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 25,),

                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                        offset: Offset(0, 4)
                      )
                    ]
                  ),
                  child: Row(
                    children: [
                      Expanded(child: 
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Weather Data:",),
                            Text("Temperature: $temp °C"),
                            Text("Wind Speed: $windSpeed km/h"),
                            Text("Humidity: $humidity %"),
                            Text("Rain: $rain mm"),
                            Text("Rain Rate: $precipRate mm/h"),
                            Text("Spi: $spi")
                          ],
                        ),
                      ),

                      const SizedBox(width: 12,),

                      Expanded(child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: threeDayForecast.map((day) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.cloud, color: Colors.grey, size: 50,),
                              const SizedBox(height: 5,),
                              Text(day['dayOfWeek']),
                              //Text(day['precipChance']),
                              //Text(day['precipType']),
                            ],
                          );
                        }).toList(),
                      ))
                    ],
                  ),
                ),
              ],
            ),
          );
        }
      ),
    );
  }
}