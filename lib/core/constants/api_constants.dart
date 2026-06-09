// lib/core/constants/api_constants.dart

class ApiConstants {
  ApiConstants._();

  static const String apiToken = '60e797fb087d5fdb4a729d88bf9b2213';

  static const String baseUrl = 'https://superheroapi.com/api/$apiToken';

  static String searchUrl(String query) => '$baseUrl/search/$query';

  static String heroDetailUrl(int id) => '$baseUrl/$id';

  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 15);
}
