import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/character.dart';
import '../models/episode.dart';

class ApiService {
  static const String baseUrl = 'https://rickandmortyapi.com/api';

  static Future<List<Character>> getCharacters({
    String? status,
    String? name,
  }) async {
    String url = '$baseUrl/character?';

    if (status != null && status != 'All') {
      url += 'status=${status.toLowerCase()}&';
    }

    // Tambahkan parameter name jika ada
    if (name != null && name.isNotEmpty) {
      url += 'name=$name&';
    }

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List results = data['results'];
      return results.map((json) => Character.fromJson(json)).toList();
    } else if (response.statusCode == 404) {
      // API Rick & Morty mengembalikan 404 jika karakter tidak ditemukan
      return [];
    } else {
      throw Exception('Gagal memuat data karakter');
    }
  }

  static Future<List<Episode>> getEpisodes() async {
    // Endpoint API untuk episode
    final response = await http.get(Uri.parse('$baseUrl/episode'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List results = data['results'];
      return results.map((json) => Episode.fromJson(json)).toList();
    } else {
      throw Exception('Gagal memuat data episode');
    }
  }
}
