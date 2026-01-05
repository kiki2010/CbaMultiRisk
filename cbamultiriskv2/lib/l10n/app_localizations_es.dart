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
  String get fireTitleExplanation => 'Cómo se calcula el riesgo de incendio';

  @override
  String get fireExplanation => ' El riesgo de incendio se estima mediante nuestro modelo de Inteligencia Artificial. \n Este modelo analiza variables ambientales como la temperatura del aire, la humedad relativa y la velocidad del viento para evaluar condiciones que pueden favorecer la propagación del fuego. \n Los datos son obtenidos de la estación meteorológica más cercana. \n A partir de este análisis, el riesgo se clasifica en Bajo, Medio o Alto y se representa con colores para facilitar su interpretación.';

  @override
  String get floodTitleExplanation => 'Cómo se calcula el riesgo de inundación';

  @override
  String get floodExplanation => ' El riesgo de inundación se estima mediante nuestro modelo de Inteligencia Artificial. \n El modelo utiliza datos como la cantidad de lluvia, la intensidad de las precipitaciones, la humedad y el Índice de Precipitación Estandarizado (SPI) para evaluar la probabilidad de inundaciones \n Los datos son obtenidos de la estación meteorológica más cercana. \n El resultado se clasifica en Bajo, Medio o Alto y se muestra con colores para una lectura rápida y clara.';

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
