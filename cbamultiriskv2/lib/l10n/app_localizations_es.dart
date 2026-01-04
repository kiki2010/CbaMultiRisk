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
  String get fireTitleExplanation => 'Como se calcula el riesgo de incendio';

  @override
  String get fireExplanation => ' El riesgo de incendio es calculado usando nuestro modelo de Inteligencia Artificial. \n Usando datos de temperatura, humedad y velociddad del viento. \n El riesgo se clasifica en Alto, Medio o Bajo y también se indica con colores.';

  @override
  String get floodTitleExplanation => 'Como se calcula el riesgo de inundación';

  @override
  String get floodExplanation => ' El riesgo de inundaciones es calculado usando nuestro modelo de Inteligencia Artificial. \n Usando datos de lluvia, intensidad, humedad y SPI. \n El riesgo se clasifica en Alto, Medio o Bajo y también se indica con colores.';

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

  @override
  String get close => 'Cerrar';
}
