/*
Risk Notifications Settings and Background services
last edit: 14/01/2026
Change: Now is avaible in english and spanish
*/

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
//services
import 'getlocation.dart';
import 'wudata.dart';
import 'floodpredict.dart';
import 'firepredict.dart';

//Plugin and channel
final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();

const AndroidNotificationChannel _riskChannel = AndroidNotificationChannel(
  'risk_channel',
  'Risk',
  description: 'Actual Risk Level',
  importance: Importance.high,
);

// Init notifications
Future<void> initRiskNotifications() async {
  const AndroidInitializationSettings androidInitializationSettings = AndroidInitializationSettings('ic_stat_multirisk');

  const InitializationSettings settings = InitializationSettings(android: androidInitializationSettings);

  await _notifications.initialize(settings);

  final AndroidPlugin = _notifications.resolvePlatformSpecificImplementation<
    AndroidFlutterLocalNotificationsPlugin>();
  
  await AndroidPlugin?.createNotificationChannel(_riskChannel);
}

//Load Everything
final flood = FloodPrediction();
final fire = FirePrediction();

//Save last risk known
Future<void> saveLastRisk(String fireRisk, String floodRisk) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('last_fire_risk', fireRisk);
  await prefs.setString('last_flood_risk', floodRisk);
}

//Load last risk
Future<Map<String, String>> loadLastRisk() async {
  final prefs = await SharedPreferences.getInstance();
  return {
    'fireRisk': prefs.getString('last_fire_risk') ?? 'LOW',
    'floodRisk': prefs.getString('last_flood_risk') ?? 'LOW',
  };
}

//Adaptative Frecuence
int resolveFrecuencyMinutes(String fireRisk, String floodRisk) {
  final isHigh = (String r) => r.toUpperCase() == 'HIGH';
  final isMedium = (String r) => r.toUpperCase() == 'MEDIUM';

  if (isHigh(fireRisk) || isHigh(floodRisk)) return 240;
  if (isMedium(fireRisk) || isMedium(floodRisk)) return 360;
  return 480;
}

//Risk Service
class RiskService {
  Future<Map<String, dynamic>> loadEverything() async {
    final Position position = await getUserLocation();

    await flood.loadFloodModel();
    await fire.loadFireModel();

    final weatherService = WeatherStationService();
    final weatherData = await weatherService.getAllWeatherDataBackground(position);

    final actual = weatherData['actual'] as Map<String, dynamic>?;
    final historical = weatherData['historical'] as Map<String, dynamic>?;

    if (actual == null || historical == null) {
      throw Exception('Incomplete weather data');
    }

    final floodRisk = await flood.predictFlood(weatherData);
    final fireRisk = await fire.predictFire(weatherData);

    debugPrint('Risk: $fireRisk || $floodRisk');

    return {
      'weather': weatherData,
      'floodRisk': floodRisk,
      'fireRisk': fireRisk,
    };
  }
}

//load the selected language
Future<String> loadSavedLocale() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('locale') ?? 'es';
}

//Is HIGH?
bool isHighRisk(String risk) {
  return risk.toLowerCase() == 'high';
}

//Call load everything and show notification
final riskService = RiskService();

Future<void> calculateRiskAndNotify() async {
  await initRiskNotifications();

  final data = await riskService.loadEverything();

  final String floodRisk = data['floodRisk'];
  final String fireRisk = data['fireRisk'];

  await saveLastRisk(fireRisk, floodRisk);

  final bool highFlood = isHighRisk(floodRisk);
  final bool highFire = isHighRisk(fireRisk);

  if (highFlood || highFire) {
    await showRiskNotification(
      floodRisk: floodRisk, 
      fireRisk: fireRisk
    );
  }

  debugPrint('Risk: $fireRisk | $floodRisk');
}

//Locate strings for Notifications
class RiskNotificationsStrings {
  final String lang;

  RiskNotificationsStrings(this.lang);

  static const _strings = {
    'es': {
      'title': "Riesgo en tu zona",
      'fire': "Incendio:",
      'flood': "Inundación:"
    },
    'en': {
      'title': "Risk on the area",
      'fire': "Fire:",
      'flood': "Flood:"
    }
  };

  String get title =>
    _strings[lang]?['title'] ?? _strings['en']!['title']!;

  String get fire =>
    _strings[lang]?['fire'] ?? _strings['en']!['fire']!;
  
  String get flood =>
    _strings[lang]?['flood'] ?? _strings['en']!['flood']!;
}

String localizeRiskLevel({
  required String level,
  required String lang,
}) {
  switch (level.toUpperCase()) {
    case 'HIGH':
      return lang == 'es' ? 'Alto' : 'High';
    case 'MEDIUM':
      return lang == 'es' ? 'Medio' : 'Medium';
    case 'LOW':
      return lang == 'es' ? 'Bajo' : 'Low';
    default:
      return level;
  }
}


//Show the notification
Future<void> showRiskNotification({
  required String floodRisk,
  required String fireRisk,
}) async {
  final lang = await loadSavedLocale();
  final t = RiskNotificationsStrings(lang);

  final fireText = localizeRiskLevel(level: fireRisk, lang: lang);
  final floodText = localizeRiskLevel(level: floodRisk, lang: lang);

  const AndroidNotificationDetails androidDetails = AndroidNotificationDetails('risk_channel', 'Risk', importance: Importance.high, priority: Priority.high, icon: 'ic_stat_multirisk');
  
  const NotificationDetails details = NotificationDetails(android: androidDetails);

  await _notifications.show(0, t.title, '${t.fire} $fireText | ${t.flood} $floodText', details);
}

//Background task Handler
@pragma('vm:entry-point')
void riskCallbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    if (task == 'calculate_risk') {
      final riskService = RiskService();
      final data = await riskService.loadEverything();

      final floodRisk = data['floodRisk'];
      final fireRisk = data['fireRisk'];

      debugPrint('Risk: $fireRisk | $floodRisk');
      
      await showRiskNotification(floodRisk: floodRisk, fireRisk: fireRisk);
      if (isHighRisk(floodRisk) || isHighRisk(fireRisk)) {
        await showRiskNotification(floodRisk: floodRisk, fireRisk: fireRisk);
      }
    }
    return Future.value(true);
  });
}

//Settings Provider
class BackgroundTaskProvider extends ChangeNotifier {
  static const _prefKey = 'bg_rask_enabled';

  bool isBackgroundTaskEnabled = true;

  BackgroundTaskProvider() {
    _loadState();
  }

  Future<void> _loadState() async {
    final prefs = await SharedPreferences.getInstance();
    isBackgroundTaskEnabled = prefs.getBool(_prefKey) ?? true;
    notifyListeners();
  }

  //Setting of the bg task
  Future<void>  scheduleAdaptativeTask() async {
    if (!isBackgroundTaskEnabled) return;

    final lastRisk = await loadLastRisk();
    final fireRisk = lastRisk['fireRisk']  ?? 'LOW';
    final floodRisk = lastRisk['floodRisk']  ?? 'LOW';
    final minutes = resolveFrecuencyMinutes(fireRisk, floodRisk);

    debugPrint('Task $minutes');

    await Workmanager().registerPeriodicTask(
      'risk_notification', 
      'calculate_risk',
      frequency: Duration(minutes: minutes),
      existingWorkPolicy: ExistingPeriodicWorkPolicy.replace,
    );
  }

  Future<void> toggleBackgroundTask(bool enabled) async {
    isBackgroundTaskEnabled = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefKey, enabled);
    notifyListeners();

    if (enabled) {
      scheduleAdaptativeTask();
    } else {
      await Workmanager().cancelByUniqueName('risk_notification');
    }
  }
}