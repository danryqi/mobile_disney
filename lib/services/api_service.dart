import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/character_model.dart';

class ApiService {
  static const baseUrl = 'https://api.disneyapi.dev/character';

  /// Mengambil data karakter dari API Disney (ambil beberapa halaman hingga limit)
  Future<List<Character>> fetchCharacters({int limit = 50}) async {
    List<Character> all = [];
    int page = 1;

    while (all.length < limit) {
      try {
        final response = await http.get(Uri.parse('$baseUrl?page=$page'));

        if (response.statusCode != 200) break;
        final json = jsonDecode(response.body);

        // API Disney menggunakan struktur {"info": {}, "data": []}
        final List<dynamic> items = json['data'] ?? [];
        if (items.isEmpty) break;

        all.addAll(items.map((e) => Character.fromJson(e)).toList());

        print('Fetched ${items.length} items from page $page');
        page++;

        // stop kalau udah cukup
        if (items.length < 50 || all.length >= limit) break;
      } catch (e) {
        print('Error fetching page $page: $e');
        break;
      }
    }

    // potong biar gak lebih dari limit
    return all.take(limit).toList();
  }
}
