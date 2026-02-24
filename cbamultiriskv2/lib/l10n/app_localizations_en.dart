// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get locationDisclaimerTitle => 'Location access required';

  @override
  String get locationDisclaimer => 'We use your location even when the app is closed to calculate nearby risks and send alerts.';

  @override
  String get locationNotNow => 'Not now';

  @override
  String get locationOk => 'Allow';

  @override
  String get needLocation => 'We need the location access';

  @override
  String get tutorialWelcome1 => 'Welcome to Cba MultiRisk, an app that lets you check the wildfire and flood risk in your area.';

  @override
  String get tutorialWelcome2 => 'Now we will walk through the app screens so you don’t miss any details.';

  @override
  String get tutorialWelcome3 => 'Remember that you can replay this tutorial anytime from the settings screen.';

  @override
  String get tutorialWelcome4 => 'You are about to enter the main screen. There you will see the wildfire and flood risk levels, and you can also learn how they are calculated by tapping each indicator.';

  @override
  String get tutorialWelcome5 => 'This screen also shows where we obtain the weather data and the forecast for the next three days.';

  @override
  String get tutorialWelcome6 => 'When you\'re ready, I’ll see you on the Tips screen.';

  @override
  String get tutorialSuqui1 => 'This is my screen!';

  @override
  String get tutorialSuqui2 => 'Here I will show you tips so you know how to prepare and how to act in case of a wildfire or a flood. I will also share some advice to help us take care of the world together.';

  @override
  String get tutorialSuqui3 => 'And whenever you want to test your knowledge, we can play a game and see how many questions you can answer in 60 seconds.';

  @override
  String get tutorialSuqui4 => 'To finish the tutorial, I’ll see you on the Settings screen.';

  @override
  String get tutorialSetting1 => 'This is the Settings screen!';

  @override
  String get tutorialSetting2 => 'Here you can change key aspects of the app, such as the language, theme, and notifications.';

  @override
  String get tutorialSetting3 => 'You can also review the disclaimer again and reset the application.';

  @override
  String get tutorialSetting4 => 'It is important to configure the emergency buttons so you can access them at any time.';

  @override
  String get tutorialLast1 => 'You have explored the entire app.';

  @override
  String get tutorialLast2 => 'As a final recommendation, we suggest going to your device settings, enabling notifications, and allowing background location access.';

  @override
  String get tutorialLast3 => 'We will not store this information!';

  @override
  String get tutorialLast4 => 'Remember to follow us on Instagram @cbaMultiRisk.';

  @override
  String get tutorialLast5 => 'And please leave us a positive review on the Play Store!';

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
  String gameTitle(Object highScore, Object lastScore) {
    return 'Answer all the questions you can in 60 seconds. \n | Your highest score is: $highScore | \n | Your last score is: $lastScore | ';
  }

  @override
  String get play => ' Play ';

  @override
  String score(Object score) {
    return ' Score: $score';
  }

  @override
  String get trueAnswer => ' True ';

  @override
  String get falseAnswer => ' False ';

  @override
  String get settings => 'Settings';

  @override
  String get settingTitle => 'Settings';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get language => 'Language';

  @override
  String get notifications => 'Notifications';

  @override
  String phoneSetUp(Object title) {
    return 'Settings: $title';
  }

  @override
  String get firefighters => 'Firefighters';

  @override
  String get emergency => 'Emergency';

  @override
  String get ambulance => 'Ambulance';

  @override
  String get resetAll => 'Reset app';

  @override
  String get resetWarning => 'The app will be reset';

  @override
  String get reset => 'The app\'s saved preferences will be deleted.';

  @override
  String get feedback => 'Feedback form';

  @override
  String error(Object error) {
    return 'Error $error';
  }

  @override
  String get locationError => 'Location Error';

  @override
  String get lastKnowRisk => 'We were unable to obtain current data. \n The last recorded risk was:';

  @override
  String get close => 'Close';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';
}
