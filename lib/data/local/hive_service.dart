// lib/data/local/hive_service.dart

import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import '../../domain/models/superhero_model.dart';

class HiveService {
  static const String _searchBoxName  = 'search_cache';
  static const String _detailBoxName  = 'hero_detail_cache';

  // ── Initialise ────────────────────────────────────────────
  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox<String>(_searchBoxName);
    await Hive.openBox<String>(_detailBoxName);
  }

  Box<String> get _searchBox  => Hive.box<String>(_searchBoxName);
  Box<String> get _detailBox  => Hive.box<String>(_detailBoxName);

  // ── Search cache ──────────────────────────────────────────

  /// Persist a list of heroes under a search key (e.g. "batman")
  Future<void> cacheSearchResults(
      String query, List<SuperheroModel> heroes) async {
    final encoded = jsonEncode(heroes.map((h) => h.toJson()).toList());
    await _searchBox.put(query.toLowerCase(), encoded);
  }

  /// Returns cached results for [query], or null if not found.
  List<SuperheroModel>? getCachedSearch(String query) {
    final raw = _searchBox.get(query.toLowerCase());
    if (raw == null) return null;
    final List decoded = jsonDecode(raw) as List;
    return decoded
        .map((e) => SuperheroModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // ── Detail cache ──────────────────────────────────────────

  Future<void> cacheHeroDetail(SuperheroModel hero) async {
    final encoded = jsonEncode(hero.toJson());
    await _detailBox.put(hero.id.toString(), encoded);
  }

  SuperheroModel? getCachedDetail(int id) {
    final raw = _detailBox.get(id.toString());
    if (raw == null) return null;
    return SuperheroModel.fromJson(
        jsonDecode(raw) as Map<String, dynamic>);
  }

  // ── Housekeeping ──────────────────────────────────────────
  Future<void> clearAll() async {
    await _searchBox.clear();
    await _detailBox.clear();
  }
}
