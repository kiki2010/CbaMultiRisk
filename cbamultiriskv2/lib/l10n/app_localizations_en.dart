// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get risk => 'Risk';

  @override
  String get high => 'HIGH';

  @override
  String get medium => 'MEDIUM';

  @override
  String get low => 'LOW';

  @override
  String get getting => 'Getting Risk...';

  @override
  String get fireRisk => 'Fire Risk';

  @override
  String get floodRisk => 'Flood Risk';

  @override
  String suquiHi(Object city) {
    return 'Hi, I\'m Suqui! \n Data from $city';
  }

  @override
  String get weather => 'Weather Data:';

  @override
  String temperature(Object temp) {
    return 'Temperature: $temp °C';
  }

  @override
  String wind(Object wind) {
    return 'Wind Speed: $wind km/h';
  }

  @override
  String humidity(Object hum) {
    return 'Humidity: $hum %';
  }

  @override
  String rain(Object rain) {
    return 'Rain: $rain mm';
  }

  @override
  String rainRate(Object rainRate) {
    return 'Rain rate: $rainRate mm/h';
  }

  @override
  String spi(Object spi) {
    return 'Spi: $spi';
  }

  @override
  String get noData => 'No data found';

  @override
  String get tips => 'Tips';

  @override
  String get settings => 'Settings';

  @override
  String get settingTitle => 'Settings';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get language => 'Language';

  @override
  String get error => 'Error';
}
