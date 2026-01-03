// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get risk => 'Riesgo';

  @override
  String get high => 'ALTO';

  @override
  String get medium => 'MEDIO';

  @override
  String get low => 'BAJO';

  @override
  String get getting => 'Calculando';

  @override
  String get fireRisk => 'Riesgo Incendios';

  @override
  String get floodRisk => 'Riesgo Inundaciones';

  @override
  String suquiHi(Object city) {
    return 'Hola, soy Suqui! \n Datos de $city';
  }

  @override
  String get weather => 'Datos Meteorológicos:';

  @override
  String temperature(Object temp) {
    return 'Temperatura: $temp °C';
  }

  @override
  String wind(Object wind) {
    return 'Velocidad del Viento: $wind km/h';
  }

  @override
  String humidity(Object hum) {
    return 'Humedad: $hum %';
  }

  @override
  String rain(Object rain) {
    return 'Lluvia: $rain mm';
  }

  @override
  String rainRate(Object rainRate) {
    return 'Intensidad Lluvias: $rainRate mm/h';
  }

  @override
  String spi(Object spi) {
    return 'Spi: $spi';
  }

  @override
  String get noData => 'No se encontraron datos';

  @override
  String get tips => 'Tips';

  @override
  String get settings => 'Ajustes';

  @override
  String get settingTitle => 'Ajustes';

  @override
  String get darkMode => 'Modo Oscuro';

  @override
  String get language => 'Idioma';

  @override
  String get error => 'Error';
}
