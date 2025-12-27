import 'package:flutter/material.dart';
import 'package:weather_icons/weather_icons.dart';

//general styles
const cardDecoration = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.all(Radius.circular(18)),
  boxShadow: [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 8,
      offset: Offset(0, 4),
    ),
  ]
);

//Card and style for Risk
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
    width: 140,
    child: Container(
      padding: const EdgeInsets.all(15),
      decoration: cardDecoration,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 60,),
          const SizedBox(height: 8,),
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

//Weather Data and Forecast Style and Card
IconData getForecastIcon(String? forecast) {
  if (forecast == null || forecast.isEmpty) {
    return WeatherIcons.na;
  }

  switch (forecast.toLowerCase()) {
    case 'sunny':
    case 'hot':
    case 'mostly sunny':
    case 'clear':
    case 'mostly clear':
      return WeatherIcons.cloud;
    
    case 'cloudy':
      return WeatherIcons.cloud;

    case 'mostly cloudy':
    case 'partly cloudy':
      return WeatherIcons.day_cloudy;

    case 'strong storms':
    case 'thunderstorms':
    case 'pm thunderstorms':
    case 'am thunderstorm':
    case 'isolated thunderstorms':
    case 'scattered thunderstorms':
      return WeatherIcons.thunderstorm;

    case 'rain':
    case 'drizzle':
    case 'showers':
    case 'am showers':
    case 'pm showers':
    case 'scattered showers':
    case 'heavy rain':
      return WeatherIcons.rain;

    case 'snow':
    case 'snow showers':
    case 'heavy snow':
    case 'blizzard':
      return WeatherIcons.day_snow;

    default:
      return WeatherIcons.na;
  }
}

Widget weatherCard( BuildContext context,{
  required double temp,
  required double wind,
  required double hum,
  required double rain,
  required double rainRate,
  required double spi,
  required List<Map<String, dynamic>> forecast, 
}) {
  final screenHeigh = MediaQuery.of(context).size.height;

  return SizedBox(
    height: screenHeigh * 0.50,
    child: Container(
      padding: const EdgeInsets.all(15),
      decoration: cardDecoration,

      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Weather Data:", style: TextStyle(fontSize: 14),),
                Text("Temperature: $temp °C", style: TextStyle(fontSize: 13)),
                Text("Wind Speed: $wind km/h", style: TextStyle(fontSize: 13)),
                Text("Humidity: $hum %", style: TextStyle(fontSize: 13)),
                Text("Rain: $rain mm", style: TextStyle(fontSize: 13)),
                Text("Rain Rate: $rainRate mm/h", style: TextStyle(fontSize: 13)),
                Text("Spi: $spi", style: TextStyle(fontSize: 13))
              ],
            ),
          ),

          const SizedBox(height: 6),
          
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: forecast.map((day) {
                final String dayName = day['dayOfWeek'];
                final String description = day['forecast'] as String? ?? 'Unknown';

                return Padding(
                  padding: const EdgeInsetsGeometry.symmetric(vertical: 3),
                  child: Column(
                    children: [
                      Icon(
                        getForecastIcon(description),
                        size: 42,
                      ),

                      const SizedBox(height: 2),

                      Text(
                        dayName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        description,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 10),
                      )
                    ],
                  ),
                );
              }).toList(),
            ),
          )
        ],
      ),
    ),
  );
}