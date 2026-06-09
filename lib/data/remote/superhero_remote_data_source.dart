// lib/data/remote/superhero_remote_data_source.dart

import 'package:dio/dio.dart';
import '../../core/constants/api_constants.dart';
import '../../core/network/dio_client.dart';
import '../../domain/models/superhero_model.dart';

class SuperheroRemoteDataSource {
  final Dio _dio;

  SuperheroRemoteDataSource() : _dio = DioClient.instance;

  // ── 1. Search ─────────────────────────────────────────────
  /// Searches for heroes by name.  Returns an empty list if API
  /// responds with response:"error" (no heroes found).
  Future<List<SuperheroModel>> searchHeroes(String query) async {
    final url = ApiConstants.searchUrl(query);
    final response = await _dio.get<Map<String, dynamic>>(url);

    final data = response.data;
    if (data == null) throw Exception('Empty response from server.');

    // API returns {"response":"error","error":"character with given name not found"}
    if (data['response'] == 'error') return [];

    final results = data['results'] as List<dynamic>? ?? [];
    return results
        .map((e) => SuperheroModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // ── 2. Detail ─────────────────────────────────────────────
  /// Fetches full details for a single hero by numeric [id].
  Future<SuperheroModel> getHeroDetail(int id) async {
    final url = ApiConstants.heroDetailUrl(id);
    final response = await _dio.get<Map<String, dynamic>>(url);

    final data = response.data;
    if (data == null) throw Exception('Empty response from server.');
    if (data['response'] == 'error') {
      throw Exception(data['error'] ?? 'Hero not found.');
    }

    return SuperheroModel.fromJson(data);
  }
}
