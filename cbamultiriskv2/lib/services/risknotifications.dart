/*
Notification Services
last edit: 09/01/2026
Change: Notifications are sent when the risk is high 
*/

import 'package:flutter/material.dart';
import 'package:workmanager/workmanager.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

//services
import 'getlocation.dart';
import 'wudata.dart';
import 'floodpredict.dart';
import 'firepredict.dart';

//Plugin and channel
final FlutterLocalNotificationsPlugin _notifications =
  FlutterLocalNotificationsPlugin();

const AndroidNotificationChannel _riskChannel =
  AndroidNotificationChannel(
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

  final androidplugin = _notifications.resolvePlatformSpecificImplementation<
    AndroidFlutterLocalNotificationsPlugin>();
  
  await androidplugin?.createNotificationChannel(_riskChannel);
}

//Loas Everything
final flood = FloodPrediction();
final fire = FirePrediction();

class RiskService {
  Future<Map<String, dynamic>> loadEverything() async {
    final Position position = await getUserLocation();

    final weatherService = WeatherStationService();

    await flood.loadFloodModel();
    await fire.loadFireModel();

    return {
      'weather': await weatherService.getAllWeatherData(position),
      'floodRisk': await flood.predictFlood(position),
      'fireRisk': await fire.predictFire(position),
    };
  }
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

  final bool highFlood = isHighRisk(floodRisk);
  final bool highFire = isHighRisk(fireRisk);

  if (highFlood || highFire) {
    await showRiskNotification(
      floodRisk: floodRisk, 
      fireRisk: fireRisk
    );
  }
}

//Show the notification
Future<void> showRiskNotification({
  required String floodRisk,
  required String fireRisk,
}) async {
  
  const AndroidNotificationDetails androidDetails = AndroidNotificationDetails('risk_channel', 'Risk', importance: Importance.high, priority: Priority.high, icon: 'ic_stat_multirisk');
  
  const NotificationDetails details = NotificationDetails(android: androidDetails);

  await _notifications.show(0, 'Risk on the area', 'Fire: $fireRisk | Flood: $floodRisk', details);
}

//Background task Handler
@pragma('vm:entry-point')
void riskCallbackDispatcher() {

  Workmanager().executeTask((task, inputData) async {
    debugPrint('⚙️ Background task ejecutada: $task');
    
    if (task == 'calculate_risk') {
      final prefs = await SharedPreferences.getInstance();
      final enabled = prefs.getBool('risk_notifications_enabled') ?? true;

      if (!enabled) {
        return Future.value(true);
      }

      await initRiskNotifications();

      final riskService = RiskService();
      final data = await riskService.loadEverything();

      final floodRisk = data['floodRisk'];
      final fireRisk = data['fireRisk'];

      if (isHighRisk(floodRisk) || isHighRisk(fireRisk)) {
        await showRiskNotification(floodRisk: floodRisk, fireRisk: fireRisk);
      }
    }
    return Future.value(true);
  });
}

//Notificactions settings
class NotificationSettings {
  static const _key = 'risk_notifications_enabled';

  static Future<bool> isEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_key) ?? true;
  }

  static Future<void> setEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, value);
  }
}

//Enabled and sidabled
class RiskTaskManager {
  static const taskName = 'calculate_risk';
  static const uniqueName = 'risk_periodic_task';

  static Future<void> enabled() async {
    await Workmanager().registerPeriodicTask(
      uniqueName,
      taskName,
      frequency: Duration(minutes: 20),
      existingWorkPolicy: ExistingPeriodicWorkPolicy.replace,
    );
  }

  static Future<void> disable() async {
    await Workmanager().cancelByUniqueName(uniqueName);
  }
}