import 'package:cbamultiriskv1/services/firepredict.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cbamultiriskv1/services/floodpredict.dart';
import 'package:cbamultiriskv1/services/wudata.dart';
import 'dart:math';
import 'dart:async';

import 'package:cbamultiriskv1/widgets/cards.dart';

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

class _BubbleTailPainter extends CustomPainter {
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

  Widget speechBubble({
    required String title,
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
              text: title,
              speed: const Duration(milliseconds: 35),
              style: const TextStyle(
                fontSize: 13,
                height: 1.2,
              ),
            )
          ),

          CustomPaint(
            size: const Size(20, 10),
            painter: _BubbleTailPainter(),
          ),
        ],
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
          final city = actual['neighborhood'];

          final suquiText = 'Hola soy Suqui! \n Datos de $city';

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

          Random random = Random();
          int min = 1;
          int max = 3;

          final suquiRandom = random.nextInt(max - min + 1) + min;
          final file = 'assets/gif/$suquiRandom.gif';

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
                      child: Stack(
                        alignment: Alignment.topCenter,
                        clipBehavior: Clip.none,
                        children: [
                          Positioned(
                            top: -40,
                            child: speechBubble(title: suquiText),
                          ),

                          Padding(
                            padding: const EdgeInsets.only(top: 50),
                            child: Image.asset(
                              file,
                              scale: 1.9,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 15),

                weatherCard(
                  context,
                  temp: temp,
                  wind: windSpeed,
                  hum: humidity,
                  rain: rain,
                  rainRate: precipRate,
                  spi: spi,
                  forecast: forecast,
                )
              ],
            ),
          );
        }
      ),
    );
  }
}