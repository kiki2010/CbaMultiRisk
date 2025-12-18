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
    final flood = FloodPrediction();
    final fire = FirePrediction();

    await flood.loadFloodModel();
    await fire.loadFireModel();

    final weatherData = await weatherService.getAllWeatherData(position!);
    final floodRisk = await flood.predictFlood(position!); 
    final fireRisk = await fire.predictFire(position!);

    return  {
      'weather' : weatherData,
      'floodRisk' : floodRisk,
      'fireRisk' : fireRisk,
    };
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
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.local_fire_department, color: Colors.amber, size: 65,),
                                    SizedBox(width: 8,),
                                    Text("Fire Risk: "),
                                    Text("$fireRisk")
                                  ],
                                )
                              ],
                            ),
                          ),

                          const SizedBox(height: 15),

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
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.flood, color: Colors.amber, size: 65,),
                                    SizedBox(width: 8,),
                                    Text("Flood Risk:"),
                                    Text("$floodRisk")
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),

                    const SizedBox(width: 15,),

                    Expanded(
                      child: Column(
                        children: [
                          Text("Este es Suqui lol")
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