/*
General Cards
last edit: 20/01/2026
Change: Added handle for emergency buttons
*/

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:weather_icons/weather_icons.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:cbamultiriskv2/l10n/app_localizations.dart';

//Risk info! (colors + localized text)
(Color, String) riskInfo(BuildContext context, String level) {
  switch (level.toUpperCase()) {
    case 'LOW':
      return (Colors.green, AppLocalizations.of(context)!.low);
    case 'MEDIUM':
      return (Colors.amber, AppLocalizations.of(context)!.medium);
    case 'HIGH':
      return(Colors.red, AppLocalizations.of(context)!.high);
    default:
      return (Colors.grey, AppLocalizations.of(context)!.getting);
  }
}

//Risk Cards (Used for flood and fire risk on the risk Screen)
Widget riskCard({
  required BuildContext context,
  required IconData icon,
  required String title,
  required String value,
  VoidCallback? onTap,
}) {
  final (color, text) = riskInfo(context, value);
  final cardBg = Theme.of(context).cardColor;

  return GestureDetector(
    onTap: onTap,
    child: SizedBox(
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
            Text(title,maxLines: 2,overflow: TextOverflow.ellipsis, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.bodyMedium?.color)),
            const SizedBox(height: 4),
            Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
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
    case 'thunderstorm':
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

//Widget Card! Used for showing all the data get from the weather station and forecast icons
Widget weatherCard( BuildContext context,{
  required double temp,
  required double wind,
  required double hum,
  required double rain,
  required double rainRate,
  required String spi,
  required List<Map<String, dynamic>> forecast, 
}) {
  // final screenHeigh = MediaQuery.of(context).size.height;
  final cardBg = Theme.of(context).cardColor;

  return Expanded(
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
              //All the data :D
              children: [
                AutoSizeText(AppLocalizations.of(context)!.weather, maxLines: 1, style: TextStyle(fontSize: 14, color: Theme.of(context).textTheme.bodyMedium?.color),),
                AutoSizeText(AppLocalizations.of(context)!.temperature(temp),  maxLines: 1, style: TextStyle(fontSize: 13, color: Theme.of(context).textTheme.bodyMedium?.color)),
                AutoSizeText(AppLocalizations.of(context)!.wind(wind),  maxLines: 2, style: TextStyle(fontSize: 13, color: Theme.of(context).textTheme.bodyMedium?.color)),
                AutoSizeText(AppLocalizations.of(context)!.humidity(hum),  maxLines: 1, style: TextStyle(fontSize: 13, color: Theme.of(context).textTheme.bodyMedium?.color)),
                AutoSizeText(AppLocalizations.of(context)!.rain(rain),  maxLines: 1, style: TextStyle(fontSize: 13, color: Theme.of(context).textTheme.bodyMedium?.color)),
                AutoSizeText(AppLocalizations.of(context)!.rainRate(rainRate),  maxLines: 2, style: TextStyle(fontSize: 13, color: Theme.of(context).textTheme.bodyMedium?.color)),
                AutoSizeText(AppLocalizations.of(context)!.spi(spi), maxLines: 1, style: TextStyle(fontSize: 13, color: Theme.of(context).textTheme.bodyMedium?.color))
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

//Info Dialogs (for showing how the risk is calculated)
Widget infoDialog(BuildContext context, {
  required String title,
  required String content,
  required Widget? icon,
}) {
  return Dialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            icon,
            const SizedBox(height: 10)
          ],
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold
            ),
            textAlign: TextAlign.left,
          ),
          
          const SizedBox(height: 10),

          Text(
            content,
            textAlign: TextAlign.left,
            style: const TextStyle(fontSize: 14), 
          ),

          const SizedBox(height: 20),

          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(AppLocalizations.of(context)!.close),
          )
        ],
      ),
    ),
  );
}

void showInfoDialog(BuildContext context, String title, String content, Widget icon) {
  showDialog(
    context: context,
    builder: (_) => infoDialog(context, title: title, content: content, icon: icon),
  );
}

//Disclaimer dialog
void showDisclaimerDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => AlertDialog(
      title: Text(AppLocalizations.of(context)!.disclaimer),
      content: SingleChildScrollView(
        child: Text(
          AppLocalizations.of(context)!.disclaimerText,
          style: TextStyle(fontSize: 14),
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(AppLocalizations.of(context)!.understand),
        ),
      ],
    ),
  );
}

//logic for the disclaimer to only appear when it was not accepted.
Future<bool> shouldShowDisclaimer() async {
  final prefs = await SharedPreferences.getInstance();
  return !(prefs.getBool('disclaimer_seen') ?? false);
}

Future<void> setDisclaimerSeen() async {
  final prefs =  await SharedPreferences.getInstance();
  await prefs.setBool('disclaimer_seen', true);
}

//Close Button for the game

class CloseButtonWidget extends StatelessWidget {
  const CloseButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 12,
      left: 12,
      child: SafeArea(
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            Navigator.pop(context);
          },

          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.arrow_back,
              size: 40,
            ),
          ),
        ),
      ),
    );
  }
}

//Buttons for calls
Future<void> handleEmergencyButton(
  BuildContext context,
  String prefKey,
  String title,
) async {
  final prefs = await SharedPreferences.getInstance();
  final phone = prefs.getString(prefKey);

  if (phone == null || phone.isEmpty) {
    _showAddPhoneDialog(context, prefKey, title);
  } else {
    final uri = Uri.parse('tel:$phone');
    await launchUrl(uri);
  }
}

void _showAddPhoneDialog(
  BuildContext context,
  String prefKey,
  String title,
) {
  final controller = TextEditingController();

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(AppLocalizations.of(context)!.phoneSetUp(title)),
      content: TextField(
        controller: controller,
        keyboardType: TextInputType.phone,
        decoration: const InputDecoration(
          hintText: "911, 1O1, +54 9..."
        ),
      ),

      actions: [
        TextButton(
          child: Text(AppLocalizations.of(context)!.cancel),
          onPressed: () => Navigator.pop(context),
        ),
        ElevatedButton(
          child: Text(AppLocalizations.of(context)!.save),
          onPressed: () async {
            final prefs = await SharedPreferences.getInstance();
            await prefs.setString(prefKey, controller.text);
            Navigator.pop(context);
          },
        )
      ],
    ),
  );
}

//Reset dialog
void showResetDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(AppLocalizations.of(context)!.resetWarning),
      content: Text(AppLocalizations.of(context)!.reset),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(AppLocalizations.of(context)!.cancel),
        ),
        ElevatedButton(
          onPressed: () async {
            await resetApp();
            Navigator.pop(context);
          },
          child: Text(AppLocalizations.of(context)!.resetAll),
        )
      ],
    ),
  );
}

Future<void> resetApp() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.clear();
}