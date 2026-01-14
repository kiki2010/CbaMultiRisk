import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es')
  ];

  /// No description provided for @disclaimer.
  ///
  /// In en, this message translates to:
  /// **'Disclaimer'**
  String get disclaimer;

  /// No description provided for @disclaimerText.
  ///
  /// In en, this message translates to:
  /// **'This app is designed to predict the likelihood of wild fires and floods using external weather sources.\n For actual evacuation and safety measures, always follow the instructions of local authorities.\n The developers assume no responsibility for any damage or loss resulting from the use of this app.'**
  String get disclaimerText;

  /// No description provided for @understand.
  ///
  /// In en, this message translates to:
  /// **'I Understand'**
  String get understand;

  /// No description provided for @risk.
  ///
  /// In en, this message translates to:
  /// **'Risk'**
  String get risk;

  /// No description provided for @high.
  ///
  /// In en, this message translates to:
  /// **'HIGH'**
  String get high;

  /// No description provided for @medium.
  ///
  /// In en, this message translates to:
  /// **'MEDIUM'**
  String get medium;

  /// No description provided for @low.
  ///
  /// In en, this message translates to:
  /// **'LOW'**
  String get low;

  /// No description provided for @getting.
  ///
  /// In en, this message translates to:
  /// **'Getting Risk...'**
  String get getting;

  /// No description provided for @fireRisk.
  ///
  /// In en, this message translates to:
  /// **'Fire Risk'**
  String get fireRisk;

  /// No description provided for @floodRisk.
  ///
  /// In en, this message translates to:
  /// **'Flood Risk'**
  String get floodRisk;

  /// No description provided for @suquiHi.
  ///
  /// In en, this message translates to:
  /// **'Hi, I\'m Suqui! \n Data from {city}'**
  String suquiHi(Object city);

  /// No description provided for @weather.
  ///
  /// In en, this message translates to:
  /// **'Weather Data:'**
  String get weather;

  /// No description provided for @temperature.
  ///
  /// In en, this message translates to:
  /// **'Temperature: {temp} °C'**
  String temperature(Object temp);

  /// No description provided for @wind.
  ///
  /// In en, this message translates to:
  /// **'Wind Speed: {wind} km/h'**
  String wind(Object wind);

  /// No description provided for @humidity.
  ///
  /// In en, this message translates to:
  /// **'Humidity: {hum} %'**
  String humidity(Object hum);

  /// No description provided for @rain.
  ///
  /// In en, this message translates to:
  /// **'Rain: {rain} mm'**
  String rain(Object rain);

  /// No description provided for @rainRate.
  ///
  /// In en, this message translates to:
  /// **'Rain rate: {rainRate} mm/h'**
  String rainRate(Object rainRate);

  /// No description provided for @spi.
  ///
  /// In en, this message translates to:
  /// **'Spi: {spi}'**
  String spi(Object spi);

  /// No description provided for @noData.
  ///
  /// In en, this message translates to:
  /// **'No data found'**
  String get noData;

  /// No description provided for @fireTitleExplanation.
  ///
  /// In en, this message translates to:
  /// **'How the fire risk is calculated'**
  String get fireTitleExplanation;

  /// No description provided for @fireExplanation.
  ///
  /// In en, this message translates to:
  /// **'We developed an Artificial Intelligence model to estimate fire risk.\n This model analyzes environmental variables such as temperature, relative humidity, and wind speed to evaluate conditions that may favor the spread of fire.\n The data is obtained from the nearest and most up-to-date meteorological station.\n Based on this analysis, the risk is classified as Low, Medium, or High and is represented with colors to make it easier to understand.'**
  String get fireExplanation;

  /// No description provided for @floodTitleExplanation.
  ///
  /// In en, this message translates to:
  /// **'How we calculate flood risk'**
  String get floodTitleExplanation;

  /// No description provided for @floodExplanation.
  ///
  /// In en, this message translates to:
  /// **'The app analyzes rainfall and humidity conditions to help you understand the flood risk in your area.\n Factors such as the amount and intensity of rainfall, soil moisture, and the Standardized Precipitation Index (SPI) are taken into account, using data from the nearest and most up-to-date meteorological station.\n With this information, we estimate the probability of flooding and classify the risk as Low, Medium, or High, accompanied by colors for quick and clear reading.'**
  String get floodExplanation;

  /// No description provided for @tips.
  ///
  /// In en, this message translates to:
  /// **'Tips'**
  String get tips;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @settingTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingTitle;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error {error}'**
  String error(Object error);

  /// No description provided for @locationError.
  ///
  /// In en, this message translates to:
  /// **'Location Error'**
  String get locationError;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'es': return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
