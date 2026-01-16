// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get disclaimer => 'Disclaimer';

  @override
  String get disclaimerText => 'Esta app esta diseñada para predecir la probabilidad de riesgo de incendio e inundaciones usando fuentes meteorologicas externas.\n  Para medidades de evacuación y seguridad reales, siga las instrucciones de las autoridades locales.\n Los desarrolladores no se responsabiliazn de ningún daño o pérdida durante el uso de la app.';

  @override
  String get understand => 'Lo entiendo';

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
  String get fireExplanation => ' Desarollamos un modelo de Inteligencia Artificial para estimar el riesgo de incendio. \n Este modelo analiza variables ambientales como la temperatura, la humedad relativa y la velocidad del viento para evaluar condiciones que pueden favorecer la propagación del fuego. \n Los datos son obtenidos de la estación meteorológica más cercana y actualizada. \n A partir de este análisis, el riesgo se clasifica en Bajo, Medio o Alto y se representa con colores para facilitar su interpretación.';

  @override
  String get floodTitleExplanation => 'Cómo calculamos el riesgo de inundación';

  @override
  String get floodExplanation => 'La app analiza las condiciones de lluvia y humedad para ayudarte a comprender el riesgo de inundación en tu zona.\n Se tienen en cuenta factores como la cantidad e intensidad de las precipitaciones, la humedad del suelo y el Índice de Precipitación Estandarizado (SPI), utilizando datos de la estación meteorológica más cercana y actualizada.\n Con esta información, estimamos la probabilidad de que ocurran inundaciones y clasificamos el riesgo como Bajo, Medio o Alto, acompañado de colores para una lectura rápida y clara.';

  @override
  String get tips => 'Tips';

  @override
  String gameTitle(Object highScore, Object lastScore) {
    return 'Responde todas las preguntas que puedas en 60 segundos. \n | Tu puntuación más alta es: $highScore | \n | Tu última puntuación es: $lastScore | ';
  }

  @override
  String get play => ' Jugar ';

  @override
  String score(Object score) {
    return ' Puntos: $score';
  }

  @override
  String get trueAnswer => ' Verdadero ';

  @override
  String get falseAnswer => ' Falso ';

  @override
  String get settings => 'Ajustes';

  @override
  String get settingTitle => 'Ajustes';

  @override
  String get darkMode => 'Modo Oscuro';

  @override
  String get language => 'Idioma';

  @override
  String get notifications => 'Notificaciones';

  @override
  String error(Object error) {
    return 'Error $error';
  }

  @override
  String get locationError => 'Error de Ubicación';

  @override
  String get close => 'Cerrar';
}
