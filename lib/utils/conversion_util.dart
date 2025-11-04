import 'package:intl/intl.dart';

/// Konversi Zona Waktu
String convertTimeZone(DateTime time, String zone) {
  int offset;
  switch (zone.toUpperCase()) {
    case 'WITA':
      offset = 8;
      break;
    case 'WIT':
      offset = 9;
      break;
    case 'LONDON':
      offset = 0;
      break;
    default: // WIB
      offset = 7;
  }

  final converted = time.toUtc().add(Duration(hours: offset));
  final formatted = DateFormat('dd MMM yyyy, HH:mm').format(converted);
  return '$formatted ($zone)';
}

/// Konversi Mata Uang
double convertCurrency(double value, String from, String to) {
  const rates = {
    'IDR': 1.0,
    'USD': 0.000064,
    'EUR': 0.000059,
    'JPY': 0.0095,
  };
  if (!rates.containsKey(from) || !rates.containsKey(to)) return value;
  return value / rates[from]! * rates[to]!;
}

String formatCurrency(double value, String currency) {
  switch (currency.toUpperCase()) {
    case 'USD':
      return '\$${value.toStringAsFixed(2)}';
    case 'EUR':
      return '€${value.toStringAsFixed(2)}';
    case 'JPY':
      return '¥${value.toStringAsFixed(0)}';
    default:
      return 'Rp ${value.toStringAsFixed(0)}';
  }
}

String formatCoins(int coins) {
  final formatter = NumberFormat('#,###', 'id_ID');
  return '🪙 ${formatter.format(coins)} Coins';
}