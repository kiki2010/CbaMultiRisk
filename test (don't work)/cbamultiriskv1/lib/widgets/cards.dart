import 'package:flutter/material.dart';
import 'package:weather_icons/weather_icons.dart';
import 'dart:async';

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
  required BuildContext context,
  required IconData icon,
  required String title,
  required String value,
}) {
  final color = riskColor(value);
  final cardBg = Theme.of(context).cardColor;

  return SizedBox(
    height: 160,
    width: 140,
    child: Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: const BorderRadius.all(Radius.circular(18)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: const Offset(0, 4)
          )
        ]
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 60,),
          const SizedBox(height: 8,),
          Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.bodyMedium?.color)),
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
      return WeatherIcons.day_sunny;
    
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
  final cardBg = Theme.of(context).cardColor;

  return SizedBox(
    height: screenHeigh * 0.30,
    child: Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: const BorderRadius.all(Radius.circular(18)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: const Offset(0, 4)
          )
        ]
      ),

      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Weather Data:", style: TextStyle(fontSize: 14, color: Theme.of(context).textTheme.bodyMedium?.color),),
                Text("Temperature: $temp °C", style: TextStyle(fontSize: 13, color: Theme.of(context).textTheme.bodyMedium?.color)),
                Text("Wind Speed: $wind km/h", style: TextStyle(fontSize: 13, color: Theme.of(context).textTheme.bodyMedium?.color)),
                Text("Humidity: $hum %", style: TextStyle(fontSize: 13, color: Theme.of(context).textTheme.bodyMedium?.color)),
                Text("Rain: $rain mm", style: TextStyle(fontSize: 13, color: Theme.of(context).textTheme.bodyMedium?.color)),
                Text("Rain Rate: $rainRate mm/h", style: TextStyle(fontSize: 13, color: Theme.of(context).textTheme.bodyMedium?.color)),
                Text("Spi: $spi", style: TextStyle(fontSize: 13, color: Theme.of(context).textTheme.bodyMedium?.color))
              ],
            ),
          ),

          const SizedBox(height: 6),
          
          Expanded(child: SingleChildScrollView(
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
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: Theme.of(context).textTheme.bodyMedium?.color
                        ),
                      ),
                      Text(
                        description,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 10, color: Theme.of(context).textTheme.bodyMedium?.color),
                      )
                    ],
                  ),
                );
              }).toList(),
            ),
          ))
        ],
      ),
    ),
  );
}

class TypewriterText extends StatefulWidget {
  final String text;
  final Duration speed;
  final TextStyle? style;
  final TextAlign textAlign;

  const TypewriterText({
    super.key,
    required this.text,
    this.speed = const Duration(milliseconds: 40),
    this.style,
    this.textAlign = TextAlign.center,
  });

  @override
  State<TypewriterText> createState() => _TypewriterTextState();
}

class _TypewriterTextState extends State<TypewriterText> {
  String _displayedText = "";
  int _index = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTyping();
  }

  void _startTyping() {
    _timer = Timer.periodic(widget.speed, (timer) {
      if (_index < widget.text.length) {
        setState(() {
          _displayedText += widget.text[_index];
          _index++;
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _displayedText,
      style: widget.style,
      textAlign: widget.textAlign,
    );
  }
}

class BubbleTailPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width / 2, size.height);
    path.lineTo(size.width, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
} 

Widget speechBubble({
  required String title,
  double fontSize = 13,
}) {
  return SizedBox(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 10,
          ),
          constraints: const BoxConstraints(
            maxWidth: 180,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: Offset(0, 3)
              )
            ]
          ),
          child: TypewriterText(
            key: ValueKey(title),
            text: title,
            speed: const Duration(milliseconds: 35),
            style: TextStyle(
              fontSize: fontSize,
              height: 1.2,
              color: Colors.black87
            ),
          )
        ),

        CustomPaint(
          size: const Size(20, 10),
          painter: BubbleTailPainter(),
        ),
      ],
    ),
  );
}