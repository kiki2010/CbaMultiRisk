// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get locationDisclaimerTitle => 'Se requiere acceso a la ubicación';

  @override
  String get locationDisclaimer => 'Usamos tu ubicación incluso cuando la aplicación está cerrada para calcular riesgos cercanos y enviarte alertas.';

  @override
  String get locationNotNow => 'Ahora no';

  @override
  String get locationOk => 'Permitir';

  @override
  String get needLocation => 'Necesitamos el permiso de ubicación';

  @override
  String get tutorialWelcome1 => 'Bienvenido a Cba MultiRisk, una app que te permite conocer el riesgo de incendios e inundaciones en tu zona.';

  @override
  String get tutorialWelcome2 => 'Ahora exploraremos las pantallas de la app, para que no te pierdas ningún detalle';

  @override
  String get tutorialWelcome3 => 'Recuerda que puedes volver a ver este tutorial desde la pantalla de Configuración.';

  @override
  String get tutorialWelcome4 => 'Estas por entrar a la pantalla de Riesgo, en esta pantalla podras ver el riesgo de incendio e inundación, también podras conocer como se calcula tocandolos.';

  @override
  String get tutorialWelcome5 => 'Esta pantalla también te muestra de donde obtenemos los datos meteorológicos para calcular el riesgo y el pronóstico de los próximos tres días.';

  @override
  String get tutorialWelcome6 => 'Cuando estes listo nos vemos en la pantalla de Tips!';

  @override
  String get tutorialSuqui1 => '¡Esta es mi pantalla!';

  @override
  String get tutorialSuqui2 => 'Aquí te mostraré tips para que sepas cómo prepararte y cómo actuar en caso de un incendio o una inundación. También compartiré algunos consejos para cuidar el mundo juntos.';

  @override
  String get tutorialSuqui3 => 'Y cuando quieras poner tus conocimientos a prueba, podemos jugar y ver cuántas preguntas puedes responder en 60 segundos.';

  @override
  String get tutorialSuqui4 => 'Para terminar el tutorial, nos vemos en la pantalla de Ajustes.';

  @override
  String get tutorialSetting1 => '¡Esta es la pantalla de Ajustes!';

  @override
  String get tutorialSetting2 => 'Aquí podrás cambiar aspectos clave de la app, como el idioma, el tema y las notificaciones.';

  @override
  String get tutorialSetting3 => 'También puedes volver a ver el aviso legal y restablecer la aplicación.';

  @override
  String get tutorialSetting4 => 'Es importante que recuerdes configurar los botones de emergencia para poder acceder a ellos en cualquier momento.';

  @override
  String get tutorialLast1 => 'Recorriste toda la app.';

  @override
  String get tutorialLast2 => 'Como última recomendación, te aconsejo ir a los ajustes del dispositivo, permitir las notificaciones y habilitar el acceso a la ubicación en segundo plano.';

  @override
  String get tutorialLast3 => '¡Nosotros no vamos a almacenar esta información!';

  @override
  String get tutorialLast4 => 'Recuerda seguirnos en nuestro Instagram @cbaMultiRisk.';

  @override
  String get tutorialLast5 => '¡Y dejarnos una opinión positiva en la Play Store!';

  @override
  String get disclaimer => 'Exención de Responsabilidad';

  @override
  String get disclaimerText => 'Esta app está diseñada para predecir la probabilidad de riesgo de incendios e inundaciones usando fuentes meteorológicas externas.\n  Para medidas de evacuación y seguridad reales, siga las instrucciones de las autoridades locales.\n Los desarrolladores no se responsabilizan de ningún daño o pérdida durante el uso de la app.';

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
    return 'Hola, soy Suqui! \n información de la estación más cercana en $city.';
  }

  @override
  String get weather => 'Datos Meteorológicos locales:';

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
  String get cienciaCiudadana => 'Información basada en registros de estaciones meteorológicas de ciencia ciudadana.';

  @override
  String get noData => 'No se encontraron datos';

  @override
  String get fireTitleExplanation => 'Cómo se calcula el riesgo de incendio';

  @override
  String get fireExplanation => 'Desarrollamos un modelo de Inteligencia Artificial para estimar el riesgo de incendio. \n Este modelo analiza variables ambientales como la temperatura, la humedad relativa y la velocidad del viento para evaluar condiciones que pueden favorecer la propagación del fuego. \n Los datos se obtienen de la estación meteorológica más cercana y actualizada. \n A partir de este análisis, el riesgo se clasifica en Bajo, Medio o Alto, y se representa con colores para facilitar su interpretación.';

  @override
  String get floodTitleExplanation => 'Cómo calculamos el riesgo de inundación';

  @override
  String get floodExplanation => 'La app analiza las condiciones de lluvia y humedad para ayudarte a comprender el riesgo de inundación en tu zona.\n Se tienen en cuenta factores como la cantidad e intensidad de las precipitaciones, la humedad del suelo y el Índice de Precipitación Estandarizado (SPI), utilizando datos de la estación meteorológica más cercana y actualizada.\n Con esta información, estimamos la probabilidad de que ocurran inundaciones y clasificamos el riesgo como Bajo, Medio o Alto, acompañado de colores para una lectura rápida y clara.';

  @override
  String get tips => 'Tips';

  @override
  String get play => ' Jugar ';

  @override
  String gameTitleHigh(Object highScore, Object lastScore) {
    return 'Responde todas las preguntas que puedas en 60 segundos. \n | Tu puntuación más alta es: $highScore | \n | Tu última puntuación es: $lastScore | \n ¡Felicitaciones! Tu riesgo puede ser más bajo que el estimado.';
  }

  @override
  String gameTitleLow(Object highScore, Object lastScore) {
    return 'Responde todas las preguntas que puedas en 60 segundos. \n | Tu puntuación más alta es: $highScore | \n | Tu última puntuación es: $lastScore | \n Tu riesgo puede ser más alto que el estimado.';
  }

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
  String phoneSetUp(Object title) {
    return 'Configurar: $title';
  }

  @override
  String get firefighters => 'Bomberos';

  @override
  String get emergency => 'Emergencias';

  @override
  String get ambulance => 'Ambulancia';

  @override
  String get resetAll => 'Restablecer aplicación';

  @override
  String get resetWarning => 'La aplicación se restablecerá';

  @override
  String get reset => 'Las preferencias guardadas de la aplicación se eliminarán.';

  @override
  String get feedback => 'Formulario de opinión';

  @override
  String error(Object error) {
    return 'Error $error';
  }

  @override
  String get locationError => 'Error de Ubicación';

  @override
  String get lastKnowRisk => 'No pudimos obtener datos actuales. \n El último riesgo registrado fue:';

  @override
  String get close => 'Cerrar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get save => 'Guardar';
}
