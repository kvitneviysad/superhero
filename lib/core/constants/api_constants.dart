// lib/core/constants/api_constants.dart

class ApiConstants {
  ApiConstants._();

  static const String apiToken = '60e797fb087d5fdb4a729d88bf9b2213';

  // Базовий URL залишаємо порожнім, бо DioClient.instance використовує свій baseUrl з 'www.' та 'api.php/'
  static const String baseUrl = 'https://www.superheroapi.com/api.php/$apiToken/';

  // Тільки відносні шляхи, щоб Dio не ігнорував налаштування проксі/домену
  static String searchUrl(String query) => 'search/$query';
  static String heroDetailUrl(int id) => '$id';

  // Тайм-аути для запитів
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}
