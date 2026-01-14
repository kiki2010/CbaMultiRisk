// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get disclaimer => 'Disclaimer';

  @override
  String get disclaimerText => 'This app is designed to predict the likelihood of wild fires and floods using external weather sources.\n For actual evacuation and safety measures, always follow the instructions of local authorities.\n The developers assume no responsibility for any damage or loss resulting from the use of this app.';

  @override
  String get understand => 'I Understand';

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
  String get fireTitleExplanation => 'How the fire risk is calculated';

  @override
  String get fireExplanation => 'We developed an Artificial Intelligence model to estimate fire risk.\n This model analyzes environmental variables such as temperature, relative humidity, and wind speed to evaluate conditions that may favor the spread of fire.\n The data is obtained from the nearest and most up-to-date meteorological station.\n Based on this analysis, the risk is classified as Low, Medium, or High and is represented with colors to make it easier to understand.';

  @override
  String get floodTitleExplanation => 'How we calculate flood risk';

  @override
  String get floodExplanation => 'The app analyzes rainfall and humidity conditions to help you understand the flood risk in your area.\n Factors such as the amount and intensity of rainfall, soil moisture, and the Standardized Precipitation Index (SPI) are taken into account, using data from the nearest and most up-to-date meteorological station.\n With this information, we estimate the probability of flooding and classify the risk as Low, Medium, or High, accompanied by colors for quick and clear reading.';

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
  String get notification => 'Notifications';

  @override
  String get error => 'Error';

  @override
  String get close => 'Close';
}
