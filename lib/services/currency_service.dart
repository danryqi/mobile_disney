import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';

class CurrencyService {
  static const _cacheBox = 'currency_rates';
  static const _apiUrl =
      'https://api.exchangerate.host/latest?base=IDR&symbols=USD,EUR,JPY';

  Future<Map<String, double>> getRates() async {
    final box = await Hive.openBox(_cacheBox);

    try {
      final res = await http.get(Uri.parse(_apiUrl));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        final rates = Map<String, double>.from(data['rates']);
        await box.put('latest', rates); // cache ke Hive
        return rates;
      }
    } catch (_) {
      // ignore — kalau gagal ambil, pakai cache
    }

    final cached = box.get('latest');
    if (cached != null) {
      return Map<String, double>.from(cached);
    }
    // fallback kalau belum ada apa-apa
    return {'USD': 0.000064, 'EUR': 0.000059, 'JPY': 0.0095};
  }
}
